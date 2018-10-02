import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:scoped_model/scoped_model.dart';
import 'package:rxdart/subjects.dart';

import 'package:simulop_v1/core/core.dart' as core;

class DoublePipeBloc extends Model {
  final DoublePipeHeatXSimulation _simulation;

  DoublePipeBloc(this._simulation) {
    _simulation.heatX.computeExchange();
    _addStreams();
  }

  bool showOuterTempExit() {
    return (_simulation.hotTube == core.PipeType.inner) ? true : false;
  }

  bool showInnerTempExit() {
    return (_simulation.hotTube == core.PipeType.outer) ? true : false;
  }

  void setOuterTempIn(double t) {
    _simulation.heatX.outerLiquidIn.temperature = t + 273.15;
    _addStreams();
    notifyListeners();
  }

  double get outerTempIn =>
      _simulation.heatX.outerLiquidIn.temperature - 273.15;

  void setOuterTempExit(double t) {
    _simulation.heatX.innerExitTemp = t + 273.15;
    _addStreams();
    notifyListeners();
  }

  double get outerTempExit => _simulation.heatX.innerExitTemp - 273.15;

  void setInnerTempIn(double t) {
    _simulation.innerLiquid.temperature = t + 237.15;
    _addStreams();
    notifyListeners();
  }

  double get innerTempIn => _simulation.innerLiquid.temperature - 273.15;

  void setInnerTempExit(double t) {
    _simulation.heatX.innerExitTemp = t + 273.15;
    _addStreams();
    notifyListeners();
  }

  double get innerTempExit => _simulation.heatX.innerExitTemp - 273.15;

  void setHotFlow(double f) {
    _simulation.heatX.hotFlow = f / 3600.0;
    _addStreams();
    notifyListeners();
  }

  double get hotFlow => _simulation.heatX.hotFlow * 3600.0;

  void setOuterDiametre(double d) {
    d = d * 1e-2;
    _simulation.outerTube.externalDiametre = d;
    if ((d - _simulation.innerTube.externalDiametre) < 0.019) {
      _simulation.innerTube.externalDiametre = (d - 0.02);
    }
    _addStreams();
    notifyListeners();
  }

  double get outerDiametre => _simulation.outerTube.externalDiametre * 1e2;

  void setInnerDiametre(double d) {
    d = d * 1e-2;
    _simulation.innerTube.externalDiametre = d;
    _simulation.outerTube.diametreOfInternalTube = d;
    if ((_simulation.outerTube.externalDiametre - d) < 0.019) {
      _simulation.outerTube.externalDiametre = d + 0.02;
    }
    _addStreams();
    notifyListeners();
  }

  double get innerDiametre => _simulation.innerTube.externalDiametre * 1e2;

  SlidersMinMax get slidersMinMax => _simulation.sliders;

  double get getSliderDomain => _simulation.chartTemp;

  void onSliderCanged(math.Point<int> point, dynamic domain,
      charts.SliderListenerDragState dragState) {
    if (dragState.index == 2) {
      _simulation.chartTemp = domain;
      _addStreams();
    }
  }

  Stream<Results> get getResults => _resultsSubject.stream;

  final _resultsSubject = BehaviorSubject<Results>();

  Stream<Plot> get getPlots => _plotsSubject.stream;

  final _plotsSubject = BehaviorSubject<Plot>();

  void _addStreams() {
    final results = _simulation.getResults();
    final plots = _simulation.getPlots(28.0, 38.0, 40);
    _resultsSubject.add(results);
    _plotsSubject.add(plots);
  }

  bool getChartView() {
    return _simulation.showPressureDrop;
  }

  void toggleChartView(bool val) {
    _simulation.showPressureDrop = val;
    _addStreams();
    notifyListeners();
  }

  String getChartText() {
    String type = (_simulation.showPressureDrop) ? "Pressure Drop" : "Lenght";
    return "Graph - $type";
  }

