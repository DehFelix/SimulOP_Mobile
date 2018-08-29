import 'package:simulop_v1/core/components/materials/material.dart';
import 'package:simulop_v1/core/interfaces/materials/liquid_material.dart';

/// Represents a pure liquid component
class LiquidMaterial extends Material implements ILiquidMaterial {

  double _temperature;
  double _density;
  double _viscosity;
  double _specificHeat;
  double _thermalConductivity;
  List<double> _antoineCoef;

  // TODO: implement temperature
  @override
  double get temperature => _temperature;

  @override
  set temperature(double t) {
    // TODO: implement
    if (t > 0.0) {
      _temperature = t;
    } else {
      throw Exception("Temperature in Kelvin, must be > 0");
    } 
  }

  // TODO: implement density
  @override
  double get density => _density;

  // TODO: implement viscosity
  @override
  double get viscosity => _viscosity;

  // TODO: implement specificHeat
  @override
  double get specificHeat => _specificHeat;

  // TODO: implement thermalConductivity
  @override
  double get thermalConductivity => _thermalConductivity;

  // TODO: implement antoineCoef
  @override
  List<double> get antoineCoef => _antoineCoef;

  LiquidMaterial(String name, double density, double viscosity) : super(name) {
    this._density = density;
    this._viscosity = viscosity;
    throw Exception(); // TODO
  }

  @override
  ILiquidMaterial clone() {
    // TODO: implement clone
    throw Exception(); // TODO
  }
}