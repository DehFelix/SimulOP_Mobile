// ignore: unused_import
import 'dart:math' as math;
// ignore: unused_import
import 'package:simulop_v1/core/components/liquid/liquid.dart';
// ignore: unused_import
import 'package:simulop_v1/core/units/units.dart';
import 'package:simulop_v1/pages/unit_operation_3/absorption_column/setupColumn.dart';

class AbsorptionColumnMethod {
  double gasFeed; // (kmol/h)
  double airFeed; // (kmol/h)
  double airOut; // (kmol/h)
  double liquidFeed; // (kmol/h)
  double liquidPerGas; // (adimensional)
  double purity; // (%)
  double percentOfContaminant; // (%)
  double contaminantOut; // (%)
  double gasContaminantIn; // (kmol/h)
  double gasContaminantOut; // (kmol/h)
  double liquidContaminantIn; // (kmol/h)
  double liquidContaminantOut; // (kmol/h)
  int stageNumbers;
  Map<String, double> fixedPoint; // (x, y)

  math.Point _fixedPoint;
  math.Point get pointP => _fixedPoint;

  AbsorptionColumnMethod(AbsorptionVariables absorptionColumnData) {
    gasFeed = absorptionColumnData.gasFeed;
    airFeed = absorptionColumnData.airFeed;
    airOut = absorptionColumnData.airOut;
    liquidFeed = absorptionColumnData.liquidFeed;
    liquidPerGas = absorptionColumnData.liquidPerGas;
    purity = absorptionColumnData.purity;
    percentOfContaminant = absorptionColumnData.percentOfContaminantIn;
    contaminantOut = absorptionColumnData.contaminantOut;
    gasContaminantIn = absorptionColumnData.gasContaminantIn;
    gasContaminantOut = absorptionColumnData.gasContaminantOut;

    computPointP();
    prints();
  }

  void computPointP() {
    double x;
    double y;

    x = 0.0;
    y = (gasContaminantOut / airOut);

    _fixedPoint = math.Point(x, y);
  }

  void updateFeedDependencies(who) {
    if (who == 'gasFeed' || who == 'contaminant') {
      gasContaminantIn = gasFeed * percentOfContaminant / 100;
      airFeed = gasFeed - gasContaminantIn;
      airOut = airFeed;
      liquidContaminantOut = gasContaminantIn - gasContaminantOut;
    }

    if (who == 'liquidFeed' || who == 'gasFeed') {
      liquidPerGas = liquidFeed / airFeed;
    }

    computPointP();
    prints();
  }

  void updatePurityDependencies() {
    gasContaminantOut = (airOut / (purity / 100)) * (1 - purity / 100);
    liquidContaminantOut = gasContaminantIn - gasContaminantOut;
    computPointP();
    prints();
  }

  // void updateContaminantDependencies() {
  //   gasContaminantOut =
  //       (airOut / (1 - (contaminantOut / 100))) * (contaminantOut / 100);
  //   liquidContaminantOut = gasContaminantIn - gasContaminantOut;
  //   computPointP();
  //   prints();
  // }

  void prints() {
    print('');
    print('');
    print('gasFeed: $gasFeed');
    print('airFeed: $airFeed');
    print('airOut: $airOut');
    print('liquidFeed: $liquidFeed');
    print('liquidPerGas: $liquidPerGas');
    print('purity: $purity');
    print('percentOfContaminant: $percentOfContaminant');
    print('contaminantOut: $contaminantOut');
    print('gasContaminantIn: $gasContaminantIn');
    print('gasContaminantOut: $gasContaminantOut');
    print('liquidContaminantIn: $liquidContaminantIn');
    print('liquidContaminantOut: $liquidContaminantOut');
    print('fixedPoint: $_fixedPoint');
  }
}
