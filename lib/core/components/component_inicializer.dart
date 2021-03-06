import 'package:simulop_v1/core/components/materials/tube/tube_material.dart';
import 'package:simulop_v1/core/components/materials/liquid/liquid_material.dart';
import 'package:simulop_v1/pages/helper_classes/options_input_helper.dart';

/// Inicializer of components.
class Inicializer {
  static LiquidMaterial liquidMaterial(LiquidHelper liquidHelp, {double temp = 298.15}) {
    double molarMass;
    List<double> antoineCoef;
    List<double> densityCoef;
    List<double> viscosityCoef;
    List<double> specificHeatCoef;
    List<double> thermalConductivityCoef;

    switch (liquidHelp.liquid) {
      case LiquidOptions.water:
        molarMass = 18.01;
        antoineCoef = [4.6543, 1435.264, -64.848];
        densityCoef = [0.3471, 0.274, 647.13, 0.28571];
        viscosityCoef = [-10.2158, 1792.5, 0.01773, -0.000012631];
        specificHeatCoef = [92.053, -0.039953, -0.00021103, 0.00000053469];
        thermalConductivityCoef = [-0.2758, 0.004612, -0.0000055391];
        break;
      case LiquidOptions.benzene:
        molarMass = 79.11;
        antoineCoef = [4.01814, 1203.835, -53.226];
        densityCoef = [0.3009, 0.2677, 562.16, 0.2818];
        viscosityCoef = [-7.4005, 1181.5, 0.014888, -1.3713e-5];
        specificHeatCoef = [-31.662, 1.3043, -0.0036078, 0.0000038243];
        thermalConductivityCoef = [-1.6846, 1.052, 562.16];
        break;
      case LiquidOptions.toluene:
        molarMass = 92.14;
        antoineCoef = [4.14157, 1377.578, -50.507];
        densityCoef = [0.29999, 0.27108, 591.79, 0.29889];
        viscosityCoef = [-5.1649, 810.68, 0.010454, -0.000010488];
        specificHeatCoef = [83.703, 0.51666, -0.001491, 0.0000019725];
        thermalConductivityCoef = [-1.6735, 0.9773, 591.79];
        break;
      default:
        return null;
    }
    return new LiquidMaterial(
        name: liquidHelp.name,
        temperature: temp,
        molarMass: molarMass,
        antoineCoef: antoineCoef,
        densityCoef: densityCoef,
        viscosityCoef: viscosityCoef,
        specificHeatCoef: specificHeatCoef,
        thermalConductivityCoef: thermalConductivityCoef);
  }

  static TubeMaterial tubeMaterial(MaterialHelper material) {
    double roughness; // in cm
    double thermalConductivity; // 

    switch (material.material) {
      case MaterialOptions.steel:
        roughness = 0.00547;
        thermalConductivity = 45.0;
        break;
      case MaterialOptions.pvc:
        roughness = 0.006;
        thermalConductivity = 10.0;
        break;
      case MaterialOptions.copper:
        roughness = 0.0002;
        thermalConductivity = 386.0;
        break;
      case MaterialOptions.concrete:
        roughness = 0.2;
        thermalConductivity = 2.0;
        break;
      default:
        roughness = 0.00547;
        thermalConductivity = 45.0;
        break;
    }

    return new TubeMaterial(material.name, roughness / 100.0, thermalConductivity);
  }
}
