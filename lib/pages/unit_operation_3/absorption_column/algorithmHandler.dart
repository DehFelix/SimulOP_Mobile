// import 'dart:math' as math;
import 'package:scoped_model/scoped_model.dart';

/// Base de cálculo = 100

/// Variáveis:
/// percentOfContaminant = entrada de contaminante (%)
/// purity = pureza (%)
/// gasIn = corrente gasoza (kmol/h)
class Calculos extends Model {
  double contaminantIn; // kmol/h;
  double airFeed; // kmol/h;
  final double baseDeCalculo = 100; // kmol/h;
  double airOut; // kmol/h
  Map<String, double> fixedPoint; // (x, y)
  double contaminantOut; // kmol/h
  double gasFeed = 100;
  double purity;

  void setInValues(double percentOfContaminant) {
    contaminantIn = gasFeed * percentOfContaminant / 100;
    airFeed = gasFeed - contaminantIn;
  }

  void setOutValues(double purity) {
    this.purity = purity;
    airOut = airFeed;
    contaminantOut = (airOut / (purity / 100)) * (1 - purity / 100);
  }

  void setFixedPoint() {
    fixedPoint = {'X': 0.0, 'Y': (contaminantOut / airOut)};
    print("ponto fixo: $fixedPoint");
    return;
  }
}
