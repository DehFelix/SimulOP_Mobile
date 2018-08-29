import 'dart:math' as math;

import 'package:simulop_v1/core/components/materials/liquid/liquid_material.dart';
import 'package:simulop_v1/core/components/materials/tube/tube_material.dart';
import 'package:simulop_v1/core/interfaces/i_local_resistances.dart';
import 'package:simulop_v1/core/units_uo1/units_1.dart';

class Tube extends UnitsI {
  /// Lengh of the Tube (m).
  double lengh;

  /// Sum of the equivalent lenghs of all local resistances (m).
  double _equivalentLengh;

  /// Internal diametre of the tube (m).
  double _internalDiametre;

  /// Material of the tube.
  TubeMaterial _material;

  /// Relative Roughness of the tube (dimensionless).
  double _relativeRoughness;

  /// Darcy friction factor of the tube (dimensionless).
  double _frictionFactor;

  /// Elevation difence betwen the entry and exit of the tube (m).
  double elevationDiference;

  /// List of [ILocalResistance] in the pipe.
  List<ILocalResistance> _localResistances;

  /// Presure drop of the pipe (m).
  double _pressureDrop;

  /// [FrictionFactorMethod] for compiting the friction factor.
  FrictionFactorMethod frictionMethod;

  /// Sum of the equivalent lenghs of all local resistances (m).
  double get equivalentLengh => _equivalentLengh;

  /// Material of the tube.
  TubeMaterial get material => _material;

  /// Relative Roughness of the tube (dimensionless).
  double get relativeRoughness => _relativeRoughness;

  /// Darcy friction factor of the tube (dimensionless).
  double get frictionFactor => _frictionFactor;

  /// List of [ILocalResistance] in the pipe.
  List<ILocalResistance> get localResistances => _localResistances;

  /// Presure drop of the pipe (m).
  double get pressureDrop => _pressureDrop;

  /// Internal diametre of the tube (m).
  double get internalDiametre => _internalDiametre;

  /// Internal diametre of the tube (m).
  set internalDiametre(double d) {
    if (d < 0.0) {
      _internalDiametre = d;
      _relativeRoughness = material.roughness / d;
    } else {
      throw Exception("Diametre must be > 0.");
    }
  }

  /// Creates a Tube to be use in the [UnitsI] scope.
  ///
  /// [internalDiametre] = lengh of the Tube (m).
  ///
  /// [lengh] = lengh of the Tube (m).
  ///
  /// [material] = material of the tube ([TubeMaterial]).
  ///
  /// [elevationDiference] = elevation difence betwen the entry and exit of the tube (m).
  ///
  /// [frictionMethod] = [FrictionFactorMethod] for compiting the friction factor.
  Tube(double internalDiametre, double lengh, TubeMaterial material,
      double elevationDiference,
      [FrictionFactorMethod frictionMethod = FrictionFactorMethod.fanning]) {
    _material = material;
    this.internalDiametre = internalDiametre;
    this.lengh = lengh;
    this.elevationDiference = elevationDiference;
    this.frictionMethod = frictionMethod;
  }

  /// Add the [ILocalResistance] to the list of local resistances.
  ///
  /// [res] = [ILocalResistance] to be added.
  void addLocalResistance(ILocalResistance res) {
    _localResistances.add(res);
    _updateEquivalentLengh();
  }

  /// Updates the [_equivalentLengh] of the [_localResistances].
  double _updateEquivalentLengh() {
    double eq = 0.0;

    for (var res in _localResistances) {
      eq = eq + res.equivalentLengh;
    }

    _equivalentLengh = eq;

    return eq;
  }

  /// Add all the [ILocalResistance] to the list of local resistances.
  ///
  /// [list] = list of [ILocalResistance] to be added.
  void addAllLocalResistances(List<ILocalResistance> list) {
    for (var res in list) {
      addLocalResistance(res);
    }
  }

  /// The Rynolds number of a flow.
  ///
  /// [material] = [LiquidMaterial] of the liquid flowing.
  /// 
  /// [volumeFlow] = Volumetric flow (m^3/s).
  double reynolds(LiquidMaterial material, double volumeFlow) {
    double re;

    re = (4 * material.density * volumeFlow) /
        (math.pi * material.viscosity * _internalDiametre);

    return re;
  }

  /// Computes the friction factor with the [frictionMethod].
  ///
  /// [material] = [LiquidMaterial] of the liquid flowing.
  /// 
  /// [volumeFlow] = Volumetric flow (m^3/s).
  double _computFrictionFactor(LiquidMaterial material, double volumeFlow) {
    double re;
    double a1;
    double a2;
    double a;
    double b;
    double fA1;
    double fA2;
    double fA;
    double invSqrFA;

    switch (frictionMethod) {
      case FrictionFactorMethod.fanning:
        re = reynolds(material, volumeFlow);
        a1 = math.pow(7.0 / re, 0.9);
        a2 = 0.27 * _relativeRoughness;
        a = math.pow(-2.475 * math.log(a1 + a2) / math.ln10, 16.0);
        b = math.pow((37530 / re), 16.0);

        fA1 = math.pow(8.0 / re, 12.0);
        fA2 = 1 / math.pow(a + b, 3.0 / 2.0);

        fA = 2 * math.pow(fA1 + fA2, 1.0 / 12.0); // fator de fanning
        break;
      case FrictionFactorMethod.haaland:
        re = reynolds(material, volumeFlow);
        a = math.pow(_relativeRoughness / (3.7 * _internalDiametre), 1.11);
        b = 6.9 / re;

        invSqrFA = -3.6 * math.log(a + b) / math.ln10;
        fA = 1 / math.pow(invSqrFA, 2.0); // fator de fanning
        break;
      default:
        throw new Exception("Friction method $frictionMethod not expected.");
    }

    _frictionFactor = fA;

    return fA;
  }

  /// Computes the tube pressure drop.
  ///
  /// [material] = [LiquidMaterial] of the liquid flowing.
  /// 
  /// [volumeFlow] = Volumetric flow (m^3/s).
  double computePressureDrop(LiquidMaterial material, double volumeFlow) {
    _computFrictionFactor(material, volumeFlow);
    double totalLengh = lengh + _equivalentLengh;

    double averageVelocity =
        volumeFlow / (math.pi * math.pow(_internalDiametre / 2.0, 2.0));

    double presureDrop = 4 *
        _frictionFactor *
        (totalLengh / _internalDiametre) *
        (math.pow(averageVelocity, 2.0) / (2 * g));

    _pressureDrop = presureDrop;

    return presureDrop;
  }
}
