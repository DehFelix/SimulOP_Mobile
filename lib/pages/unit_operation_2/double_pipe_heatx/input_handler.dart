import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:simulop_v1/core/core.dart' as core;
import 'package:simulop_v1/locale/locales.dart';
import 'package:simulop_v1/pages/helper_classes/options_input_helper.dart';
import 'package:simulop_v1/pages/unit_operation_2/double_pipe_heatx/simulation_data.dart';

class InputModel extends Model {
  final _outerInput = OuterInput();
  final _innerInput = InnerInput();
  final _heatXInput = HeatXInput();
  SimulationCreator _simulation;

  OuterInput get outerInput => _outerInput;
  InnerInput get innerInput => _innerInput;
  HeatXInput get heatInput => _heatXInput;
  SimulationCreator get simulation => _simulation;

  InputModel() {
    _simulation = SimulationCreator(_outerInput, _innerInput, _heatXInput);
  }

  static InputModel of(BuildContext context) =>
      ScopedModel.of<InputModel>(context);

  void setDefaultInputs(BuildContext context) {
    // Outer:
    _outerInput.liquid = _outerInput.liquidOptions[0].value;
    _outerInput.tempIN = "70.0";
    _outerInput.tempExit = "37.0";
    // Inner:
    _innerInput.liquid = _innerInput.liquidOptions[0].value;
    _innerInput.tempIN = "26.0";
    _innerInput.tempExit = "48.0";
    // HeatX:
    _heatXInput.hotFlow = "3.0";
    _heatXInput.tubeMaterial = _heatXInput.materialOptions[1].value;
    _heatXInput.foolingFactor = "0.0";
    _heatXInput.thickness = "0.0";

    _heatXInput.innerDiametre = "3.0";
    _heatXInput.outerDiametre = "7.0";

    notifyListeners();
  }