  void dispose() {
    _resultsSubject.close();
    _plotsSubject.cast();
  }
}

class DoublePipeHeatXSimulation {
  core.DoublePibeTube outerTube;
  core.Liquid outerLiquid;
  core.DoublePibeTube innerTube;
  core.Liquid innerLiquid;
  core.DoublePipeHeatX heatX;

  bool showPressureDrop = false;

  double chartTemp;

  core.PipeType hotTube;

  final SlidersMinMax sliders = SlidersMinMax();

  DoublePipeHeatXSimulation({
    @required this.heatX,
    @required this.innerLiquid,
    @required this.innerTube,
    @required this.outerLiquid,
    @required this.outerTube,
  }) {
    hotTube = (outerLiquid.temperature > innerLiquid.temperature)
        ? core.PipeType.outer
        : core.PipeType.inner;

    chartTemp = (hotTube == core.PipeType.outer)
        ? heatX.outerExitTemp - 273.15
        : heatX.innerExitTemp - 273.15;

    if (hotTube == core.PipeType.outer) {
      sliders.minOuterIn = 40.0;
      sliders.minInnerIn = 10.0;
      sliders.minInnerExit = 42.0;

      sliders.maxOuterIn = 200.0;
      sliders.maxOuterExit = 38.0;
      sliders.maxInnerIn = 40.0;

      sliders.minOuterExit = innerLiquid.temperature + 2.0;
      sliders.maxInnerExit = outerLiquid.temperature - 2.0;
    } else {
      sliders.minInnerIn = 40.0;
      sliders.minOuterIn = 10.0;
      sliders.minOuterExit = 42.0;

      sliders.maxInnerIn = 200.0;
      sliders.maxInnerExit = 38.0;
      sliders.maxOuterIn = 40.0;

      sliders.minInnerExit = outerLiquid.temperature + 2.0;
      sliders.maxOuterExit = innerLiquid.temperature - 2.0;
    }
  }

  Results getResults() {
    heatX.outerExitTemp = chartTemp + 273.15;
    heatX.computeExchange();
    return Results(
      exitTemp: chartTemp.toStringAsFixed(1),
      coldFlow: (heatX.coldFlow * 3600.0).toStringAsFixed(2),
      globalCoef: heatX.globalHeatTransCoeff.toStringAsFixed(2),
      heatExchanged: (heatX.exchangeHeat / 1000.0).toStringAsFixed(2),
      heatXLenght: heatX.lenght.toStringAsFixed(2),
      innerPressureDrop: (innerTube.pressureDrop * 1e-3).toStringAsFixed(2),
      outerPressureDrop: (outerTube.pressureDrop * 1e-3).toStringAsFixed(2),
    );
  }

  Plot getPlots(double minExitTemp, double maxExitTemp, int div) {
    final plot = heatX.plotresults(minExitTemp, maxExitTemp, div);
    return Plot(
        outerPlot: plot[0],
        innerPlot: plot[1],
        lenghtPlot: plot[2],
        isChartPressure: showPressureDrop);
  }
}

class SlidersMinMax {
  double minOuterIn;
  double minOuterExit;
  double minInnerIn;
  double minInnerExit;

  double maxOuterIn;
  double maxOuterExit;
  double maxInnerIn;
  double maxInnerExit;
}

class Results {
  final String exitTemp;
  final String outerPressureDrop;
  final String innerPressureDrop;
  final String globalCoef;
  final String heatXLenght;
  final String coldFlow;
  final String heatExchanged;

  Results(
      {this.exitTemp,
      this.coldFlow,
      this.globalCoef,
      this.heatExchanged,
      this.heatXLenght,
      this.innerPressureDrop,
      this.outerPressureDrop});
}

class Plot {
  final List<math.Point> lenghtPlot;
  final List<math.Point> outerPlot;
  final List<math.Point> innerPlot;

  final bool isChartPressure;

  Plot({this.innerPlot, this.outerPlot, this.lenghtPlot, this.isChartPressure});
}
