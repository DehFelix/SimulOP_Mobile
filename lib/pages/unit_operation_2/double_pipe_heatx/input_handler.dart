import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:simulop_v1/core/core.dart' as core;

class InputModel extends Model {
  final _outerInput = OuterInput();
  final _innerInput = InnerInput();
  final _heatXInput = HeatXInput();
  SimulationCreator _simulation;

  OuterInput get outerInput => _outerInput;
  InnerInput get innerInput => _innerInput;
  HeatXInput get heatInput => _heatXInput;

  InputModel() {
    _simulation = SimulationCreator(_outerInput, _innerInput, _heatXInput);
  }

  static InputModel of(BuildContext context) =>
      ScopedModel.of<InputModel>(context);

  void setDefaultInputs() {
    // Outer:
    _outerInput.liquid = "Water";

    // Inner:

    // HeatX:

    notifyListeners();
  }

  void setOuterLiquidName(String name) {
    _outerInput.isOil = (name == "Oil (°API)") ? true : false;
    _outerInput.liquid = name;
    notifyListeners();
  }

  void setOuterLiquidAPI(String api) {
    _outerInput.apiDegree = api;
    notifyListeners();
  }

  void setOuterTempIN(String t) {
    _outerInput.tempIN = t;
    notifyListeners();
  }

  void setOuterTempExit(String t) {
    _outerInput.tempExit = t;
    notifyListeners();
  }

  void setInnerLiquidName(String name) {
    _innerInput.isOil = (name == "Oil (°API)") ? true : false;
    _innerInput.liquid = name;
    notifyListeners();
  }

  void setInnerLiquidAPI(String api) {
    _innerInput.apiDegree = api;
    notifyListeners();
  }

  void setInnerTempIN(String t) {
    _innerInput.tempIN = t;
    notifyListeners();
  }

  void setInnerTempExit(String t) {
    _innerInput.tempExit = t;
    notifyListeners();
  }

  void setHeatOuterDiametre(String d) {
    _heatXInput.outerDiametre = d;
    notifyListeners();
  }

  void setHeatInnerDiametre(String d) {
    _heatXInput.innerDiametre = d;
    notifyListeners();
  }

  void setThickness(String t) {
    _heatXInput.thickness = t;
    notifyListeners();
  }

  void setHeatHotFlow(String f) {
    _heatXInput.hotFlow = f;
    notifyListeners();
  }

  void setHeatTubeMaterial(String m) {
    _heatXInput.tubeMaterial = m;
    notifyListeners();
  }

  void setHeatFoolingFactor(String f) {
    _heatXInput.foolingFactor = f;
    notifyListeners();
  }

  IconData getFabIcon() {
    return (_simulation.validateInpus() ? Icons.build : Icons.not_interested);
  }

  void dispose() {}
}

class OuterInput {
  String liquid;
  bool isOil = false;
  String apiDegree;
  String tempIN;
  String tempExit;

  final List<String> _fluidsOptions = [
    "Water",
    "Benzene",
    "Toluene",
    "Oil (°API)"
  ];

  // Create the dropDown for the possibles fluids
  List<DropdownMenuItem<dynamic>> fluidInputDropDownItems() {
    return _fluidsOptions.map((String fluidName) {
      return DropdownMenuItem(
        value: fluidName,
        child: Text(
          fluidName,
        ),
      );
    }).toList();
  }

  /// Input validator for the temparature
  String temperatureValidator(String value) {
    if (value.isEmpty) return null;

    double min = 10.0;
    double max = 90.0;
    double _number;

    _number = double.tryParse(value) ?? null;

    if (_number == null) return "Not a number.";

    if (_number < min || _number > max) {
      return "$min <= Temperature <= $max °C";
    } else
      return null;
  }

