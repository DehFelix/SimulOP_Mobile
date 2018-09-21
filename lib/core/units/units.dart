import 'dart:math' as math;

class Units {
  static double get gStatic => 9.80665;

  double get g => 9.80665;

  static double findRoot(Function(double) fx, double lowerBound, double upperBound,
      [double accuracy = 1e-4, int maxIterations = 100]) {
    _Root root = _Root(false, 0.0);

    if (!_ZeroCorrsingBracketing.expandReduce(fx, lowerBound, upperBound))
      throw Exception("RootFindingFailed");

    if (_Bernet.tyFindRoot(
        root, fx, lowerBound, upperBound, accuracy, maxIterations)) {
      return root.value;
    }

    if (_Bisection.tyFindRoot(
        root, fx, lowerBound, upperBound, accuracy, maxIterations)) {
      return root.value;
    } else {
      throw Exception("RootFindingFailed");
    }
  }
}

/// Class and methods adaped from Math.Net Numerics (https://numerics.mathdotnet.com/)
class _ZeroCorrsingBracketing {
  static bool expand(Function(double) fx, double lowerBound, double upperBound,
      double expansionFactor, int maxIterations) {
    double originalLowerBound = lowerBound;
    double originalUpperBound = upperBound;

    if (lowerBound >= upperBound) {
      throw Exception("upperBound");
    }

    double fmin = fx(lowerBound);
    double fmax = fx(upperBound);

    for (int i = 0; i < maxIterations; i++) {
      if (fmin.sign != fmax.sign) {
        return true;
      }

      if (fmin.abs() < fmax.abs()) {
        lowerBound += 1.6 * (lowerBound - upperBound);
        fmin = fx(lowerBound);
      } else {
        upperBound += 1.6 * (upperBound - lowerBound);
        fmax = fx(upperBound);
      }
    }

    lowerBound = originalLowerBound;
    upperBound = originalUpperBound;
    return false;
  }

  static bool reduce(Function(double) fx, double lowerBound, double upperBound,
      int subdivisions) {
    double originalLowerBound = lowerBound;
    double originalUpperBound = upperBound;

    if (lowerBound >= upperBound) {
      throw Exception("upperBound");
    }

    double fmin = fx(lowerBound);
    double fmax = fx(upperBound);

    if (fmin.sign != fmax.sign) {
      return true;
    }

    double subdiv = (upperBound - lowerBound) / subdivisions;
    double smin = lowerBound;
    double sign = fmin.sign;

    for (int k = 0; k < subdivisions; k++) {
      double smax = smin + subdiv;
      double sfmax = fx(smax);
      if (sfmax.isInfinite) {
        // expand interval to include pole
        smin = smax;
        continue;
      }

      if (sfmax.sign != sign) {
        lowerBound = smin;
        upperBound = smax;
        return true;
      }

      smin = smax;
    }

    lowerBound = originalLowerBound;
    upperBound = originalUpperBound;
    return false;
  }

  static bool expandReduce(
      Function(double) func, double lowerBound, double upperBound,
      [double expansionFactor = 1.6,
      int expansionMaxIterations = 50,
      int reduceSubdivisions = 100]) {
    return (expand(func, lowerBound, upperBound, expansionFactor,
            expansionMaxIterations) ||
        reduce(func, lowerBound, upperBound, reduceSubdivisions));
  }
}

class _Root {
  bool converged;
  double value;

  _Root(this.converged, this.value);
}