  void setOuterLiquidName(LiquidHelper liquid) {
    _outerInput.isOil = (liquid.liquid == LiquidOptions.oil) ? true : false;
    _outerInput.liquid = liquid;
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

  void setInnerLiquidName(LiquidHelper liquid) {
    _innerInput.isOil = (liquid.liquid == LiquidOptions.oil) ? true : false;
    _innerInput.liquid = liquid;
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

  void setHeatTubeMaterial(MaterialHelper material) {
    _heatXInput.tubeMaterial = material;
    notifyListeners();
  }

  void setHeatFoolingFactor(String f) {
    _heatXInput.foolingFactor = f;
    notifyListeners();
  }

  IconData getFabIcon() {
    return (_simulation.validateInpus() ? Icons.send : Icons.not_interested);
  }

  bool canCreateSimulation() {
    return _simulation.validateInpus();
  }

  String getErroMessage() {
    return (_simulation.numbersErro)
        ? _simulation.erroMessage
        : "Inclonplete Inputs";
  }

  DoublePipeHeatXSimulation createSimulation() {
    return _simulation.createSimulation();
  }
}

class OuterInput {
  LiquidHelper liquid;
  bool isOil = false;
  String apiDegree;
  String tempIN;
  String tempExit;

  List<DropdownMenuItem<LiquidHelper>> liquidOptions;

  // Create the dropDown for the possibles fluids
  List<DropdownMenuItem<LiquidHelper>> fluidInputDropDownItems(
      BuildContext context) {
    if (liquidOptions == null) {
      liquidOptions =
          LiquidHelper.liquidsDoublePipeHeatX.map((LiquidOptions liquidName) {
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

  /// Input validator for the temparature
  String temperatureValidator(String value) {
    if (value.isEmpty) return null;

    double min = 10.0;
    double max = 200.0;
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
    double max = 50.0;
    double _number;

    _number = double.tryParse(value) ?? null;

    if (_number == null) return "Not a number.";

    if (_number < min || _number > max) {
      return "$min <= °API <= $max °C";
    } else
      return null;
  }

  String diametreValidator(String value) {
    if (value.isEmpty) return null;

    double min = 5.0;
    double max = 30.0;
    double _number;

    _number = double.tryParse(value) ?? null;

    if (_number == null) return "Not a number.";

    if (_number < min || _number > max) {
      return "$min <= Diametre <= $max cm";
    } else
      return null;
  }

  bool validInput() {
    if (liquid == null || tempIN == null || tempExit == null) return false;
    if (tempIN.isNotEmpty && tempExit.isNotEmpty) {
      if (isOil && apiDegree != null && apiDegree.isNotEmpty) {
        return true;
      } else
        return (isOil) ? false : true;
    } else {
      return false;
    }
  }
}

class InnerInput {
  LiquidHelper liquid;
  bool isOil = false;
  String apiDegree;
  String tempIN;
  String tempExit;

  List<DropdownMenuItem<LiquidHelper>> liquidOptions;

  // Create the dropDown for the possibles fluids
  List<DropdownMenuItem<LiquidHelper>> fluidInputDropDownItems(
      BuildContext context) {
    if (liquidOptions == null) {
      liquidOptions =
          LiquidHelper.liquidsDoublePipeHeatX.map((LiquidOptions liquidName) {
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

  /// Input validator for the temparature
  String temperatureValidator(String value) {
    if (value.isEmpty) return null;

    double min = 10.0;
    double max = 200.0;
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
    double max = 50.0;
    double _number;

    _number = double.tryParse(value) ?? null;

    if (_number == null) return "Not a number.";

    if (_number < min || _number > max) {
      return "$min <= °API <= $max";
    } else
      return null;
  }

  String diametreValidator(String value) {
    if (value.isEmpty) return null;

    double min = 2.0;
    double max = 10.0;
    double _number;

    _number = double.tryParse(value) ?? null;

    if (_number == null) return "Not a number.";

    if (_number < min || _number > max) {
      return "$min <= Diametre <= $max cm";
    } else
      return null;
  }

  bool validInput() {
    if (liquid == null || tempIN == null || tempExit == null) return false;
    if (tempIN.isNotEmpty && tempExit.isNotEmpty) {
      if (isOil && apiDegree != null && apiDegree.isNotEmpty) {
        return true;
      } else
        return (isOil) ? false : true;
    } else {
      return false;
    }
  }
}

class HeatXInput {
  String outerDiametre;
  String innerDiametre;
  String thickness;
  String hotFlow;
  MaterialHelper tubeMaterial;
  String foolingFactor;

  List<DropdownMenuItem<MaterialHelper>> materialOptions;

  // Create the dropDown for the possibles materials
  List<DropdownMenuItem<dynamic>> tubeMaterialDropDownItems(
      BuildContext context) {
    if (materialOptions == null) {
      materialOptions = MaterialHelper.materialDoublePipeHeatX
          .map((MaterialOptions materialName) {
        var material = MaterialHelper(material: materialName, context: context);
        return DropdownMenuItem(
          value: material,
          child: Text(
            material.name,
          ),
        );
      }).toList();
    }
    return materialOptions;
  }

  String thicknessValidator(String value) {
    if (value.isEmpty) return null;

    double min = 0.0;
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

    double min = 0.0;
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
    if (outerDiametre == null ||
        innerDiametre == null ||
        thickness == null ||
        hotFlow == null ||
        tubeMaterial == null ||
        foolingFactor == null) return false;
    if (outerDiametre.isNotEmpty &&
        innerDiametre.isNotEmpty &&
        thickness.isNotEmpty &&
        hotFlow.isNotEmpty &&
        foolingFactor.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}

class SimulationCreator {
  final OuterInput outerInput;
  final InnerInput innerInput;
  final HeatXInput heatXInput;

  bool numbersErro = true;
  String erroMessage;

  SimulationCreator(this.outerInput, this.innerInput, this.heatXInput);

  bool validateInpus() {
    if (outerInput.validInput() &&
        innerInput.validInput() &&
        heatXInput.validInput()) {
      erroMessage = "";
      numbersErro = false;

      // Checking diametres
      double outerDiam = double.parse(heatXInput.outerDiametre);
      double innerDiam = double.parse(heatXInput.innerDiametre);

      if (outerDiam - innerDiam < 3.0) {
        erroMessage = "Outer Diametre too small";
        numbersErro = true;
      }

      // Checking temperature diference

      double outerTempIn = double.parse(outerInput.tempIN);
      double innerTempIn = double.parse(innerInput.tempIN);

      if ((outerTempIn - innerTempIn).abs() < 2.0) {
        erroMessage = "Check temperatures";
        numbersErro = true;
      }

      core.PipeType hotTube = (outerTempIn > innerTempIn)
          ? core.PipeType.outer
          : core.PipeType.inner;

      if (hotTube == core.PipeType.outer) {
        if (outerTempIn < 40.0 || innerTempIn > 40.0) {
          erroMessage = "Hot/Cold liquid not hot/cold enough";
          numbersErro = true;
        }
      } else if (outerTempIn > 40.0 || innerTempIn < 40.0) {
        erroMessage = "Hot/Cold liquid not hot/cold enough";
        numbersErro = true;
      }

      return (!numbersErro);
    } else {
      return false;
    }
  }

  Sumary getSumary(BuildContext context) {
    final sumary = Sumary();

    if (outerInput.validInput()) {
      final bulckTemp = 273.15 +
          (double.parse(outerInput.tempIN) +
                  double.parse(outerInput.tempExit)) /
              2.0;
      final api = (outerInput.isOil) ? double.parse(outerInput.apiDegree) : 0.0;
      final core.ILiquidMaterial outerMaterial = (outerInput.isOil)
          ? core.ApiOilMaterial(apiDegree: api, temperature: bulckTemp)
          : core.Inicializer.liquidMaterial(outerInput.liquid, temp: bulckTemp);

      sumary.outerLiquidName =
          "${AppLocalizations.of(context).summaryOuterLiquid} - ${(outerInput.isOil) ? "Oil ($api °API)" : outerInput.liquid.name} \n";
      sumary.outerBulkTemp =
          "${AppLocalizations.of(context).summaryBulckTemp} ${(bulckTemp - 273.15).toStringAsFixed(1)} °C \n";
      sumary.outerLiquidDensity =
          "${AppLocalizations.of(context).summaryDensity} ${outerMaterial.density.toStringAsFixed(1)} Kg/m^3 \n";
      sumary.outerLiquidViscosity =
          "${AppLocalizations.of(context).summaryViscosity} ${(outerMaterial.viscosity * 1000.0).toStringAsFixed(2)} cP \n";
      sumary.outerLiquidSpecificHeat =
          "${AppLocalizations.of(context).summarySpecificHeat} ${(outerMaterial.specificHeat / 1000.0).toStringAsFixed(2)} KJ/mol K \n";
    }

    if (innerInput.validInput()) {
      final bulckTemp = 273.15 +
          (double.parse(innerInput.tempIN) +
                  double.parse(innerInput.tempExit)) /
              2.0;
      final api = (innerInput.isOil) ? double.parse(innerInput.apiDegree) : 0.0;
      final core.ILiquidMaterial innerMaterial = (innerInput.isOil)
          ? core.ApiOilMaterial(apiDegree: api, temperature: bulckTemp)
          : core.Inicializer.liquidMaterial(innerInput.liquid, temp: bulckTemp);

      sumary.innerLiquidName =
          "${AppLocalizations.of(context).summaryInnerLiquid} - ${(innerInput.isOil) ? "Oil ($api °API)" : innerInput.liquid.name} \n";
      sumary.innerBulkTemp =
          "${AppLocalizations.of(context).summaryBulckTemp} ${(bulckTemp - 273.15).toStringAsFixed(1)} °C \n";
      sumary.innerLiquidDensity =
          "${AppLocalizations.of(context).summaryDensity} ${innerMaterial.density.toStringAsFixed(1)} Kg/m^3 \n";
      sumary.innerLiquidViscosity =
          "${AppLocalizations.of(context).summaryViscosity} ${(innerMaterial.viscosity * 1000.0).toStringAsFixed(2)} cP \n";
      sumary.innerLiquidSpecificHeat =
          "${AppLocalizations.of(context).summarySpecificHeat} ${(innerMaterial.specificHeat / 1000.0).toStringAsFixed(2)} KJ/mol K \n";
    }

    return sumary;
  }

  DoublePipeHeatXSimulation createSimulation() {
    
    // Outer Liquid
    final outerTempIn = double.parse(outerInput.tempIN) + 273.15;
    final outerTempExit = double.parse(outerInput.tempExit) + 273.15;

    final core.ILiquidMaterial outerLiquidMaterial = (outerInput.isOil)
        ? core.ApiOilMaterial(
            apiDegree: double.parse(outerInput.apiDegree),
            temperature: outerTempIn)
        : core.Inicializer.liquidMaterial(outerInput.liquid);

    final outerLiquid =
        core.Liquid(material: outerLiquidMaterial, temperature: outerTempIn);

    // Inner Liquid
    final innerTempIn = double.parse(innerInput.tempIN) + 273.15;
    final innerTempExit = double.parse(innerInput.tempExit) + 273.15;

    final core.ILiquidMaterial innerLiquidMaterial = (innerInput.isOil)
        ? core.ApiOilMaterial(
            apiDegree: double.parse(innerInput.apiDegree),
            temperature: innerTempIn)
        : core.Inicializer.liquidMaterial(innerInput.liquid);

    final innerLiquid =
        core.Liquid(material: innerLiquidMaterial, temperature: innerTempIn);

    // Pipes 
    final tubeMaterial = core.Inicializer.tubeMaterial(heatXInput.tubeMaterial);
    final thicness = double.parse(heatXInput.thickness) * 1e-2;

    // Inner Pipe
    final innerDiametre = double.parse(heatXInput.innerDiametre) * 1e-2;
    final innerTube = core.DoublePibeTube(
        material: tubeMaterial,
        externalDiametre: innerDiametre,
        thickness: thicness,
        tubeType: core.PipeType.inner,
        elevationDiference: 0.0,
        length: 1.0);

    // Outer Pipe
    final outerDiametre = double.parse(heatXInput.outerDiametre) * 1e-2;
    final outerTube = core.DoublePibeTube(
        material: tubeMaterial,
        externalDiametre: outerDiametre,
        thickness: thicness,
        tubeType: core.PipeType.outer,
        elevationDiference: 0.0,
        length: 1.0,
        diametreOfInternalTube: innerDiametre);

    // HeatX
    final hotFlow = double.parse(heatXInput.hotFlow) / 3600.0;
    final foolingFactor = double.parse(heatXInput.foolingFactor) * 1e-3;

    final heatX = core.DoublePipeHeatX(
        hotFlow: hotFlow,
        outerLiquidIn: outerLiquid,
        outerExitTemp: outerTempExit,
        outerPipe: outerTube,
        innerLiquidIn: innerLiquid,
        innerExitTemp: innerTempExit,
        innerPipe: innerTube,
        foulingFactor: foolingFactor,
        config: core.HeaterConfig.counterCurrent);

    final simulation = DoublePipeHeatXSimulation(
        heatX: heatX,
        innerLiquid: innerLiquid,
        innerTube: innerTube,
        outerLiquid: outerLiquid,
        outerTube: outerTube);

    return simulation;
  }
}

class Sumary {
  String outerLiquidName;
  String outerBulkTemp;
  String outerLiquidDensity;
  String outerLiquidViscosity;
  String outerLiquidSpecificHeat;

  String innerLiquidName;
  String innerBulkTemp;
  String innerLiquidDensity;
  String innerLiquidViscosity;
  String innerLiquidSpecificHeat;

  Sumary(
      {this.outerLiquidName,
      this.innerLiquidDensity,
      this.innerLiquidName,
      this.innerLiquidSpecificHeat,
      this.innerLiquidViscosity,
      this.outerLiquidDensity,
      this.outerLiquidSpecificHeat,
      this.outerLiquidViscosity,
      this.innerBulkTemp,
      this.outerBulkTemp});
}