  String apiValidator(String value) {
    if (value.isEmpty) return null;

    double min = 10.0;
    double max = 90.0;
    double _number;

    _number = double.tryParse(value) ?? null;

    if (_number == null) return "Not a number.";

    if (_number < min || _number > max) {
      return "$min <= °API <= $max °C";
    } else
      return null;
  }

  bool validInput() {
    return true;
  }
}

class InnerInput {
  String liquid;
  bool isOil;
  String apiDegree;
  String tempIN;
  String tempExit;

  final List<String> _fluidsOptions = [
    "Water",
    "Benzene",
    "Toluene",
    "Oil (°API)"
  ];

  // Create the dropDown for the possibles fluids
  List<DropdownMenuItem<dynamic>> fluidInputDropDownItems() {
    return _fluidsOptions.map((String fluidName) {
      return DropdownMenuItem(
        value: fluidName,
        child: Text(
          fluidName,
        ),
      );
    }).toList();
  }

  /// Input validator for the temparature
  String temperatureValidator(String value) {
    if (value.isEmpty) return null;

    double min = 10.0;
    double max = 90.0;
    double _number;

    _number = double.tryParse(value) ?? null;

    if (_number == null) return "Not a number.";

    if (_number < min || _number > max) {
      return "$min <= Temperature <= $max °C";
    } else
      return null;
  }

  String apiValidator(String value) {
    if (value.isEmpty) return null;

    double min = 10.0;
    double max = 90.0;
    double _number;

    _number = double.tryParse(value) ?? null;

    if (_number == null) return "Not a number.";

    if (_number < min || _number > max) {
      return "$min <= °API <= $max";
    } else
      return null;
  }

  bool validInput() {
    return true;
  }
}

class HeatXInput {
  String outerDiametre;
  String innerDiametre;
  String thickness;
  String hotFlow;
  String tubeMaterial;
  String foolingFactor;

  final List<String> _materialOptions = ["Steel", "Copper"];

  // Create the dropDown for the possibles materials
  List<DropdownMenuItem<dynamic>> tubeMaterialDropDownItems() {
    return _materialOptions.map((String fluidName) {
      return DropdownMenuItem(
        value: fluidName,
        child: Text(
          fluidName,
        ),
      );
    }).toList();
  }

  String diametreValidator(String value) {
    if (value.isEmpty) return null;

    double min = 2.0;
    double max = 20.0;
    double _number;

    _number = double.tryParse(value) ?? null;

    if (_number == null) return "Not a number.";

    if (_number < min || _number > max) {
      return "$min <= Diametre <= $max cm";
    } else
      return null;
  }

  String thicknessValidator(String value) {
    if (value.isEmpty) return null;

    double min = 2.0;
    double max = 20.0;
    double _number;

    _number = double.tryParse(value) ?? null;

    if (_number == null) return "Not a number.";

    if (_number < min || _number > max) {
      return "$min <= Diametre <= $max cm";
    } else
      return null;
  }

  String hotFlowValidator(String value) {
    if (value.isEmpty) return null;

    double min = 2.0;
    double max = 20.0;
    double _number;

    _number = double.tryParse(value) ?? null;

    if (_number == null) return "Not a number.";

    if (_number < min || _number > max) {
      return "$min <= Diametre <= $max cm";
    } else
      return null;
  }

  String foolingFactorValidator(String value) {
    if (value.isEmpty) return null;

    double min = 2.0;
    double max = 20.0;
    double _number;

    _number = double.tryParse(value) ?? null;

    if (_number == null) return "Not a number.";

    if (_number < min || _number > max) {
      return "$min <= Diametre <= $max cm";
    } else
      return null;
  }

  bool validInput() {
    return true;
  }
}

class SimulationCreator {
  final OuterInput outerInput;
  final InnerInput innerInput;
  final HeatXInput heatXInput;

  SimulationCreator(this.outerInput, this.innerInput, this.heatXInput);

  bool validateInpus() {
    return (outerInput.validInput() &&
        innerInput.validInput() &&
        heatXInput.validInput());
  }
}

class Sumary {}
