import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:simulop_v1/locale/locales.dart';

enum LiquidOptions {
  water,
  benzene,
  toluene,
  oil,
}

enum GasesOptions {
  air,
}

enum MaterialOptions {
  steel,
  copper,
  concrete,
  pvc,
}

enum ContaminantsOptions {
  benzene,
  ethylAlcohol
}

class LiquidHelper {
  static final List<LiquidOptions> liquidsPumpingOfLiquids = [
    LiquidOptions.water,
    LiquidOptions.benzene,
    LiquidOptions.toluene
  ];

  static final List<LiquidOptions> liquidsDoublePipeHeatX = [
    LiquidOptions.water,
    LiquidOptions.benzene,
    LiquidOptions.toluene,
    LiquidOptions.oil,
  ];

  static final List<LiquidOptions> liquidsMcCabeThiele = [
    LiquidOptions.benzene,
    LiquidOptions.toluene
  ];

  static final List<LiquidOptions> liquidsAbsorptionColumn = [
    LiquidOptions.water
  ];

  final LiquidOptions liquid;
  String name;

  LiquidHelper({@required this.liquid, BuildContext context}) {
    if (context != null) {
      switch (liquid) {
        case LiquidOptions.water:
          name = AppLocalizations.of(context).water;
          break;
        case LiquidOptions.benzene:
          name = AppLocalizations.of(context).benzene;
          break;
        case LiquidOptions.toluene:
          name = AppLocalizations.of(context).toluene;
          break;
        case LiquidOptions.oil:
          name = AppLocalizations.of(context).oil;
          break;
      }
    } else {
      name = "";
    }
  }

  static String getLocalizedName(LiquidOptions liquid, BuildContext context) {
    switch (liquid) {
      case LiquidOptions.water:
        return AppLocalizations.of(context).water;
      case LiquidOptions.benzene:
        return AppLocalizations.of(context).benzene;
      case LiquidOptions.toluene:
        return AppLocalizations.of(context).toluene;
      case LiquidOptions.oil:
        return AppLocalizations.of(context).oil;
    }
    return "";
  }
}

class GasesHelper {
  static final List<GasesOptions> gasesAbsorptionColumn = [
    GasesOptions.air,
  ];

  final GasesOptions gas;
  String name;

  GasesHelper({@required this.gas, BuildContext context}) {
    if (context != null) {
      switch (gas) {
        case GasesOptions.air:
          name = AppLocalizations.of(context).air;
          break;
      }
    } else {
      name = "";
    }
  }
}

class ContaminantsHelper {
  static final List<ContaminantsOptions> contaminantsAbsorption = [
    ContaminantsOptions.ethylAlcohol,
  ];

  static final List<ContaminantsOptions> contaminantsStripping = [
    ContaminantsOptions.benzene,
  ];

  final ContaminantsOptions contaminant;
  String name;

  ContaminantsHelper({@required this.contaminant, BuildContext context}) {
    if (context != null) {
      switch (contaminant) {
        case ContaminantsOptions.ethylAlcohol:
          name = AppLocalizations.of(context).ethylAlcohol;
          break;
        case ContaminantsOptions.benzene:
          name = AppLocalizations.of(context).benzene;
          break;
      }
    } else {
      name = 'Ethyl Alcohol';
    }
  }
}

class MaterialHelper {
  static final List<MaterialOptions> materialPumpingOfLiquids = [
    MaterialOptions.steel,
    MaterialOptions.copper,
    MaterialOptions.concrete,
    MaterialOptions.pvc,
  ];

  static final List<MaterialOptions> materialDoublePipeHeatX = [
    MaterialOptions.steel,
    MaterialOptions.copper,
  ];

  final MaterialOptions material;
  String name;

  MaterialHelper({@required this.material, BuildContext context}) {
    if (context != null) {
      switch (material) {
        case MaterialOptions.steel:
          name = AppLocalizations.of(context).steel;
          break;
        case MaterialOptions.copper:
          name = AppLocalizations.of(context).copper;
          break;
        case MaterialOptions.concrete:
          name = AppLocalizations.of(context).concrete;
          break;
        case MaterialOptions.pvc:
          name = AppLocalizations.of(context).pvc;
          break;
      }
    } else {
      name = "";
    }
  }

  static String getLocalizedName(
      MaterialOptions material, BuildContext context) {
    switch (material) {
      case MaterialOptions.steel:
        return AppLocalizations.of(context).steel;
      case MaterialOptions.copper:
        return AppLocalizations.of(context).copper;
      case MaterialOptions.concrete:
        return AppLocalizations.of(context).concrete;
      case MaterialOptions.pvc:
        return AppLocalizations.of(context).pvc;
      default:
        return "";
    }
  }
}
