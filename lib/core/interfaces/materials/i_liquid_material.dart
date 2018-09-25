abstract class ILiquidMaterial {
  String get name;

  double get temperature;

  set temperature(double t);

  double get density;

  double get viscosity;

  double get specificHeat;

  double get thermalConductivity;

  double get pr;

  List<double> get antoineCoef;

  ILiquidMaterial clone();
}
