// import 'dart:math' as math;
import 'package:scoped_model/scoped_model.dart';

/// Base de cálculo = 100 kmol/h,
/// Variáveis:
/// percentOfContaminant = entrada de contaminante (%);
/// purity = pureza (%);
/// gasIn = corrente gasoza (kmol/h);
class AbsorptionVariables extends Model {
  String columnType = 'Absorption';
  double gasContaminantIn; // kmol/h;
  double gasContaminantOut; // kmol/h
  double airFeed = 150; // kmol/h;
  double airOut = 100; // kmol/h
  Map<String, double> fixedPoint; // (x, y)
  double gasFeed = 150; // kmol/h
  double purity; // (%)
  double percentOfContaminantIn = 3.5; // (%)
  double contaminantOut; // (%)
  double liquidFeed = 100; // (kmol/h)
  double liquidPerGas = 100 / 150; // (undimensional)
  double liquidContaminantIn = 0.0; // (kmol/h)
  double liquidContaminantOut; // (kmol/h)
  double waterFeed = 100; // (kmol/h)
  double waterOut = 100; // (kmol/h)
  double henryCte = 0.57;

  void setColumn(String column) {
    columnType = column;
    henryCte = columnType == 'Absorption' ? 0.57 : 1.43;
    gasFeed = columnType == 'Absorption' ? 150 : 100;
    liquidFeed = columnType == 'Absorption' ? 100 : 150;
  }

  void setInValues() {
    if (columnType == 'Absorption') {
      gasContaminantIn = gasFeed * (percentOfContaminantIn / 100);
      airFeed = gasFeed - gasContaminantIn;
      waterFeed = liquidFeed;
    } else {
      // stripping case
      liquidContaminantIn = liquidFeed * (percentOfContaminantIn / 100);
      waterFeed = liquidFeed - liquidContaminantIn;
      airFeed = gasFeed;
    }
    liquidPerGas = waterFeed / airFeed;
  }

  void setOutValues(double cntOut) {
    contaminantOut = cntOut / 100;
    purity = 1 - contaminantOut;

    if (columnType == 'Absorption') {
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
