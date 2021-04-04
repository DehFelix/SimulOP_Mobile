// import 'dart:math' as math;
import 'package:scoped_model/scoped_model.dart';

/// Base de cálculo = 100 kmol/h,
/// Variáveis:
/// percentOfContaminant = entrada de contaminante (%);
/// purity = pureza (%);
/// gasIn = corrente gasoza (kmol/h);
class AbsorptionVariables extends Model {
  double gasContaminantIn; // kmol/h;
  double gasContaminantOut; // kmol/h
  double airFeed; // kmol/h;
  double airOut; // kmol/h
  Map<String, double> fixedPoint; // (x, y)
  double gasFeed = 100; // kmol/h
  double purity;
  double percentOfContaminantIn; // (%)
  double contaminantOut; // (%)
  double liquidFeed = 100;
  double liquidPerGas;
  double liquidContaminantIn = 0.0; // (kmol/h)
  double liquidContaminantOut; // (kmol/h)

  void setInValues(double pcContaminant) {
    percentOfContaminantIn = pcContaminant;
    gasContaminantIn = gasFeed * percentOfContaminantIn / 100;
    airFeed = gasFeed - gasContaminantIn;
    liquidPerGas = liquidFeed / airFeed;
  }

  void setOutValues(double purity) {
    this.purity = purity;
    airOut = airFeed;
    gasContaminantOut = (airOut / (purity / 100)) * (1 - purity / 100);
    liquidContaminantOut = gasContaminantIn - gasContaminantOut;
  }

  // void setOutValues(double cntOut) {
  //   contaminantOut = cntOut;
  //   airOut = airFeed;
  //   gasContaminantOut =
  //       (airOut / (1 - (contaminantOut / 100))) * (contaminantOut / 100);
  //   liquidContaminantOut = gasContaminantIn - gasContaminantOut;
  // }

  void setFixedPoint() {
    fixedPoint = {'X': 0.0, 'Y': (gasContaminantOut / airOut)};
    return;
  }
}
