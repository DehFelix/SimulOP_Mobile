import 'package:scoped_model/scoped_model.dart';
import 'dart:math' as math;
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:simulop_v1/core/core.dart' as core;

class PumpingOfFluidsSimulationModel extends Model {
  final PumpingOfFluidsSimulation _simulation;

  PumpingOfFluidsSimulationModel(this._simulation);

  PumpingOfFluidsSimulation get simukation => _simulation;

  String get getMyData => _simulation.string;
  String get getDefault => "Default Text";

  List<math.Point> get getPointsHead => _simulation.plotNecessaryHead();
  List<math.Point> get getPointsNPSH => _simulation.plotAvailebleNPSH();

  String get getHead => _simulation.pump
      .computeNecessaryHead(_simulation.volumeFlow / 3600.0)
      .toStringAsFixed(1);
  String get getNpsh => _simulation.pump
      .availebleNPSH(_simulation.volumeFlow / 3600.0)
      .toStringAsFixed(1);
  String get getFlow => _simulation.volumeFlow.toStringAsFixed(1);

  double get getTemperature => _simulation.liquid.temperature - 273.15;
  double get getInletValve => _simulation.inletValve.opening * 10;
  double get getInletTankPressure => _simulation.pump.inletPressure / 1e5;
  double get getOutletValve => _simulation.outletValve.opening * 10.0;
  double get getDzInlet => _simulation.inletTube.elevationDiference;
  double get getLInlet => _simulation.inletTube.length;
  double get getDzOutlet => _simulation.outletTube.elevationDiference;
  double get getLOutlet => _simulation.outletTube.length;

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
    _simulation.inletTube.length = l;
    notifyListeners();
  }

  void onDzOutletChange(double dz) {
    _simulation.outletTube.elevationDiference = dz;
    notifyListeners();
  }

  void onLOutletChange(double l) {
    _simulation.outletTube.length = l;
    notifyListeners();
  }

  void onSliderChanged(math.Point<int> point, dynamic domain, String s,
      charts.SliderListenerDragState dragState) {
    if (dragState.index == 2) {
      _simulation.volumeFlow = domain;
      notifyListeners();
    }
  }
}

class PumpingOfFluidsSimulation {
  core.Liquid liquid;
  core.Tube inletTube;
  core.LocalResistance inletResistance;
  core.SimpleValve inletValve;
  core.Tube outletTube;
  core.LocalResistance outletResistance;
  core.SimpleValve outletValve;
  core.CompletePump pump;

  double volumeFlow = 3.0;

  PumpingOfFluidsSimulation();

  double getHead() {
    return pump.computeNecessaryHead(volumeFlow / 3600.0);
  }

  double getHPSH() {
    return pump.availebleNPSH(volumeFlow / 3600.0);
  }

  List<math.Point> plotNecessaryHead() {
    return pump.plotRequeredHead(0.01 / 3600, 10.0 / 3600);
  }

  List<math.Point> plotAvailebleNPSH() {
    return pump.plotNPSH(0.01 / 3600, 10.0 / 3600);
  }

  String string = "Inside the Simulation";
}
