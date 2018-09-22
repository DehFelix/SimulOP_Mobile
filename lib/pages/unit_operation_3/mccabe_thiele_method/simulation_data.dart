import 'package:scoped_model/scoped_model.dart';
import 'dart:math' as math;

import 'package:simulop_v1/core/core.dart' as core;

class McCabeThieleSimulationModel extends Model {
  final McCabeThieleSimulation simulation;

  McCabeThieleSimulationModel(this.simulation);

  List<math.Point> get getEquilibrium =>
      simulation.mcCabeThiele.plotEquilibrium(40);
  List<math.Point> get getOperationCurves =>
      simulation.mcCabeThiele.plotOpCurve(40);
  List<math.Point> get getStages {
    var plot = simulation.mcCabeThiele.plotStages();
    notifyListeners();
    return plot;
  }

  double get getfeedFraction => simulation.mcCabeThiele.feedZf;
  double get getfeedCondition => simulation.mcCabeThiele.feedConditionQ;
  double get getRefluxRatio => simulation.mcCabeThiele.refluxRatio;
  double get getTargetXD => simulation.mcCabeThiele.targetXD;
  double get getTargetXB => simulation.mcCabeThiele.targetXB;
  double get getPressure => simulation.mixture.pressure / 1e5;

  String get getAlpha =>
      simulation.mcCabeThiele.binaryMixture.alpha.toStringAsFixed(2);
  String get getNumberStage => simulation.mcCabeThiele.numberStages.toString();
  String get getOptimalStage => simulation.mcCabeThiele.idialStage.toString();

  void onFeedFractionChanged(double z) {
    simulation.mcCabeThiele.feedZf = z;
    notifyListeners();
  }

  void onFeedFractionConditionChanged(double q) {
    simulation.mcCabeThiele.feedConditionQ = q;
    notifyListeners();
  }

  void onRefluxRationChanged(double r) {
    simulation.mcCabeThiele.refluxRatio = r;
    notifyListeners();
  }

  void onTargetXDChanged(double d) {
    simulation.mcCabeThiele.targetXD = d;
    notifyListeners();
  }

  void onTargetXBChanged(double b) {
    simulation.mcCabeThiele.targetXB = b;
    notifyListeners();
  }

  void onPressureChanged(double p) {
    simulation.mixture.pressure = p * 1e5;
    notifyListeners();
  }
}

class McCabeThieleSimulation {
  core.Liquid liquidLK;
  core.Liquid liquidHK;
  core.BinaryMixture mixture;
  core.McCabeThieleMethod mcCabeThiele;
}
