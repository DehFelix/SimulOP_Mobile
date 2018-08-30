import 'dart:math' as math;

import 'package:simulop_v1/core/units/units.dart';

/// Abstract class for all OUI units
abstract class UnitsI extends Units {
  double reynoldsNumber(
      double density, double viscosity, double volumeFlow, double diametre) {
    double re;

    re = (4 * density * volumeFlow) / (math.pi * viscosity * diametre);

    return re;
  }
}

enum FrictionFactorMethod {fanning, haaland}
