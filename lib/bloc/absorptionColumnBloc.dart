import 'dart:math' as math;
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:simulop_v1/core/core.dart' as core;
import 'package:simulop_v1/pages/helper_classes/options_input_helper.dart';

class AbsorptionColumnSimulation {
  final String columnType;
  final LiquidHelper liquid;
  final GasesHelper gas;
  final ContaminantsHelper contaminant;
  final core.AbsorptionColumnMethod absorptionColumn;

  AbsorptionColumnSimulation({
    @required this.columnType,
    @required this.liquid,
    @required this.gas,
    @required this.contaminant,
    @required this.absorptionColumn,
  });
}

class Results {
  final String numberOfStages;

  Results({
    @required this.numberOfStages,
  });
}

class PlotPoints {
  final List<math.Point> equilibrium;
  final List<math.Point> operationCurve;
  final List<math.Point> plotStages;

  PlotPoints(
      {@required this.equilibrium,
      @required this.operationCurve,
      @required this.plotStages
      });
}

enum Variable {
  gasFeed,
  liquidFeed,
  purity,
  percentOfContaminant,
  contaminantOut,
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

class AbsorptionColumnResultsBloc {
  AbsorptionColumnSimulation _simulation;

  Map<Variable, double> _simpleValue;

  AbsorptionColumnResultsBloc({AbsorptionColumnSimulation simulation}) {
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

  List<math.Point> plotEqCurve;
  List<math.Point> operationCurve;
  List<math.Point> plotOperationCurve;
  List<math.Point> plotStages;

  void updateAll() {
    _currentValue.add(
      {
        Variable.gasFeed: _simulation.absorptionColumn.gasFeed,
        Variable.liquidFeed: _simulation.absorptionColumn.liquidFeed,
        Variable.percentOfContaminant:
            _simulation.absorptionColumn.percentOfContaminant,
        Variable.contaminantOut:
            _simulation.absorptionColumn.contaminantOut * 100,
      },
    );
    operationCurve = _simulation.absorptionColumn.opCurveConstructor();
    plotEqCurve = _simulation.absorptionColumn.plotEquilibrium();
    plotOperationCurve =
        _simulation.absorptionColumn.plotOpCurve(plotEqCurve, operationCurve);
    plotStages = _simulation.absorptionColumn
        .plotStages(plotEqCurve, plotOperationCurve);

    _plotPoints.add(
      PlotPoints(
          equilibrium: plotEqCurve,
          operationCurve: plotOperationCurve,
          plotStages: plotStages
          ),
    );

    _results.add(
      Results(
        numberOfStages: _simulation.absorptionColumn.stageNumbers < 50
            ? _simulation.absorptionColumn.stageNumbers.toString()
            : 'infinite',
      ),
    );
  }

  void _updateVariable(InputVar input, {bool update = true}) {
    switch (input.variable) {
      case Variable.gasFeed:
        _simulation.absorptionColumn.gasFeed = input.value;
        _simulation.absorptionColumn.updateFeedDependencies('gasFeed');
        break;
      case Variable.liquidFeed:
        _simulation.absorptionColumn.liquidFeed = input.value;
        _simulation.absorptionColumn.updateFeedDependencies('liquidFeed');
        break;
      case Variable.percentOfContaminant:
        _simulation.absorptionColumn.percentOfContaminant = input.value;
        _simulation.absorptionColumn.updateFeedDependencies('contaminant');
        break;
      case Variable.contaminantOut:
        _simulation.absorptionColumn.contaminantOut = input.value / 100;
        _simulation.absorptionColumn.updatePurityDependencies();
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
