import 'package:simulop_v1/core/components/materials/material_type.dart';

/// Represents the material of the tube
class TubeMaterial extends MaterialType {
  double _roughness;

  double get roughness => _roughness;

  TubeMaterial(String name, double roughness) : super(name) {
    _roughness = roughness;
  }  
}