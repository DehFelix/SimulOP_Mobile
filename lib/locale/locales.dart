import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import 'package:simulop_v1/l10n/messages_all.dart';

class AppLocalizations {
  static Future<AppLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode.isEmpty ? locale.languageCode : locale.toString();

    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((bool _) {
      Intl.defaultLocale = localeName;
      return AppLocalizations();
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  // Home Page
  String get title {
    return Intl.message(
      "SimulOP",
      name: "title",
      desc: "The title of the App bar",
    );
  }

  String get moreInfoBtn {
    return Intl.message(
      "More info",
      name: "moreInfoBtn",
    );
  }

  String get lunchAppBtn {
    return Intl.message(
      "Lunch App",
      name: "lunchAppBtn",
    );
  }

  // OU I
  String get ouIName {
    return Intl.message(
      "OU I",
      name: "ouIName",
    );
  }

  String get pumpingOfLiquidsName {
    return Intl.message(
      "Pumping of Liquids",
      name: "pumpingOfLiquidsName",
    );
  }

  String get pumpingOfLiquidsDescription {
    return Intl.message(
      "pumpingOfLiquidsDescription",
      name: "pumpingOfLiquidsDescription",
    );
  }

  String get filterName {
    return Intl.message(
      "Filter",
      name: "filterName",
    );
  }

  String get filterDescription {
    return Intl.message(
      "filterDescription",
      name: "filterDescription",
    );
  }

  String get compressorName {
    return Intl.message(
      "Compressor",
      name: "compressorName",
    );
  }

  String get compressorDescription {
    return Intl.message(
      "compressorDescription",
      name: "compressorDescription",
    );
  }

  // OU II
  String get ouIIName {
    return Intl.message(
      "OU II",
      name: "ouIIName",
    );
  }

  String get doublePipeName {
    return Intl.message(
      "Double Pipe Heat Exchanger",
      name: "doublePipeName",
    );
  }

  String get doublePipeDescription {
    return Intl.message(
      "doublePipeDescription",
      name: "doublePipeDescription",
    );
  }

  String get multiPipeName {
    return Intl.message(
      "Multi Pipe Heat Exchanger",
      name: "multiPipeName",
    );
  }

  String get multiPipeDescription {
    return Intl.message(
      "multiPipeDescription",
      name: "multiPipeDescription",
    );
  }

  String get evaporatorName {
    return Intl.message(
      "Evaporator",
      name: "evaporatorName",
    );
  }

  String get evaporatorDescription {
    return Intl.message(
      "evaporatorDescription",
      name: "evaporatorDescription",
    );
  }

  String get dryerName {
    return Intl.message(
      "Dryer",
      name: "dryerName",
    );
  }

  String get dryerDescription {
    return Intl.message(
      "dryerDescription",
      name: "dryerDescription",
    );
  }

  String get coolingTowerName {
    return Intl.message(
      "Cooling Tower",
      name: "coolingTowerName",
    );
  }

  String get coolingTowerDescription {
    return Intl.message(
      "coolingTowerDescription",
      name: "coolingTowerDescription",
    );
  }

  // OU III
  String get ouIIIName {
    return Intl.message(
      "OU III",
      name: "ouIIIName",
    );
  }

  String get mcCabeThieleName {
    return Intl.message(
      "McCabe-Thiele Method",
      name: "mcCabeThieleName",
    );
  }

  String get mcCabeThieleDescription {
    return Intl.message(
      "mcCabeThieleDescription",
      name: "mcCabeThieleDescription",
    );
  }

  String get absorptionColumnName {
    return Intl.message(
      "Absorption Column",
      name: "absorptionColumnName",
    );
  }

  String get absorptionColumnDescription {
    return Intl.message(
      "absorptionColumnDescription",
      name: "absorptionColumnDescription",
    );
  }

  String get membranesName {
    return Intl.message(
      "Separation Membranes",
      name: "membranesName",
    );
  }

  String get membranesDescription {
    return Intl.message(
      "membranesDescription",
      name: "membranesDescription",
    );
  }

  String get crystalizerName {
    return Intl.message(
      "Crystalizer",
      name: "crystalizerName",
    );
  }

  String get crystalizerDescription {
    return Intl.message(
      "crystalizerDescription",
      name: "crystalizerDescription",
    );
  }

  String get distilationName {
    return Intl.message(
      "Distillation Column",
      name: "distilationName",
    );
  }

  String get distilationDescription {
    return Intl.message(
      "distilationDescription",
      name: "distilationDescription",
    );
  }

  //Pumping of Liquids Input
  String get defaultInputs {
    return Intl.message(
      "Default inputs",
      name: "defaultInputs",
    );
  }

  String get picture {
    return Intl.message(
      "Picture",
      name: "picture",
    );
  }

  String get liquidInput {
    return Intl.message(
      "Liquid Input:",
      name: "liquidInput",
    );
  }

  String get hintTemperature {
    return Intl.message(
      "Temperature (°C)",
      name: "hintTemperature",
    );
  }

  String get inletInput {
    return Intl.message(
      "Inlet Tube Input:",
      name: "inletInput",
    );
  }

  String get hintPressure {
    return Intl.message(
      "Pressure (bar)",
      name: "hintPressure",
    );
  }

  String get hintDiametre {
    return Intl.message(
      "Diametre (cm)",
      name: "hintDiametre",
    );
  }

  String get hintResistancesLenghts {
    return Intl.message(
      "Resistances Lengths (m)",
      name: "hintResistancesLenghts",
    );
  }

  String get outletInput {
    return Intl.message(
      "Outlet Tube Input:",
      name: "outletInput",
    );
  }

  String get distancesInput {
    return Intl.message(
      "Distances Input:",
      name: "distancesInput",
    );
  }

  String get hintDzInlet {
    return Intl.message(
      "Dz Inlet (m)",
      name: "hintDzInlet",
    );
  }

  String get hintLInlet {
    return Intl.message(
      "L Inlet (m)",
      name: "hintLInlet",
    );
  }

  String get hintDzOutlet {
    return Intl.message(
      "Dz Outlet (m)",
      name: "hintDzOutlet",
    );
  }

  String get hintLOutlet {
    return Intl.message(
      "L Outlet (m)",
      name: "hintLOutlet",
    );
  }

  String get summary {
    return Intl.message(
      "Summary",
      name: "summary",
    );
  }

  String get summaryLiquid {
    return Intl.message(
      "Liquid",
      name: "summaryLiquid",
    );
  }

  String get summaryDensity {
    return Intl.message(
      "Density:",
      name: "summaryDensity",
    );
  }

  String get summaryViscosity {
    return Intl.message(
      "Viscosity:",
      name: "summaryViscosity",
    );
  }

  String get summaryVaporPre {
    return Intl.message(
      "Vapor pressure:",
      name: "summaryVaporPre",
    );
  }

  String get summayInletTube {
    return Intl.message(
      "Inlet Tube",
      name: "summayInletTube",
    );
  }

  String get summaryRoughness {
    return Intl.message(
      "Roughness:",
      name: "summaryRoughness",
    );
  }

  String get summaryDiametre {
    return Intl.message(
      "Diametre:",
      name: "summaryDiametre",
    );
  }

  String get summaryLenght {
    return Intl.message(
      "Lenght:",
      name: "summaryLenght",
    );
  }

  String get summaryElevation {
    return Intl.message(
      "Elevation:",
      name: "summaryElevation",
    );
  }

  String get summaryOutletTube {
    return Intl.message(
      "Outlet Tube",
      name: "summaryOutletTube",
    );
  }

  // Pumping of Liquids Results
  String get results {
    return Intl.message(
      "Results",
      name: "rusults",
    );
  }

  String get graph {
    return Intl.message(
      "Graph",
      name: "graph",
    );
  }

  String get chartHeadLeg {
    return Intl.message(
      "Pump Head",
      name: "chartHeadLeg",
    );
  }

  String get chartNPSH {
    return Intl.message(
      "Avaliable NPSH",
      name: "chartNPSH",
    );
  }

  String get resultsFlow {
    return Intl.message(
      "Selecteed Flow:",
      name: "resultsFlow",
    );
  }

  String get resultsHead {
    return Intl.message(
      "Necessary Head:",
      name: "resultsHead",
    );
  }

  String get resultsNPSH {
    return Intl.message(
      "Avaliable NPSH:",
      name: "resultsNPSH",
    );
  }

  String get drawerVariables {
    return Intl.message(
      "Variables:",
      name: "drawerVariables",
    );
  }

  String get drawerLiquid {
    return Intl.message(
      "Liquid:",
      name: "drawerLiquid",
    );
  }

  String get drawerLiquidTemp {
    return Intl.message(
      "Liquid Temperature: (°C)",
      name: "drawerLiquidTemp",
    );
  }

  String get drawerInlet {
    return Intl.message(
      "Inlet:",
      name: "drawerInlet",
    );
  }

  String get drawerInletValve {
    return Intl.message(
      "Inlet Valve Opening:",
      name: "drawerInletValve",
    );
  }

  String get drawerInletPressure {
    return Intl.message(
      "Inlet Tank Pressure: (bar)",
      name: "drawerInletPressure",
    );
  }

  String get drawerOutlet {
    return Intl.message(
      "Outlet:",
      name: "drawerOutlet",
    );
  }

  String get drawerOutletValve {
    return Intl.message(
      "Outlet Valve Opening:",
      name: "drawerOutletValve",
    );
  }

  String get drawerDistances {
    return Intl.message(
      "Distances:",
      name: "drawerDistances",
    );
  }
}

class AppLocalizationDelegade extends LocalizationsDelegate<AppLocalizations> {
  @override
  bool isSupported(Locale locale) {
    return ["en", "pt"].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return AppLocalizations.load(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}
