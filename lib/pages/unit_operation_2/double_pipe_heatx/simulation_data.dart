import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:scoped_model/scoped_model.dart';
import 'package:rxdart/subjects.dart';

import 'package:simulop_v1/core/core.dart' as core;

class DoublePipeBloc extends Model {
  final DoublePipeHeatXSimulation _simulation;

  DoublePipeBloc(this._simulation);

  bool getChartView() {
    return _simulation.showPressureDrop;
  }

  void toggleChartView(bool val) {
    _simulation.showPressureDrop = val;
    notifyListeners();
  }

  String getChartText() {
    String type =
        (_simulation.showPressureDrop) ? "Pressure Drop" : "Temperatures";
    return "Graph - $type";
  }

  void setOuterTempIn(double t) {
    _simulation.heatX.outerLiquidIn.temperature = t + 273.15;
    _addStreams();
    notifyListeners();
  }

  void setOuterTempExit(double t) {
    _simulation.heatX.innerExitTemp = t + 273.15;
    _addStreams();
    notifyListeners();
  }

  void setInnerTempIn(double t) {
    _simulation.innerLiquid.temperature = t + 237.15;
    _addStreams();
    notifyListeners();
  }

  void setInnerTempExit(double t) {
    _simulation.heatX.innerExitTemp = t + 273.15;
    _addStreams();
    notifyListeners();
  }

  void setHotFlow(double f) {
    _simulation.heatX.hotFlow = f / 3600.0;
    _addStreams();
    notifyListeners();
  }

  void setOuterDiametre(double d) {
    _simulation.outterTube.externalDiametre = d;
    _addStreams();
    notifyListeners();
  }

  void setInnerDiametre(double d) {
    _simulation.innerTube.externalDiametre = d;
    _simulation.outterTube.diametreOfInternalTube = d;
    _addStreams();
    notifyListeners();
  }

  void onSliderCanged(math.Point<int> point, dynamic domain,
      charts.SliderListenerDragState dragState) {
    _addStreams();
    notifyListeners();
  }

  Stream<Results> get getResults => _resultsSubject.stream;

  final _resultsSubject = BehaviorSubject<Results>();

  Stream<List<math.Point>> get getPlotTemp => _plotTempSubject.stream;

  final _plotTempSubject = BehaviorSubject<List<math.Point>>();

  Stream<List<math.Point>> get getPlotOuterPresDrop =>
      _plotOuterPresDropSubject.stream;

  final _plotOuterPresDropSubject = BehaviorSubject<List<math.Point>>();

  Stream<List<math.Point>> get getPlotInnerPresDrop =>
      _plotInnerPresDropSubject.stream;

  final _plotInnerPresDropSubject = BehaviorSubject<List<math.Point>>();

  void _addStreams() {
    final results = _simulation.getResults();
    final plots = _simulation.getPlots(0.0, 1.0, 40);
    _resultsSubject.add(results);
    _plotOuterPresDropSubject.add(plots[0]);
    _plotInnerPresDropSubject.add(plots[1]);
    _plotTempSubject.add(plots[2]);
  }

  void dispose() {
    _resultsSubject.close();
    _plotTempSubject.close();
    _plotOuterPresDropSubject.close();
    _plotInnerPresDropSubject.close();
  }
}

class DoublePipeHeatXSimulation {
  core.DoublePibeTube outterTube;
  core.Liquid outterLiquid;
  core.DoublePibeTube innerTube;
  core.Liquid innerLiquid;
  core.DoublePipeHeatX heatX;

  bool showPressureDrop = false;

  double chartTemp;

  DoublePipeHeatXSimulation({
    @required this.heatX,
    @required this.innerLiquid,
    @required this.innerTube,
    @required this.outterLiquid,
    @required this.outterTube,
  });

  Results getResults() {
    return Results(
      coldFlow: heatX.coldFlow.toStringAsFixed(1),
      globalCoef: heatX.globalHeatTransCoeff.toStringAsFixed(1),
      heatExchanged: heatX.exchangeHeat.toStringAsFixed(1),
      heatXLenght: heatX.lenght.toStringAsFixed(1),
      innerPressureDrop: innerTube.pressureDrop.toStringAsFixed(1),
      outerPressureDrop: outterTube.pressureDrop.toStringAsFixed(1),
    );
  }

  List<List<math.Point>> getPlots(
      double minExitTemp, double maxExitTemp, int div) {
    return heatX.plotresults(minExitTemp, maxExitTemp, div);
  }
}

class Results {
  final String outerPressureDrop;
  final String innerPressureDrop;
  final String globalCoef;
  final String heatXLenght;
  final String coldFlow;
  final String heatExchanged;

  Results(
      {this.coldFlow,
      this.globalCoef,
      this.heatExchanged,
      this.heatXLenght,
      this.innerPressureDrop,
      this.outerPressureDrop});
}
