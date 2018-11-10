import 'package:flutter/foundation.dart';
import 'dart:math' as math;

import 'package:simulop_v1/core/components/materials/material_type.dart';
import 'package:simulop_v1/core/interfaces/materials/i_liquid_material.dart';

/// Represents a pure liquid component
class LiquidMaterial extends MaterialType implements ILiquidMaterial {
  double _molarMass;
  double _temperature;
  double _density;
  double _viscosity;
  double _specificHeat;
  double _thermalConductivity;
  List<double> _antoineCoef;
  List<double> _densityCoef;
  List<double> _viscosityCoef;
  List<double> _specificHeatCoef;
  List<double> _thermalConductivityCoef;

  double get molarMass => _molarMass;

  @override
  double get temperature => _temperature;

  @override
  set temperature(double t) {
    if (t > 0.0) {
      _temperature = t;
      _updateProprieties(t);
    } else {
      throw Exception("Temperature in Kelvin, must be > 0");
    }
  }

  @override
  double get density => _density;

  @override
  double get viscosity => _viscosity;

  @override
  double get specificHeat => _specificHeat;

  @override
  double get thermalConductivity => _thermalConductivity;

  @override
  double get pr => specificHeat * viscosity / thermalConductivity;

  @override
  List<double> get antoineCoef => _antoineCoef;

  List<double> get densityCoef => _densityCoef;

  List<double> get specificHeatCoef => _specificHeatCoef;

  List<double> get thermalConductivityCoef => _thermalConductivityCoef;

  List<double> get viscosityCoef => _viscosityCoef;

  LiquidMaterial(
      {@required String name,
      @required double molarMass,
      @required double temperature,
      @required List<double> antoineCoef,
      @required List<double> densityCoef,
      @required List<double> specificHeatCoef,
      @required List<double> thermalConductivityCoef,
      @required List<double> viscosityCoef})
      : super(name) {
    _molarMass = molarMass;
    _antoineCoef = antoineCoef;
    _densityCoef = densityCoef;
    _viscosityCoef = viscosityCoef;
    _specificHeatCoef = specificHeatCoef;
    _thermalConductivityCoef = thermalConductivityCoef;
    this.temperature = temperature;
  }

  void _updateProprieties(double t) {
    _updateDensity(t);
    _updateViscosity(t);
    _updateSpecificHeat(t);
    _updaTethermalConductivity(t);
  }

  void _updateDensity(double t) {
    double d;
    // Density in g/ml
    d = _densityCoef[0] *
        math.pow(_densityCoef[1],
            -math.pow((1 - _temperature / _densityCoef[2]), _densityCoef[3]));

    _density = d * 1000.0; // Density in Kg/m^3
  }

  void _updateViscosity(double t) {
    double v;
    // Viscosity in cP
    v = math.pow(
        10.0,
        (_viscosityCoef[0] +
            _viscosityCoef[1] / t +
            (_viscosityCoef[2] * t) +
            _viscosityCoef[3] * math.pow(t, 2.0)));

    _viscosity = v / 1000.0; // Viscosity in Pa*s.
  }

  void _updateSpecificHeat(double t) {
    double cp;
    // Specific Heat in J/mol K
    cp = _specificHeatCoef[0] +
        _specificHeatCoef[1] * t +
        _specificHeatCoef[2] * math.pow(t, 2) +
        _specificHeatCoef[3] * math.pow(t, 3);

    _specificHeat = cp * (1000.0 / _molarMass); // Cp in j/Kg k
  }

  void _updaTethermalConductivity(double t) {
    double k;

    // Thermal Conductivity in W/m K
    switch (name.toLowerCase()) {
      case "water":
        k = _thermalConductivityCoef[0] +
            _thermalConductivityCoef[1] * t +
            _thermalConductivityCoef[2] * math.pow(t, 2);
        break;
      default:
        k = math.pow(
            10,
            _thermalConductivityCoef[0] +
                _thermalConductivityCoef[1] *
                    math.pow(1 - t / _thermalConductivityCoef[2], 2.0 / 7.0));
        break;
    }
    _thermalConductivity = k;
  }

  @override
  ILiquidMaterial clone() {
    return new LiquidMaterial(
        name: this.name,
        molarMass: _molarMass,
        temperature: _temperature,
        antoineCoef: _antoineCoef,
        densityCoef: _densityCoef,
        viscosityCoef: _viscosityCoef,
        specificHeatCoef: _specificHeatCoef,
        thermalConductivityCoef: _thermalConductivityCoef);
  }
}

class ApiOilMaterial extends MaterialType implements ILiquidMaterial {
  double apiDegree;
  double _temperature;
  double _density;
  double _viscosity;
  double _specificHeat;
  double _thermalConductivity;
  List<double> _antoineCoef = List<double>();

  double get temperature => _temperature;

  set temperature(double t) {
    _temperature = t;
    _updateProprieties(t);
  }

  @override
  double get density => _density;

  @override
  double get viscosity => _viscosity;

  @override
  double get specificHeat => _specificHeat;

  @override
  double get thermalConductivity => _thermalConductivity;

  @override
  double get pr => specificHeat * viscosity / thermalConductivity;

  @override
  List<double> get antoineCoef => _antoineCoef;

  ApiOilMaterial({@required double apiDegree, @required double temperature, String locName = ""})
      : super("$locName $apiDegree° API") {
    this.apiDegree = apiDegree;
    this.temperature = temperature;
  }

  void _updateProprieties(double t) {
    _updateDensity(t);
    _updateViscosity(t);
    _updateSpecificHeat(t);
    _updaTethermalConductivity(t);
  }

  void _updateDensity(double t) {
    double den;

    den = 141.5 / (apiDegree + 131.5);
    den = den * 999.0; // Density in Kg/m^3

    _density = den;
  }

  void _updateViscosity(double t) {
    double vis;
    double tempInF = 1.8 * t - 459.67;

    double a1, a2, ex;

    a1 = 0.32 + (1.8 * math.pow(10.0, 7.0)) / math.pow(apiDegree, 4.53);
    a2 = 360.0 / (tempInF + 200.0);
    ex = math.exp(0.43 + (8.33 / apiDegree));

    a2 = math.pow(a2, ex);

    vis = a1 * a2;

    _viscosity = vis; // Vis in Pa*s
  }

  void _updateSpecificHeat(double t) {
    double cp;
    double tempInF = 1.8 * t - 459.67;
    double a1, a2;

    a1 = apiDegree * (-1.39 * math.pow(10.0, -6.0)) * tempInF +
        1.847 * math.pow(10.0, -3.0);
    a2 = 6.312 * math.pow(10.0, -4.0) * tempInF;
    cp = a1 * a2 + 0.352;

    cp = cp * 4186.798188; // cp in J/Kg K

    _specificHeat = cp;
  }

  void _updaTethermalConductivity(double t) {
    double k;

    k = 0.826855 * (apiDegree + 131.5) * (0.85258 - 0.00054 * t);

    k = k / 1000.0;

    _thermalConductivity = k; // K in W/m K
  }

  @override
  ILiquidMaterial clone() {
    return new ApiOilMaterial(apiDegree: apiDegree, temperature: temperature);
  }
}
