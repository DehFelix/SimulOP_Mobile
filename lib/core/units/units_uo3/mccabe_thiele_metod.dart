import 'dart:math' as math;

import 'package:simulop_v1/core/components/liquid/liquid.dart';
import 'package:simulop_v1/core/units/units.dart';

class McCabeThieleMethod {
  BinaryMixture binaryMixture;
  double targetXD;
  double targetXB;
  double feedZf;
  double feedConditionQ;
  double refluxRatio;

  int numberStages;
  int idialStage;

  math.Point _pointP;

  math.Point get pointP => _pointP;

  McCabeThieleMethod(
      BinaryMixture binaryMixture,
      double targetXD,
      double targetXB,
      double feedZf,
      double feedConditionQ,
      double refluxRation) {
    this.binaryMixture = binaryMixture;
    this.targetXD = targetXD;
    this.targetXB = targetXB;
    this.feedZf = feedZf;
    this.feedConditionQ = feedConditionQ;
    this.refluxRatio = refluxRation;

    _pointP = math.Point(0.0, 0.0);

    computPointP();
  }

  double opCurve(double xLK) {
    if (_pointP.x == 0.0 && _pointP.y == 0.0) {
      computPointP();
    }

    if (xLK >= _pointP.x) {
      return _rectifyingSection(xLK);
    } else {
      return _strippingSection(xLK);
    }
  }

  double _zeroP(double xLK) {
    return (xLK * (feedConditionQ / (feedConditionQ - 1))) -
        (feedZf / (feedConditionQ - 1)) -
        ((xLK * refluxRatio) / (refluxRatio + 1) +
            (targetXD / (refluxRatio + 1)));
  }

  double _qLine(double xLK) {
    return xLK * (feedConditionQ / (feedConditionQ - 1)) -
        feedZf / (feedConditionQ - 1);
  }

  double _rectifyingSection(double xLK) {
    return xLK * refluxRatio / (refluxRatio + 1) + targetXD / (refluxRatio + 1);
  }

  double _strippingSection(double xLK) {
    return xLK * ((_pointP.y - targetXB) / (_pointP.x - targetXB)) +
        targetXB * (1 - ((_pointP.y - targetXB) / (_pointP.x - targetXB)));
  }

  void computPointP() {
    double x;
    double y;

    if (feedConditionQ != 1.0) {
      x = Units.findRoot(_zeroP, 0.0, 1.0);
      y = _qLine(x);
    } else {
      x = feedZf;
      y = _rectifyingSection(feedZf);
    }

    _pointP = math.Point(x, y);
  }

  List<math.Point> plotEquilibrium(int res) {
    double x, y;
    List<math.Point> plot = List<math.Point>();

    for (double xLK = 0.0; xLK <= 1.01; xLK = xLK + 1.0 / res) {
      x = xLK;
      y = binaryMixture.lkVaporComposition(xLK);

      plot.add(math.Point(x, y));
    }
    return plot;
  }

  List<math.Point> plotOpCurve(int res) {
    double x, y;
    List<math.Point> plot = List<math.Point>();

    computPointP();

    for (double xLK = 0.0; xLK <= 1.01; xLK = xLK + 1.0 / res) {
      if (xLK < _pointP.x && (xLK + 1.0 / res) > _pointP.x) {
        x = _pointP.x;
        y = _pointP.y;

        plot.add(math.Point(x, y));
      } else {
        x = xLK;
        y = opCurve(xLK);
        plot.add(math.Point(x, y));
      }
    }

    return plot;
  }

  List<math.Point> plotStages() {
    double x, y;
    List<math.Point> plot = List<math.Point>();

    double xLK = targetXD;
    double yLK, eq;

    double dis;

    computPointP();

    dis = (_pointP.x - xLK).abs();
    idialStage = 1;

    while (xLK >= targetXB) {
      if (plot.length > 100) {
        x = xLK;
        y = opCurve(xLK);
        plot.add(math.Point(x, y));
        return plot;
      }

      x = xLK;
      y = opCurve(xLK);
      yLK = y;
      plot.add(math.Point(x, y));      

      if ((_pointP.x - x).abs() < dis) {
        dis = (_pointP.x - x).abs();
        idialStage = ((plot.length - 1) ~/ 2);
      }

      double _opAndEqLine(double x) =>
          binaryMixture.lkVaporComposition(x) - yLK;

      try {
        eq = Units.findRoot(_opAndEqLine, 0.0, 1.0);
      } catch (e) {
        throw Exception("Convergency erro");
      }

      x = eq;
      y = yLK;
      plot.add(math.Point(x, y));

      xLK = eq;
    }

    x = xLK;
    y = opCurve(xLK);
    plot.add(math.Point(x, y));

    numberStages = ((plot.length - 1) ~/ 2);

    return plot;
  }
}
