import 'package:scoped_model/scoped_model.dart';
import 'package:simulop_v1/pages/helper_classes/chart_items.dart';

class PumpingOfFluidsSimulationModel extends Model {
  final PumpingOfFluidsSimulation _simulation;

  PumpingOfFluidsSimulationModel(this._simulation);

  String get getMyData => _simulation.string;

  List<ChartPoint> get getPoints => _simulation.data;
  List<ChartPoint> get getPoints2 => _simulation.data2;

  String get getHead => _simulation.head;
  String get getNpsh => _simulation.npsh;
  String get getDefualt => "Defualt Text";

  double get getFlow => _simulation.volumetricFlow;
  double get getTemperature => _simulation.fluidTemperature;
  double get getInletValve => _simulation.inletValveOpeningFactor;
  double get getInletTankPressure => _simulation.inletTankPressure;
  double get getOutletValve => _simulation.outletValveOpeningFactor;

  void onFlowChanged(double v) {
    _simulation.volumetricFlow = v;
    notifyListeners();
  }

  void onTemperatureChanged(double t) {
    _simulation.fluidTemperature = t;
    notifyListeners();
  }

   void onInletValveChange(double o) {
     _simulation.inletValveOpeningFactor = o;
     notifyListeners();
   }

  void onInletTankPressureChanged(double p) {
    _simulation.inletTankPressure = p;
    notifyListeners();
  }

  void onOutletValveChange(double o) {
    _simulation.outletValveOpeningFactor = o;
    notifyListeners();
  }
}

class PumpingOfFluidsSimulation{
  String string = "Inside the Simulation";
  String head = "40";
  String npsh = "3";

  double volumetricFlow = 0.0;
  double fluidTemperature = 30.0;
  double inletValveOpeningFactor = 10.0;
  double inletTankPressure = 5.0;
  double outletValveOpeningFactor = 10.0;

  final List<ChartPoint> data = [
    ChartPoint(0.0, 0.0),
    ChartPoint(0.2, 0.2),
    ChartPoint(0.4, 0.4),
    ChartPoint(0.6, 0.6),
    ChartPoint(0.8, 5.0),
    ChartPoint(1.0, 6.0),
  ];

   final List<ChartPoint> data2 = [
    ChartPoint(1.0, 0.0 + 100.0),
    ChartPoint(1.2, 0.2 + 100.0),
    ChartPoint(1.4, 0.4 + 100.0),
    ChartPoint(1.6, 0.6 + 100.0),
    ChartPoint(1.8, 5.0 + 100.0),
    ChartPoint(2.0, 6.0 + 100.0),
  ]; 

}