/// Class and methods adaped from Math.Net Numerics (https://numerics.mathdotnet.com/)
class _Bernet {
  static bool tyFindRoot(_Root root, Function(double) f, double lowerBound,
      double upperBound, double accuracy, int maxIterations) {
    double fmin = f(lowerBound);
    double fmax = f(upperBound);
    double froot = fmax;
    double d = 0.0, e = 0.0;

    root.value = upperBound;
    double xMid = double.nan;

    for (int i = 0; i <= maxIterations; i++) {
      // adjust bounds
      if (froot.sign == fmax.sign) {
        upperBound = lowerBound;
        fmax = fmin;
        e = d = root.value - lowerBound;
      }

      if (fmax.abs() < froot.abs()) {
        lowerBound = root.value;
        root.value = upperBound;
        upperBound = lowerBound;
        fmin = froot;
        froot = fmax;
        fmax = fmin;
      }

      // convergence check
      double xAcc1 =
          (2.0 * math.pow(2.0, -53.0)) * root.value.abs() + 0.5 * accuracy;
      double xMidOld = xMid;
      xMid = (upperBound - root.value) / 2.0;

      if (xMid.abs() <= xAcc1 ||
          _almostEqualNormRelative(froot, 0.0, froot, accuracy)) {
        root.converged = true;
        return true;
      }

      if (xMid == xMidOld) {
        // accuracy not sufficient, but cannot be improved further
        return false;
      }

      if (e.abs() >= xAcc1 && fmin.abs() > froot.abs()) {
        // Attempt inverse quadratic interpolation
        double s = froot / fmin;
        double p;
        double q;
        if (_almostEqualNormRelative(lowerBound, upperBound,
            (lowerBound - upperBound), 2 * math.pow(2, -52))) {
          p = 2.0 * xMid * s;
          q = 1.0 - s;
        } else {
          q = fmin / fmax;
          double r = froot / fmax;
          p = s *
              (2.0 * xMid * q * (q - r) -
                  (root.value - lowerBound) * (r - 1.0));
          q = (q - 1.0) * (r - 1.0) * (s - 1.0);
        }

        if (p > 0.0) {
          // Check whether in bounds
          q = -q;
        }

        p = p.abs();
        if (2.0 * p <
            math.min(3.0 * xMid * q - (xAcc1 * q).abs(), (e * q).abs())) {
          // Accept interpolation
          e = d;
          d = p / q;
        } else {
          // Interpolation failed, use bisection
          d = xMid;
          e = d;
        }
      } else {
        // Bounds decreasing too slowly, use bisection
        d = xMid;
        e = d;
      }

      lowerBound = root.value;
      fmin = froot;
      if (d.abs() > xAcc1) {
        root.value += d;
      } else {
        root.value += _sign(xAcc1, xMid);
      }

      froot = f(root.value);
    }

    return false;
  }

  static num _sign(double a, double b) {
    return b >= 0 ? (a >= 0 ? a : -a) : (a >= 0 ? -a : a);
  }

  static bool _almostEqualNormRelative(
      double a, double b, double diff, double maximumError) {
    // If A or B are infinity (positive or negative) then
    // only return true if they are exactly equal to each other -
    // that is, if they are both infinities of the same sign.
    if (a.isInfinite || b.isInfinite) {
      return a == b;
    }

    // If A or B are a NAN, return false. NANs are equal to nothing,
    // not even themselves.
    if (a.isNaN || b.isNaN) {
      return false;
    }

    // If one is almost zero, fall back to absolute equality
    if (a.abs() < double.minPositive || b.abs() < double.minPositive) {
      return diff.abs() < maximumError;
    }

    if ((a == 0 && b.abs() < maximumError) ||
        (b == 0 && a.abs() < maximumError)) {
      return true;
    }

    return diff.abs() < maximumError * math.max(a.abs(), b.abs());
  }
}

/// Class and methods adaped from Math.Net Numerics (https://numerics.mathdotnet.com/)
class _Bisection {
  static bool tyFindRoot(_Root root, Function(double) f, double lowerBound,
      double upperBound, double accuracy, int maxIterations) {
    if (upperBound < lowerBound) {
      var t = upperBound;
      upperBound = lowerBound;
      lowerBound = t;
    }

    double fmin = f(lowerBound);
    if (fmin.sign == 0) {
      root.value = lowerBound;
      return true;
    }

    double fmax = f(upperBound);
    if (fmax.sign == 0) {
      root.value = upperBound;
      return true;
    }

    root.value = 0.5 * (lowerBound + upperBound);

    // bad bracketing?
    if (fmin.sign == fmax.sign) {
      return false;
    }

    for (int i = 0; i <= maxIterations; i++) {
      double froot = f(root.value);

      if (upperBound - lowerBound <= 2 * accuracy && froot.abs() <= accuracy) {
        return true;
      }

      if ((lowerBound == root.value) || (upperBound == root.value)) {
        // accuracy not sufficient, but cannot be improved further
        return false;
      }

      if (froot.sign == fmin.sign) {
        lowerBound = root.value;
        fmin = froot;
      } else if (froot.sign == fmax.sign) {
        upperBound = root.value;
        fmax = froot;
      } else {
        return true;
      }

      root.value = 0.5 * (lowerBound + upperBound);
    }

    return false;
  }
}
