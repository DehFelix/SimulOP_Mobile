import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:simulop_v1/core/core.dart' as core;
import 'package:simulop_v1/pages/unit_operation_3/mccabe_thiele_method/simulation_data.dart';

class McCabeThieleInputData extends Model {
  final MixtureInput input;

  McCabeThieleInputData({this.input});

  static McCabeThieleInputData of(BuildContext context) =>
      ScopedModel.of<McCabeThieleInputData>(context);

  void setLiquidLKName(String name) {
    input.liquidLK = name;
    notifyListeners();
  }

  void setLiquidHKName(String name) {
    input.liquidHK = name;
    notifyListeners();
  }

  double get getAlpha {
    if (input.validateInput()) {
      var tempMixture = core.BinaryMixture(
          core.Liquid(
              material: core.Inicializer.liquidMaterial(input.liquidLK),
              temperature: 298.0),
          core.Liquid(
              material: core.Inicializer.liquidMaterial(input.liquidHK),
              temperature: 298.0),
          0.5,
          298.0,
          1e5);
      return tempMixture.alpha;
    } else {
      return 0.0;
    }
  }

  bool canCreateSimulation() {
    if (input.validateInput() && getAlpha > 1.0) {
      return true;
    } else {
      return false;
    }
  }

  McCabeThieleSimulation createSimulation() {
    final McCabeThieleSimulation simulation = McCabeThieleSimulation();

    final liquidLK = core.Liquid(
        material: core.Inicializer.liquidMaterial(input.liquidLK),
        temperature: 298.0);
    final liquidHK = core.Liquid(
        material: core.Inicializer.liquidMaterial(input.liquidHK),
        temperature: 298.0);
    final mixture = core.BinaryMixture(liquidLK, liquidHK, 0.5, 298.0, 1e5);

    final mcCabeThiele =
        core.McCabeThieleMethod(mixture, 0.9, 0.1, 0.5, 1.0, 3.0);

    simulation.liquidLK = liquidLK;
    simulation.liquidHK = liquidHK;
    simulation.mixture = mixture;
    simulation.mcCabeThiele = mcCabeThiele;

    return simulation;
  }

  IconData get getFabIcon {
    if (canCreateSimulation()) {
      return Icons.build;
    } else {
      return Icons.not_interested;
    }
  }
}

class MixtureInput {
  String liquidLK;
  String liquidHK;

  final List<String> _liquidOptions = ["Benzene", "Toluene"];

  // Create the dropDown for the possibles fluids
  List<DropdownMenuItem<dynamic>> liquidInputDropDownItems() {
    return _liquidOptions.map((String liquidName) {
      return DropdownMenuItem(
        value: liquidName,
        child: Text(
          liquidName,
        ),
      );
    }).toList();
  }

  bool validateInput() {
    if (liquidLK == null || liquidHK == null) return false;
    if (liquidLK.isNotEmpty && liquidHK.isNotEmpty) {
      if (liquidHK == liquidLK) return false;
      return true;
    } else {
      return false;
    }
  }

  @override
  String toString() {
    return "Liquid LK = $liquidHK \n" + "Liquid HK = $liquidHK \n";
  }
}

class SimulationCreator {
  McCabeThieleSimulation createSimulation(MixtureInput input) {
    final McCabeThieleSimulation simulation = McCabeThieleSimulation();

    final liquidLK = core.Liquid(
        material: core.Inicializer.liquidMaterial(input.liquidLK),
        temperature: 298.0);
    final liquidHK = core.Liquid(
        material: core.Inicializer.liquidMaterial(input.liquidHK),
        temperature: 298.0);
    final mixture = core.BinaryMixture(liquidLK, liquidHK, 0.5, 298.0, 1e5);

    final mcCabeThiele =
        core.McCabeThieleMethod(mixture, 0.9, 0.1, 0.5, 1.0, 3.0);

    simulation.liquidLK = liquidLK;
    simulation.liquidHK = liquidHK;
    simulation.mixture = mixture;
    simulation.mcCabeThiele = mcCabeThiele;

    return simulation;
  }
}
