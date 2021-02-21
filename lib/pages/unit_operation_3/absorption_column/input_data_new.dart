import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:simulop_v1/core/core.dart' as core;
import 'package:simulop_v1/pages/helper_classes/options_input_helper.dart';
//import 'package:simulop_v1/pages/unit_operation_3/mccabe_thiele_method/simulation_data.dart';
import 'package:simulop_v1/bloc/mcCabeResultsBloc.dart';

class McCabeThieleInputData extends Model {
  final MixtureInput input;
  final ColumnInput columnInput;

  McCabeThieleInputData({
    this.input,
    this.columnInput
  });

  static McCabeThieleInputData of(BuildContext context) =>
      ScopedModel.of<McCabeThieleInputData>(context);

  void setLiquidLKName(LiquidHelper liquid) {
    input.liquidLK = liquid;
    notifyListeners();
  }

  void setLiquidHKName(LiquidHelper liquid) {
    input.liquidHK = liquid;
    notifyListeners();
  }

  void setColumnType(String type) {
    columnInput.columnType = type;
    notifyListeners();
  }

  void setPurity(String prt) {
    if (prt != null) {
      columnInput.purity = prt;
    }
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
    final liquidLK = core.Liquid(
        material: core.Inicializer.liquidMaterial(input.liquidLK),
        temperature: 298.0);
    final liquidHK = core.Liquid(
        material: core.Inicializer.liquidMaterial(input.liquidHK),
        temperature: 298.0);
    final mixture = core.BinaryMixture(liquidLK, liquidHK, 0.5, 298.0, 1e5);

    final mcCabeThiele =
        core.McCabeThieleMethod(mixture, 0.9, 0.1, 0.5, 1.0, 3.0);

    final McCabeThieleSimulation simulation = McCabeThieleSimulation(
      liquidLK: liquidLK,
      liquidHK: liquidHK,
      mixture: mixture,
      mcCabeThiele: mcCabeThiele,
    );

    return simulation;
  }

  IconData get getFabIcon {
    if (canCreateSimulation()) {
      return Icons.send;
    } else {
      return Icons.not_interested;
    }
  }
}

class ColumnInput {
  String purity;
  String columnType;

  String purityValidator(String value) {
    if (value.isEmpty) return null;

    double min = 60.0;
    double max = 99.99;
    double _number;

    _number = double.tryParse(value) ?? null;

    if (_number == null) return "Not a number.";

    if (_number < min || _number > max) {
      return "$min <= Purity <= $max %";
    }

    return null;
  }

  bool validateInput() {
    if (purity == null || columnType == null || purity.isEmpty || columnType.isEmpty) return false;
    return true;
  }

}

class MixtureInput {
  LiquidHelper liquidLK;
  LiquidHelper liquidHK;

  List<DropdownMenuItem<LiquidHelper>> liquidOptions;

  
  // Create the dropDown for the possibles fluids
  List<DropdownMenuItem<LiquidHelper>> fluidInputDropDownItems(
      BuildContext context) {
    if (liquidOptions == null) {
      liquidOptions =
          LiquidHelper.liquidsMcCabeThiele.map((LiquidOptions liquidName) {
        var liquid = LiquidHelper(liquid: liquidName, context: context);
        return DropdownMenuItem<LiquidHelper>(
          value: liquid,
          child: Text(
            liquid.name,
          ),
        );
      }).toList();
    }
    return liquidOptions;
  }

  bool validateInput() {
    if (liquidLK == null || liquidHK == null) return false;
    if (liquidHK == liquidLK) return false;
    return true;
  }

  @override
  String toString() {
    return "Liquid LK = $liquidHK \n" + "Liquid HK = $liquidHK \n";
  }
}

class SimulationCreator {
  McCabeThieleSimulation createSimulation(MixtureInput input, ColumnInput columnInput) {

    final liquidLK = core.Liquid(
        material: core.Inicializer.liquidMaterial(input.liquidLK),
        temperature: 298.0);
    final liquidHK = core.Liquid(
        material: core.Inicializer.liquidMaterial(input.liquidHK),
        temperature: 298.0);
    final mixture = core.BinaryMixture(liquidLK, liquidHK, 0.5, 298.0, 1e5);

    final mcCabeThiele =
        core.McCabeThieleMethod(mixture, 0.9, 0.1, 0.5, 1.0, 3.0);

    final McCabeThieleSimulation simulation = McCabeThieleSimulation(
      liquidLK: liquidLK,
      liquidHK: liquidHK,
      mixture: mixture,
      mcCabeThiele: mcCabeThiele,
    );

    return simulation;
  }
}
