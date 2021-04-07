// import 'dart:math' as math;
import 'package:scoped_model/scoped_model.dart';

/// Base de cálculo = 100 kmol/h,
/// Variáveis:
/// percentOfContaminant = entrada de contaminante (%);
/// purity = pureza (%);
/// gasIn = corrente gasoza (kmol/h);
class AbsorptionVariables extends Model {
  String columnType = 'absorption';
  double gasContaminantIn; // kmol/h;
  double gasContaminantOut; // kmol/h
  double airFeed = 100; // kmol/h;
  double airOut = 100; // kmol/h
  Map<String, double> fixedPoint; // (x, y)
  double gasFeed = 100; // kmol/h
  double purity; // (%)
  double percentOfContaminantIn = 15.0; // (%)
  double contaminantOut; // (%)
  double liquidFeed = 100; // (kmol/h)
  double liquidPerGas; // (undimensional)
  double liquidContaminantIn = 0.0; // (kmol/h)
  double liquidContaminantOut; // (kmol/h)
  double waterFeed = 100; // (kmol/h)
  double waterOut = 100; // (kmol/h)

  void setColumn(String column) {
    columnType = column;
  }

  void setInValues() {
    liquidPerGas = liquidFeed / airFeed;
    if (columnType == 'absorption') {
      gasContaminantIn = gasFeed * (percentOfContaminantIn / 100);
      airFeed = gasFeed - gasContaminantIn;
    } else {
      // stripping case
      liquidContaminantIn = liquidFeed * (percentOfContaminantIn / 100);
      waterFeed = liquidFeed - liquidContaminantIn;
    }
  }

  // void setOutValues(double prt) {
  //   purity = prt;
  //   contaminantOut = 1 - (purity / 100);
  //   airOut = airFeed;
  //   gasContaminantOut = (airOut / (purity / 100)) * (1 - purity / 100);
  //   liquidContaminantOut = gasContaminantIn - gasContaminantOut;
  // }

  void setOutValues(double cntOut) {
    contaminantOut = cntOut / 100;
    purity = 1 - contaminantOut;

    if (columnType == 'absorption') {
      airOut = airFeed;
      gasContaminantOut = (airOut * contaminantOut / purity);
      liquidContaminantOut = gasContaminantIn - gasContaminantOut;
    } else {
      // stripping case
      waterOut = waterFeed;
      liquidContaminantOut = (waterOut * contaminantOut / purity);
      gasContaminantOut = liquidContaminantIn - liquidContaminantOut;
    }
  }

  void setFixedPoint() {
    fixedPoint = {'X': 0.0, 'Y': (gasContaminantOut / airOut)};
    return;
  }
}
