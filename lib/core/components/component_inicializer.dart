import 'package:simulop_v1/core/components/materials/tube/tube_material.dart';
import 'package:simulop_v1/core/components/materials/liquid/liquid_material.dart';

/// Inicializer of components.
class Inicializer {
  static LiquidMaterial liquidMaterial(String material) {
    double density;
    double viscosity;
    List<double> antoineCoef;

    switch (material.toLowerCase()) {
      case "water":
        density = 1000.0;
        viscosity = 8.90E-4;
        antoineCoef = [4.6543, 1435.264, -64.848];
        break;
      case "benzene":
        density = 868.0;
        viscosity = 5.62E-4;
        antoineCoef = [4.01814, 1203.835, -53.226];
        break;
      case "toluene":
        density = 862.1;
        viscosity = 5.60E-4;
        antoineCoef = [4.14157, 1377.578, -50.507];
        break;
      default:
        return null;
    }
    return new LiquidMaterial(material, density, viscosity, antoineCoef);
  }

  static TubeMaterial tubeMaterial(String material) {
    double roughness; // em cm

    switch (material.toLowerCase()) {
      case "steel":
        roughness = 0.00547;
        break;
      case "pvc":
        roughness = 0.006;
        break;
      case "copper":
        roughness = 0.0002;
        break;
      case "concrete":
        roughness = 0.2;
        break;
      default:
        roughness = 0.00547;
        break;
    }

    return new TubeMaterial(material, roughness / 100.0);
  }
}
