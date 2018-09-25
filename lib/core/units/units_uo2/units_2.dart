import 'package:simulop_v1/core/units/units.dart';

abstract class Units2 extends Units {
  static double get waterDensityImperial => 62.42796529; //[lb/ft^3]

  static double get waterDensitySI => 1000.0; //[kg/m^3]
}

enum HeaterConfig { coCurrent, counterCurrent }

enum PipeType { inner, outer }

enum ExchangeFluid { hot, cold }
