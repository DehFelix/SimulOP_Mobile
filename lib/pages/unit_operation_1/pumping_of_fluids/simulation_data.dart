import 'package:scoped_model/scoped_model.dart';
import 'dart:math' as math;
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:simulop_v1/core/core.dart' as core;

class PumpingOfFluidsSimulationModel extends Model {
  final PumpingOfFluidsSimulation _simulation;

  PumpingOfFluidsSimulationModel(this._simulation);

  String get getMyData => _simulation.string;
  String get getDefault => "Default Text";

  List<math.Point> get getPointsHead => _simulation.plotNecessaryHead();
  List<math.Point> get getPointsNPSH => _simulation.plotAvailebleNPSH();

  String get getHead => _simulation.pump.computeNecessaryHead(_simulation.volumeFlow).toStringAsFixed(1);
  String get getNpsh => _simulation.pump.availebleNPSH(_simulation.volumeFlow).toStringAsFixed(1);
  String get getFlow => _simulation.volumeFlow.toStringAsFixed(1);

  double get getTemperature => _simulation.liquid.temperature - 273.15;
  double get getInletValve => _simulation.inletValve.opening * 10;
  double get getInletTankPressure => _simulation.pump.inletPressure / 1e5;
  double get getOutletValve => _simulation.outletValve.opening * 10.0;
  double get getDzInlet => _simulation.inletTube.elevationDiference;
  double get getLInlet => _simulation.inletTube.lengh;
  double get getDzOutlet => _simulation.outletTube.elevationDiference;
  double get getLOutlet => _simulation.outletTube.lengh;

  void onTemperatureChanged(double t) {
    _simulation.liquid.temperature = t + 273.15;
    notifyListeners();
  }

  void onInletValveChange(double o) {
    _simulation.inletValve.opening = o / 10.0;
    notifyListeners();
  }

  void onInletTankPressureChanged(double p) {
    _simulation.pump.inletPressure = p * 1e5;
    notifyListeners();
  }

  void onOutletValveChange(double o) {
    _simulation.outletValve.opening = o / 10.0;
    notifyListeners();
  }

  void onDzInletChange(double dz) {
    _simulation.inletTube.elevationDiference = dz;
    notifyListeners();
  }

  void onLInletChange(double l) {
    _simulation.inletTube.lengh = l;
    notifyListeners();
  }

  void onDzOutletChange(double dz) {
    _simulation.outletTube.elevationDiference = dz;
    notifyListeners();
  }

  void onLOutletChange(double l) {
    _simulation.outletTube.lengh = l;
    notifyListeners();
  }

  void onSliderChanged(math.Point<int> point, dynamic domain, charts.SliderListenerDragState dragState) {
    _simulation.volumeFlow = domain;
    notifyListeners();
  }

}

class PumpingOfFluidsSimulation{
  core.Liquid liquid;
  core.Tube inletTube;
  core.LocalResistance inletResistance;
  core.SimpleValve inletValve;
  core.Tube outletTube;
  core.LocalResistance outletResistance;
  core.SimpleValve outletValve;
  core.CompletePump pump;

  double volumeFlow = 1.0;

  PumpingOfFluidsSimulation();

  double getHead(){
    return pump.computeNecessaryHead(volumeFlow);
  }

  double getHPSH(){
    return pump.availebleNPSH(volumeFlow);
  }

  List<math.Point> plotNecessaryHead(){
    return pump.plotRequeredHead(0.01, 2.0);
  }

  List<math.Point> plotAvailebleNPSH(){
    return pump.plotNPSH(0.01, 2.0);
  }

  String string = "Inside the Simulation";
  String head = "40";
  String npsh = "3";

  double liquidTemperature = 30.0;
  double inletValveOpeningFactor = 10.0;
  double inletTankPressure = 5.0;
  double outletValveOpeningFactor = 10.0;

  final List<math.Point> data = [
    math.Point(0.0, 0.0),
    math.Point(0.2, 0.2),
    math.Point(0.4, 0.4),
    math.Point(0.6, 0.6),
    math.Point(0.8, 5.0),
    math.Point(1.0, 6.0),
  ];

   final List<math.Point> data2 = [
    math.Point(1.0, 0.0 + 100.0),
    math.Point(1.2, 0.2 + 100.0),
    math.Point(1.4, 0.4 + 100.0),
    math.Point(1.6, 0.6 + 100.0),
    math.Point(1.8, 5.0 + 100.0),
    math.Point(2.0, 6.0 + 100.0),
  ]; 

}