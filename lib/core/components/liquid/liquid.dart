import 'dart:math' as math;

import 'package:simulop_v1/core/units/units.dart';
import 'package:simulop_v1/core/interfaces/materials/i_liquid_material.dart';

/// Represents the liquid component
class Liquid {
  ILiquidMaterial _material;
  double _temperature;
  double _vaporPressure;

  ILiquidMaterial get material => _material;

  double get temperature => _temperature;

  set temperature(double t) {
    material.temperature = t;
    _temperature = t;
    _vaporPressure = pVap(t);
  }

  double get vaporPressure => _vaporPressure;

  Liquid(ILiquidMaterial material, double t) {
    _material = material;
    temperature = t;
  }

  double pVap(double t) {
    double pVap;

    if (_material.antoineCoef != null && _material.antoineCoef.isNotEmpty) {
      pVap = math.pow(
          10.0, _material.antoineCoef[0] -
              (_material.antoineCoef[1] / (_material.antoineCoef[2] + t)));
    } else {
      pVap = 0.0;
    }

    return pVap * 1e5;
  }

  /// Converts the given pressure (Pa) to meters of liquid
  double convertPressureToM(double pressure){
    double pressureInM;

    pressureInM = pressure / (this.material.density * Units.gStatic);
    return pressureInM;
  }

  Liquid clone() {
    return new Liquid(_material.clone(), _temperature);
  }
}
