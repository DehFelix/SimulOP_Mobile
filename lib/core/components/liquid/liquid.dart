import 'package:flutter/foundation.dart';
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

  Liquid({@required ILiquidMaterial material, @required double temperature}) {
    _material = material;
    this.temperature = temperature;
  }

  double pVap(double t) {
    double pVap;

    if (_material.antoineCoef != null && _material.antoineCoef.isNotEmpty) {
      pVap = math.pow(
          10.0,
          _material.antoineCoef[0] -
              (_material.antoineCoef[1] / (_material.antoineCoef[2] + t)));
    } else {
      pVap = 0.0;
    }

    return pVap * 1e5;
  }

  /// Converts the given pressure (Pa) to meters of liquid
  double convertPressureToM(double pressure) {
    double pressureInM;

    pressureInM = pressure / (this.material.density * Units.gStatic);
    return pressureInM;
  }

  Liquid clone() {
    return new Liquid(
      material: _material.clone(),
      temperature: _temperature
    );
  }
}

/// Represents a binary mixture
class BinaryMixture {
  Liquid lkLiquid;
  Liquid hkLiquid;
  List<String> componentes = List<String>(2);

  double pressure;

  List<double> liquidComposition = List<double>(2);
  List<double> vaporComposition = List<double>(2);

  double _alpha;
  double _temperature;

  double get alpha => _alpha;

  double get temperature => _temperature;

  set temperature(double t) {
    _temperature = t;
    lkLiquid.temperature = t;
    hkLiquid.temperature = t;
  }

  BinaryMixture(Liquid lkLiquid, Liquid hkLiquid, double xLK,
      double temperature, double pressure) {
    this.lkLiquid = lkLiquid;
    componentes[0] = lkLiquid.material.name;
    this.hkLiquid = hkLiquid;
    componentes[1] = hkLiquid.material.name;

    this.temperature = temperature;
    this.pressure = pressure;

    this.liquidComposition = [xLK, 1 - xLK];

    lkVaporComposition(xLK);
  }

  double lkVaporComposition(double xLK) {
    liquidComposition[0] = xLK;
    liquidComposition[1] = 1 - xLK;

    double _sumOfPartialPressures(double t) =>
        xLK * lkLiquid.pVap(t) + (1 - xLK) * hkLiquid.pVap(t) - pressure;

    double temp;

    temp = Units.findRoot(_sumOfPartialPressures, 100.0, 500.0);

    temperature = temp;

    _alpha = lkLiquid.vaporPressure / hkLiquid.vaporPressure;

    double yLK = (_alpha * xLK) / (1 + xLK * (_alpha - 1));

    vaporComposition[0] = yLK;
    vaporComposition[1] = 1 - yLK;

    return yLK;
  }
}
