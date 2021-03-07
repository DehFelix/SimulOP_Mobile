// import 'dart:math' as math;
import 'package:scoped_model/scoped_model.dart';

/// Base de cálculo = 100

/// Variáveis:
/// percentOfContaminant = entrada de contaminante (%)
/// purity = pureza (%)
/// gasIn = corrente gasoza (kmol/h)
class Calculos extends Model {
  double contaminantIn; // kmol/h;
  double airIn; // kmol/h;
  final double baseDeCalculo = 100; // kmol/h;
  double airOut; // kmol/h
  Map<String, double> fixedPoint; // (x, y)
  double contaminantOut; // kmol/h

  void setInValues(double percentOfContaminant, double gasIn) {
    contaminantIn = gasIn * percentOfContaminant / 100;
    airIn = gasIn - contaminantIn;
    print("contaminante: $contaminantIn");
    print('\n');
    print("entrada ar: $airIn");
  }

  void setOutValues(double purity) {
    airOut = airIn;
    contaminantOut = (airOut / (purity / 100)) * (1 - purity / 100);
    print("contaminante na saída: $contaminantOut");
    print('\n');
  }

  void setFixedPoint() {
    fixedPoint = {'X': 0.0, 'Y': (contaminantOut / airOut)};
    print("ponto fixo: $fixedPoint");
    return;
  }
}
