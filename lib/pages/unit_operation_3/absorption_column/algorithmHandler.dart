// import 'dart:math' as math;
import 'package:scoped_model/scoped_model.dart';

class Calculos extends Model {
  Map gasIn = {'contaminantIn': 0, 'airIn': 0}; // kmol/h
  double contaminantIn;
  double airIn;
  final double baseDeCalculo = 100; // kmol/h;
  double airOut;
  Map<String, double> fixedPoint;
  double contaminantOut;

  void setInValues(double percentOfContaminant) {
    contaminantIn = baseDeCalculo * percentOfContaminant / 100;
    airIn = baseDeCalculo - contaminantIn;
  }

  void setOutValues(double purity) {
    airOut = airIn;
    contaminantOut = (airOut / (purity / 100)) * (1 - purity / 100);
  }

  void setY() {
    fixedPoint = {'X': 0.0, 'Y': (contaminantOut / airOut)};
    return;
  }
}
