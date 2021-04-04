import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:simulop_v1/core/core.dart' as core;
import 'package:simulop_v1/pages/helper_classes/options_input_helper.dart';
import 'package:simulop_v1/bloc/absorptionColumnBloc.dart';

import 'package:simulop_v1/pages/unit_operation_3/absorption_column/setupColumn.dart';

final variables = AbsorptionVariables();

class AbsorptionColumnInputData extends Model {
  final MixtureInput input;
  final ColumnInput columnInput;

  AbsorptionColumnInputData({this.input, this.columnInput});

  static AbsorptionColumnInputData of(BuildContext context) =>
      ScopedModel.of<AbsorptionColumnInputData>(context);

  void setLiquidName(LiquidHelper liquid) {
    columnInput.liquid = liquid;
    notifyListeners();
  }

  void setGasName(GasesHelper gas) {
    columnInput.gas = gas;
    notifyListeners();
  }

  void setContaminantName(ContaminantsHelper contaminant) {
    columnInput.contaminant = contaminant;
    notifyListeners();
  }

  void setColumnType(String type, BuildContext context) {
    columnInput.columnType = type;
    columnInput.contaminant = null;
    switch (type) {
      case 'absorption':
        columnInput.contaminantsList =
            ContaminantsHelper.contaminantsAbsorption;
        break;
      case 'stripping':
        columnInput.contaminantsList = ContaminantsHelper.contaminantsStripping;
        break;
    }

    variables.setInValues(15.0);

    contaminantsInputDropDownItems(context);

    notifyListeners();
  }

  void contaminantsInputDropDownItems(context) {
    List<DropdownMenuItem<ContaminantsHelper>> teste =
        columnInput.contaminantsList.map((ContaminantsOptions contaminantName) {
      var contaminant =
          ContaminantsHelper(contaminant: contaminantName, context: context);
      return DropdownMenuItem<ContaminantsHelper>(
          value: contaminant,
          child: Text(
            contaminant.name,
          ));
    }).toList();
    columnInput.dropdownList = teste;
    notifyListeners();
  }

  void setPurity(String prt) {
    if (prt != null) {
      columnInput.purity = prt;
      variables.setOutValues(double.parse(prt));
      variables.setFixedPoint();
    }

    notifyListeners();
  }

  void setContaminantOut(String cont) {
    if (cont != null) {
      columnInput.contaminantOut = cont;
      variables.setOutValues(double.parse(cont));
      variables.setFixedPoint();
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
    return true;
    // if (input.validateInput() && getAlpha > 1.0) {
    //   return true;
    // } else {
    //   return false;
    // }
  }

  // McCabeThieleSimulation createSimulation() {
  //   final liquidLK = core.Liquid(
  //       material: core.Inicializer.liquidMaterial(input.liquidLK),
  //       temperature: 298.0);
  //   final liquidHK = core.Liquid(
  //       material: core.Inicializer.liquidMaterial(input.liquidHK),
  //       temperature: 298.0);
  //   final mixture = core.BinaryMixture(liquidLK, liquidHK, 0.5, 298.0, 1e5);

  //   final mcCabeThiele =
  //       core.McCabeThieleMethod(mixture, 0.9, 0.1, 0.5, 1.0, 3.0);

  //   final McCabeThieleSimulation simulation = McCabeThieleSimulation(
  //     liquidLK: liquidLK,
  //     liquidHK: liquidHK,
  //     mixture: mixture,
  //     mcCabeThiele: mcCabeThiele,
  //   );

  //   return simulation;
  // }

  AbsorptionColumnSimulation createSimulation() {
    final absorptionColumn = core.AbsorptionColumnMethod(variables);
    final AbsorptionColumnSimulation simulation = AbsorptionColumnSimulation(
        columnType: columnInput.columnType,
        liquid: columnInput.liquid,
        gas: columnInput.gas,
        contaminant: columnInput.contaminant,
        absorptionColumn: absorptionColumn);

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
  String columnType = 'absorption';
  LiquidHelper liquid;
  GasesHelper gas;
  ContaminantsHelper contaminant;
  String contaminantOut;
  List<ContaminantsOptions> contaminantsList =
      ContaminantsHelper.contaminantsAbsorption;
  List<DropdownMenuItem<ContaminantsHelper>> contaminantOptions;
  List<DropdownMenuItem<ContaminantsHelper>> dropdownList = [
    DropdownMenuItem<ContaminantsHelper>(
        value: ContaminantsHelper(contaminant: ContaminantsOptions.acetone),
        child: Text(
          'Acetone',
        ))
  ];
  List<DropdownMenuItem<LiquidHelper>> liquidOptions;
  List<DropdownMenuItem<GasesHelper>> gasOptions;

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
    if (purity == null ||
        columnType == null ||
        purity.isEmpty ||
        columnType.isEmpty) return false;
    return true;
  }

  // Create the dropDown for the possibles fluids
  List<DropdownMenuItem<LiquidHelper>> fluidInputDropDownItems(
      BuildContext context) {
    if (liquidOptions == null) {
      liquidOptions =
          LiquidHelper.liquidsAbsorptionColumn.map((LiquidOptions liquidName) {
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

  // Create the dropDown for the possibles fluids
  List<DropdownMenuItem<GasesHelper>> gasInputDropDownItems(
      BuildContext context) {
    if (gasOptions == null) {
      gasOptions =
          GasesHelper.gasesAbsorptionColumn.map((GasesOptions gasName) {
        var gas = GasesHelper(gas: gasName, context: context);
        return DropdownMenuItem<GasesHelper>(
          value: gas,
          child: Text(
            gas.name,
          ),
        );
      }).toList();
    }
    return gasOptions;
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

// class SimulationCreator {
//   AbsorptionColumnSimulation createSimulation(
//       ColumnInput purity, ColumnInput columnType) {
//     final liquidLK = core.Liquid(
//         material: core.Inicializer.liquidMaterial(input.liquidLK),
//         temperature: 298.0);
//     final liquidHK = core.Liquid(
//         material: core.Inicializer.liquidMaterial(input.liquidHK),
//         temperature: 298.0);
//     final mixture = core.BinaryMixture(liquidLK, liquidHK, 0.5, 298.0, 1e5);

//     final mcCabeThiele =
//         core.McCabeThieleMethod(mixture, 0.9, 0.1, 0.5, 1.0, 3.0);

//     final McCabeThieleSimulation simulation = McCabeThieleSimulation(
//       liquidLK: liquidLK,
//       liquidHK: liquidHK,
//       mixture: mixture,
//       mcCabeThiele: mcCabeThiele,
//     );

//     return simulation;
//   }
// }
