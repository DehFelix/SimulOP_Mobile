import 'package:simulop_v1/core/components/materials/material_type.dart';

/// Represents the material of the tube
class TubeMaterial extends MaterialType {
  double _roughness;
  double _thermalConductivity; 

  double get roughness => _roughness;
  double get thermalConductivity => _thermalConductivity; 

  TubeMaterial(String name, double roughness, double thermalConductivity) : super(name) {
    _roughness = roughness;
    _thermalConductivity = thermalConductivity;
  }  
}