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

  String get steel {
    return Intl.message(
      "Steel",
      name: "steel",
    );
  }

  String get copper {
    return Intl.message(
      "Copper",
      name: "copper",
    );
  }

  String get concrete {
    return Intl.message(
      "Concrete",
      name: "concrete",
    );
  }

    String get pvc {
    return Intl.message(
      "PVC",
      name: "pvc",
    );
  }

  String get water {
    return Intl.message(
      "Water",
      name: "water",
    );
  }

  String get benzene {
    return Intl.message(
      "Benzene",
      name: "benzene",
    );
  }

  String get toluene {
    return Intl.message(
      "Toluene",
      name: "toluene",
    );
  }

  String get oil {
    return Intl.message(
      "Oil",
      name: "oil",
    );
  }

  String get acetone {
    return Intl.message(
      "Acetone",
      name: "acetone",
    );
  }

  String get ethylAlcohol {
    return Intl.message(
      "Ethyl Alcohol",
      name: "ethylAlcohol",
    );
  }

  String get air {
    return Intl.message(
      "Air",
      name: "air",
    );
  }

  // Home Page
  String get simulop {
    return Intl.message(
      "SimulOP",
      name: "simulop",
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

  String get ouIName {
    return Intl.message(
      "UO I",
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
      "Simple centrifugal pump specification example, after entering the piping information (diametre, length, etc.) a graph is shown where the effects of process variables can be visualized.",
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
      "Not yet available",
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
      "Not yet available",
      name: "compressorDescription",
    );
  }

  String get ouIIName {
    return Intl.message(
      "UO II",
      name: "ouIIName",
    );
  }

  String get doublePipeHeatXName {
    return Intl.message(
      "Double Pipe Heat Exchanger",
      name: "doublePipeHeatXName",
    );
  }

  String get doublePipeHeatXDescription {
    return Intl.message(
      "A double pipe heat exchanger, where the influences of variables such as mass flow, diameter and viscosity on the primary heat exchanger characteristics (heat exchanger and pressure drop) can be verified.",
      name: "doublePipeHeatXDescription",
    );
  }

  String get multiPipeHeatXName {
    return Intl.message(
      "Multi Pipe Heat Exchanger",
      name: "multiPipeHeatXName",
    );
  }

  String get multiPipeHeatXDescription {
    return Intl.message(
      "Not yet available",
      name: "multiPipeHeatXDescription",
    );
  }

  String get evaporatorsName {
    return Intl.message(
      "Evaporator",
      name: "evaporatorsName",
    );
  }

  String get evaporatorsDescription {
    return Intl.message(
      "Not yet available",
      name: "evaporatorsDescription",
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
      "Not yet available",
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
      "Not yet available",
      name: "coolingTowerDescription",
    );
  }

  String get ouIIIName {
    return Intl.message(
      "UO III",
      name: "ouIIIName",
    );
  }

  String get mcCabeTheileName {
    return Intl.message(
      "McCabe-Thile Method",
      name: "mcCabeTheileName",
    );
  }

  String get mcCabeTheileDescription {
    return Intl.message(
      "A simple and intuitive introduction to binary distillation, where the effects of complex variables of a distillation tower (reflux rate, number of plates, etc.) is easy to verify and form an intuition of the possible effects on more complex distillation simulation and real columns.",
      name: "mcCabeTheileDescription",
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
      "Coluna de absorção em construção",
      name: "absorptionColumnDescription",
    );
  }

  String get absorption {
    return Intl.message(
      "Absorption",
      name: "absorption",
    );
  }

  String get absorptionInput {
    return Intl.message(
      "absorption",
      name: "absorptionInput",
    );
  }

  String get stripping {
    return Intl.message(
      "Stripping",
      name: "stripping",
    );
  }

  String get strippingInput {
    return Intl.message(
      "stripping",
      name: "strippingInput",
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
      "Not yet available",
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
      "Not yet available",
      name: "crystalizerDescription",
    );
  }

  String get distilationColumnName {
    return Intl.message(
      "Distillation Column",
      name: "distilationColumnName",
    );
  }

  String get distilationColumnDescription {
    return Intl.message(
      "Not yet available",
      name: "distilationColumnDescription",
    );
  }

  // Pumping of Liquids Input
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

  String get gasInput {
    return Intl.message(
      "Gas Input:",
      name: "gasInput",
    );
  }

  String get contaminantInput {
    return Intl.message(
      "Contaminant Input:",
      name: "contaminantInput",
    );
  }

  String get hintSelectLiquid {
    return Intl.message(
      "Select Liquid",
      name: "hintSelectLiquid",
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

  String get hintSelectMaterial {
    return Intl.message(
      "Select Material",
      name: "hintSelectMaterial",
    );
  }

  String get hintDiametre {
    return Intl.message(
      "Diameter (cm)",
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
    return Intl.message("Diameter:", name: "summaryDiametre");
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
      name: "results",
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

// Double Pipe HeatX Input
  String get outerPipe {
    return Intl.message(
      "Outer Pipe:",
      name: "outerPipe",
    );
  }

  String get hintEntryTemperature {
    return Intl.message(
      "Entry Temperature: (°C)",
      name: "hintEntryTemperature",
    );
  }

  String get hintExitTemperature {
    return Intl.message(
      "Exit Temperature: (°C)",
      name: "hintExitTemperature",
    );
  }

  String get innerPipe {
    return Intl.message(
      "Inner Pipe:",
      name: "innerPipe",
    );
  }

  String get heatX {
    return Intl.message(
      "HeatX:",
      name: "heatX",
    );
  }

  String get hintSelectTubeMaterial {
    return Intl.message(
      "Select Tube Material",
      name: "hintSelectTubeMaterial",
    );
  }

  String get hintHotFlow {
    return Intl.message(
      "Hot Flow: (m^3/h)",
      name: "hintHotFlow",
    );
  }

  String get hintFoolingFactor {
    return Intl.message(
      "Fooling Factor ()",
      name: "hintFoolingFactor",
    );
  }

  String get hintThicknnes {
    return Intl.message(
      "Thicknnes (cm)",
      name: "hintThicknnes",
    );
  }

  String get summaryOuterLiquid {
    return Intl.message(
      "Outer Liquid",
      name: "summaryOuterLiquid",
    );
  }

  String get summaryBulckTemp {
    return Intl.message(
      "Bulck Temperature:",
      name: "summaryBulckTemp",
    );
  }

  String get summarySpecificHeat {
    return Intl.message(
      "Specific Heat:",
      name: "summarySpecificHeat",
    );
  }

  String get summaryInnerLiquid {
    return Intl.message(
      "Inner Liquid",
      name: "summaryInnerLiquid",
    );
  }

  // Double Pipe HeatX Results
  String get graphLenght {
    return Intl.message(
      "Graph - Lenght",
      name: "graphLenght",
    );
  }

  String get graphPressure {
    return Intl.message(
      "Graph - Pressure Drop",
      name: "graphPressure",
    );
  }

  String get resultsHotExitTemp {
    return Intl.message(
      "Hot Liquid Exit Temperature:",
      name: "resultsHotExitTemp",
    );
  }

  String get resultsInnerPressure {
    return Intl.message(
      "Inner Pipe Pressure Drop:",
      name: "resultsInnerPressure",
    );
  }

  String get resultsOuterPressure {
    return Intl.message(
      "Outer Pipe Pressure Drop:",
      name: "resultsOuterPressure",
    );
  }

  String get resultsGlobalCoef {
    return Intl.message(
      "Global Coeff:",
      name: "resultsGlobalCoef",
    );
  }

  String get resultsHeatXLenght {
    return Intl.message(
      "HeatX Lenght:",
      name: "resultsHeatXLenght",
    );
  }

  String get resultsColdFlow {
    return Intl.message(
      "Cold Flow:",
      name: "resultsColdFlow",
    );
  }

  String get resultsHeatExchanged {
    return Intl.message(
      "Total Heat Exchanged:",
      name: "resultsHeatExchanged",
    );
  }

  // McCabe-Thiele Input
  String get mixtureInput {
    return Intl.message(
      "Mixture Input",
      name: "mixtureInput",
    );
  }

  String get liquidLK {
    return Intl.message(
      "Liquid LK:",
      name: "liquidLK",
    );
  }

  String get hintLiquidLK {
    return Intl.message(
      "Select Liquid LK",
      name: "hintLiquidLK",
    );
  }

  String get liquidHK {
    return Intl.message(
      "Liquid HK:",
      name: "liquidHK",
    );
  }

  String get hintLiquidHK {
    return Intl.message(
      "Select Liquid HK",
      name: "hintLiquidHK",
    );
  }

  String get alphaValue {
    return Intl.message(
      "Relative Volatility:",
      name: "alphaValue",
    );
  }

// McCabe-Thile Results
  String get graphEquilibrium {
    return Intl.message(
      "Equilibrium",
      name: "graphEquilibrium",
    );
  }

  String get graphOperationCurves {
    return Intl.message(
      "Operation Lines",
      name: "graphOperationCurves",
    );
  }

  String get graphStages {
    return Intl.message(
      "Stages",
      name: "graphStages",
    );
  }

  String get resultsNumberOfStages {
    return Intl.message(
      "Number of Theoretical Stages:",
      name: "resultsNumberOfStages",
    );
  }

  String get resultsIdialFeed {
    return Intl.message(
      "Idial Feed Stage:",
      name: "resultsIdialFeed",
    );
  }

  String get drawerLKFeed {
    return Intl.message(
      "LK Feed Fraction:",
      name: "drawerLKFeed",
    );
  }

  String get drawerFeedCond {
    return Intl.message(
      "Feed Condition:",
      name: "drawerFeedCond",
    );
  }

  String get drawerReflxRatio {
    return Intl.message(
      "Reflux Ratio:",
      name: "drawerReflxRatio",
    );
  }

  String get drawerTargetXD {
    return Intl.message(
      "Target XD:",
      name: "drawerTargetXD",
    );
  }

  String get drawerTargetXB {
    return Intl.message(
      "Target XB:",
      name: "drawerTargetXB",
    );
  }

  String get mcCabThieleDomainAxis {
    return Intl.message(
      "LK Liquid Fraction",
      name: "mcCabThieleDomainAxis",
    );
  }

  String get mcCabThieleFunctionAxis {
    return Intl.message(
      "LK Vapor Fraction",
      name: "mcCabThieleFunctionAxis",
    );
  }

  String get doublePipeDomainAxis {
    return Intl.message(
      "Hot Liquid Exit Temp. (°C)",
      name: "doublePipeDomainAxis",
    );
  }

  String get doublePipeFunctionPressureAxis {
    return Intl.message(
      "Pressure Drop (KPa)",
      name: "doublePipeFunctionPressureAxis",
    );
  }

  String get doublePipeFunctionLenghtAxis {
    return Intl.message(
      "Lenght (m)",
      name: "doublePipeFunctionLenghtAxis",
    );
  }

  String get pumpingDomainAxis {
    return Intl.message(
      "Volumetric Flow (m^3/h)",
      name: "pumpingDomainAxis",
    );
  }

  String get pumpingFunctionAxis {
    return Intl.message(
      "Meters of Liquid column",
      name: "pumpingFunctionAxis",
    );
  }

  String get columnType {
    return Intl.message(
      "Column Type",
      name: "columnType",
    );
  }

  String get purity {
    return Intl.message(
      "Purity (%)",
      name: "purity",
    );
  }

  String get desiredPurity {
    return Intl.message(
      "Desired Purity:",
      name: "desiredPurity",
    );
  }

  String get missingParameter {
    return Intl.message(
      "Missing parameter",
      name: "missingParameter",
    );
  }

  String get maxContaminantOut {
    return Intl.message(
      "Maximum Contaminant Concentration at Output",
      name: "maxContaminantOut",
    );
  }

  String get streamsSpecies {
    return Intl.message(
      "Select the Chemical Species in the Streams",
      name: "streamsSpecies",
    );
  }

  String get contaminantPerCent {
    return Intl.message(
      "Contaminant (%)",
      name: "contaminantPerCent",
    );
  }

  String get hypothesis {
    return Intl.message(
      "Hypothesis:",
      name: "hypothesis",
    );
  }

  String get dilutedSolutions {
    return Intl.message(
      "Diluted Solutions",
      name: "dilutedSolutions",
    );
  }

  String get liquidStream {
    return Intl.message(
      "Liquid Stream:",
      name: "liquidStream",
    );
  }

  String get gasStream {
    return Intl.message(
      "Gas Stream:",
      name: "gasStream",
    );
  }

  String get contaminant {
    return Intl.message(
      "Contaminant:",
      name: "contaminant",
    );
  }

  String get contaminantIn {
    return Intl.message(
      "Contaminant Concentration at Entry (%)",
      name: "contaminantIn",
    );
  }

  String get contaminantOut {
    return Intl.message(
      "Contaminant Concentration at Output (%)",
      name: "contaminantOut",
    );
  }

  String get inletGasFlow {
    return Intl.message(
      "Inlet Gas Flow (kmol/h)",
      name: "inletGasFlow",
    );
  }

  String get inletLiquidFlow {
    return Intl.message(
      "Inlet Liquid Flow (kmol/h)",
      name: "inletLiquidFlow",
    );
  }

  String get vaporFraction {
    return Intl.message(
      "Mole Fraction in Vapor Phase",
      name: "vaporFraction",
    );
  }

  String get liquidFraction {
    return Intl.message(
      "Mole Fraction in Liquid Phase",
      name: "liquidFraction",
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
