import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:simulop_v1/core/core.dart' as core;
import 'package:simulop_v1/pages/helper_classes/options_input_helper.dart';
import 'package:simulop_v1/bloc/absorptionColumnBloc.dart';

import 'package:simulop_v1/pages/unit_operation_3/absorption_column/setupColumn.dart';

final variables = AbsorptionVariables();

class AbsorptionColumnInputData extends Model {
  final ColumnInput columnInput;

  AbsorptionColumnInputData({this.columnInput});

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
      case 'Absorption':
        columnInput.contaminantsList =
            ContaminantsHelper.contaminantsAbsorption;
        break;
      case 'Stripping':
        columnInput.contaminantsList = ContaminantsHelper.contaminantsStripping;
        break;
    }

    variables.setColumn(type);
    contaminantsInputDropDownItems(context);
    notifyListeners();
  }

  void setContaminantOut(String cont) {
    if (cont != null) {
      columnInput.contaminantOut = cont;
      variables.setInValues();
      variables.setOutValues(double.parse(cont));
      variables.setFixedPoint();
    }

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

  bool canCreateSimulation(context) {
    if (columnInput.validateInput(context)) return true;
    return false;
  }

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

  IconData getFabIcon(context) {
    if (canCreateSimulation(context)) {
      return Icons.send;
    } else {
      return Icons.not_interested;
    }
  }
}

class ColumnInput {
  String missingInputMessage;
  String purity;
  String columnType = 'Absorption';
  LiquidHelper liquid;
  GasesHelper gas;
  ContaminantsHelper contaminant;
  String contaminantOut;
  List<ContaminantsOptions> contaminantsList =
      ContaminantsHelper.contaminantsAbsorption;
  List<DropdownMenuItem<ContaminantsHelper>> contaminantOptions;
  List<DropdownMenuItem<ContaminantsHelper>> dropdownList = [
    DropdownMenuItem<ContaminantsHelper>(
        value: ContaminantsHelper(contaminant: ContaminantsOptions.ethylAlcohol),
        child: Text(
          'Ethyl Alcohol',
        ))
  ];
  List<DropdownMenuItem<LiquidHelper>> liquidOptions;
  List<DropdownMenuItem<GasesHelper>> gasOptions;

  String purityValidator(String value) {
    if (value.isEmpty) return null;

    double min = 0.05;
    double max = 1.0;
    double _number;

    _number = double.tryParse(value) ?? null;

    if (_number == null) return "Not a number.";

    if (_number < min || _number > max) {
      return "$min <= C <= $max %";
    }

    return null;
  }

  bool validateInput(context) {
    if (contaminantOut == null || contaminantOut.isEmpty) {
      missingInputMessage = 'Concentração Máxima de Contaminante na Saída';
      return false;
    }

    if (gas == null) {
      missingInputMessage = 'Gás';
      return false;
    }

    if (liquid == null) {
      missingInputMessage = 'Líquido';
      return false;
    }

    if (contaminant == null) {
      missingInputMessage = 'Contaminante';
      return false;
    }

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
