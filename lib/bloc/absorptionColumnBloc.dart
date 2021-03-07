import 'dart:math' as math;
import 'dart:async';

import 'package:meta/meta.dart';

import 'package:rxdart/rxdart.dart';

import 'package:simulop_v1/core/core.dart' as core;

class AbsorptionColumnSimulation {
  final double purity;
  final String columnType;
  final core.AbsorptionColumnMethod absorptionColumn;

  AbsorptionColumnSimulation({
    @required this.purity,
    @required this.columnType,
    @required this.absorptionColumn,
  });
}

// class McCabeThieleSimulation {
//   final core.Liquid liquidLK;
//   final core.Liquid liquidHK;
//   final core.BinaryMixture mixture;
//   final core.McCabeThieleMethod mcCabeThiele;

//   McCabeThieleSimulation({
//     @required this.liquidLK,
//     @required this.liquidHK,
//     @required this.mixture,
//     @required this.mcCabeThiele,
//   });
// }

class Results {
  final String numberOfStages;
  final String idialStage;
  final String alpha;

  final bool hasConverged;

  Results({
    @required this.idialStage,
    @required this.numberOfStages,
    @required this.alpha,
    this.hasConverged = true,
  });
}

class PlotPoints {
  final List<math.Point> equilibrium;
  final List<math.Point> operationCurve;
  final List<math.Point> qline;
  final List<math.Point> stages;

  PlotPoints({
    @required this.equilibrium,
    @required this.operationCurve,
    @required this.qline,
    @required this.stages,
  });
}

enum Variable {
  gasFeed,
  feedFraction,
  feedCondition,
  refluxRatio,
  targetXD,
  targetXB,
  pressure
}

class InputVar {
  final Variable variable;
  final double value;

  InputVar({
    @required this.variable,
    @required this.value,
  });
}

class McCabeResultsBloc {
  McCabeThieleSimulation _simulation;

  Map<Variable, double> _simpleValue;

  McCabeResultsBloc({McCabeThieleSimulation simulation}) {
    this._simulation = simulation;
    _inputControler.stream.listen(_updateVariable);
    _currentValue.stream.listen((data) {
      _simpleValue = data;
    });
    updateAll();
  }

  final _results = BehaviorSubject<Results>();

  final _plotPoints = BehaviorSubject<PlotPoints>();

  final _currentValue = BehaviorSubject<Map<Variable, double>>();

  final _inputControler = StreamController<InputVar>();

  Stream<Results> get results => _results.stream;

  Stream<PlotPoints> get plotPoints => _plotPoints.stream;

  Stream<Map<Variable, double>> get currentValue => _currentValue.stream;

  Sink<InputVar> get inputSink => _inputControler.sink;

  Map<Variable, double> get simpleValue => _simpleValue;

  void updateAll() {
    _currentValue.add(
      {
        // Variable.gasFeed: _simulation.mcCabeThiele.contaminantIn,
        Variable.feedCondition: _simulation.mcCabeThiele.feedConditionQ,
        Variable.feedFraction: _simulation.mcCabeThiele.feedZf,
        Variable.pressure: _simulation.mixture.pressure / 1e5,
        Variable.refluxRatio: _simulation.mcCabeThiele.refluxRatio,
        Variable.targetXD: _simulation.mcCabeThiele.targetXD,
        Variable.targetXB: _simulation.mcCabeThiele.targetXB,
      },
    );

    _plotPoints.add(
      PlotPoints(
        equilibrium: _simulation.mcCabeThiele.plotEquilibrium(40),
        operationCurve: _simulation.mcCabeThiele.plotOpCurve(40),
        qline: _simulation.mcCabeThiele.plotQLine(),
        stages: _simulation.mcCabeThiele.plotStages(),
      ),
    );

    _results.add(
      Results(
        numberOfStages: _simulation.mcCabeThiele.numberStages.toString(),
        idialStage: _simulation.mcCabeThiele.idialStage.toString(),
        alpha: _simulation.mcCabeThiele.binaryMixture.alpha.toStringAsFixed(1),
      ),
    );

    print(_simulation.mcCabeThiele.binaryMixture.alpha.toString());
  }

  void _updateVariable(InputVar input, {bool update = true}) {
    switch (input.variable) {
      case Variable.gasFeed:
        _simulation.mcCabeThiele.gasFeed = input.value;
        break;
      case Variable.feedFraction:
        _simulation.mcCabeThiele.feedZf = input.value;
        break;
      case Variable.feedCondition:
        _simulation.mcCabeThiele.feedConditionQ = input.value;
        break;
      case Variable.refluxRatio:
        _simulation.mcCabeThiele.refluxRatio = input.value;
        break;
      case Variable.targetXD:
        _simulation.mcCabeThiele.targetXD = input.value;
        break;
      case Variable.targetXB:
        _simulation.mcCabeThiele.targetXB = input.value;
        break;
      case Variable.pressure:
        _simulation.mixture.pressure = input.value * 1e5;
        break;
      default:
    }
    if (update) {
      updateAll();
    }
  }

  void dispose() {
    _results.close();
    _plotPoints.close();
    _results.close();
    _currentValue.close();
    _inputControler.close();
  }
}
