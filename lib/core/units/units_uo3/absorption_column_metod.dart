// ignore: unused_import
import 'dart:math' as math;
// ignore: unused_import
import 'package:simulop_v1/core/components/liquid/liquid.dart';
// ignore: unused_import
import 'package:simulop_v1/core/units/units.dart';
import 'package:simulop_v1/pages/unit_operation_3/absorption_column/setupColumn.dart';

class AbsorptionColumnMethod {
  String columnType;
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
  double waterFeed; // (kmol/h)
  double waterOut; // (kmol/h)
  int stageNumbers;
  Map<String, double> fixedPoint; // (x, y)
  double numberOfPoints = 40;
  math.Point plotPoints;

  math.Point _fixedPoint;
  math.Point get pointP => _fixedPoint;

  AbsorptionColumnMethod(AbsorptionVariables absorptionColumnData) {
    columnType = absorptionColumnData.columnType;
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
    liquidContaminantOut = absorptionColumnData.liquidContaminantOut;
    waterFeed = absorptionColumnData.waterFeed;
    waterOut = absorptionColumnData.waterOut;

    computPointP();
    prints();
  }

  void computPointP() {
    if (columnType == 'absorption') {
      double x0;
      double y1;

      x0 = 0.0;
      y1 = (gasContaminantOut / airOut);

      _fixedPoint = math.Point(x0, y1);
    } else {
      double x1;
      double y0;

      y0 = 0.0;
      x1 = (liquidContaminantOut / waterOut);

      _fixedPoint = math.Point(x1, y0);
    }
  }

  void updateFeedDependencies(fromWho) {
    if ((fromWho == 'gasFeed' || fromWho == 'contaminant') &&
        columnType == 'absorption') {
      gasContaminantIn = gasFeed * percentOfContaminant / 100;
      airFeed = gasFeed - gasContaminantIn;
      airOut = airFeed;
      gasContaminantOut = airOut * (contaminantOut) / (1 - contaminantOut);
      liquidContaminantOut = gasContaminantIn - gasContaminantOut;
    }

    if ((fromWho == 'liquidFeed' || fromWho == 'contaminant') &&
        columnType == 'stripping') {
      liquidContaminantIn = liquidFeed * percentOfContaminant / 100;
      waterFeed = liquidFeed - liquidContaminantIn;
      waterOut = waterFeed;
      liquidContaminantOut = waterOut * (contaminantOut) / (1 - contaminantOut);
      gasContaminantOut = liquidContaminantIn - liquidContaminantOut;
    }

    if (fromWho == 'liquidFeed' || fromWho == 'gasFeed') {
      liquidPerGas = liquidFeed / airFeed;
    }

    computPointP();
    prints();
  }

  void updatePurityDependencies() {
    purity = 1 - contaminantOut;
    if (columnType == 'absorption') {
      gasContaminantOut = (airOut / (purity)) * contaminantOut;
      liquidContaminantOut = gasContaminantIn - gasContaminantOut;
    } else {
      liquidContaminantOut = (waterOut / (purity)) * contaminantOut;
      gasContaminantOut = liquidContaminantIn - liquidContaminantOut;
    }

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
  //
  double yPoint(double xn) {
    double part1 = xn * liquidPerGas;
    double part2 = _fixedPoint.y;
    double part3 = _fixedPoint.x * liquidPerGas;
    return (part1 + part2 - part3);
  }

  List<math.Point> plotEquilibrium(double henry) {
    double x, y;
    List<math.Point> plot = List<math.Point>();

    for (double xi = 0.0; xi <= 1.01; xi = xi + (1.0 / numberOfPoints)) {
      x = xi;
      y = henry * xi;

      plot.add(math.Point(x, y));
    }

    return plot;
  }

  List<math.Point> opCurveConstructor() {
    double x, y;
    List<math.Point> plot = List<math.Point>();

    computPointP();

    for (double xn = 0.0; xn <= 1.01; xn = xn + (1.0 / numberOfPoints)) {
      if (xn < _fixedPoint.x && (xn + (1.0 / numberOfPoints)) < _fixedPoint.x) {
        x = _fixedPoint.x;
        y = _fixedPoint.y;
      } else {
        x = xn;
        y = yPoint(xn);
        if (y >= gasContaminantIn / airFeed) {
          print('esse é o ponto: $x, $y');
          plotPoints = math.Point(y + 0.1, y + 0.1);
          break;
        }
      }

      plot.add(math.Point(x, y));
    }

    return plot;
  }

  List<math.Point> plotOpCurve(
      List<math.Point> eqCurve, List<math.Point> opCurve) {
    List<math.Point> viewOpCurve = [];

    int index = -1;
    opCurve.forEach((math.Point point) {
      index = index + 1;
      if (columnType == 'absorption' && point.y >= eqCurve[index].y) {
        viewOpCurve.add(opCurve[index]);
      }

      if (columnType == 'stripping' && point.y <= eqCurve[index].y) {
        viewOpCurve.add(opCurve[index]);
      }
    });

    // final index = -1;
    // opCurve.where((math.Point number) => {

    //   if (eqCurve[index].y <= number.y) return true;
    //   return false;
    // });

    return viewOpCurve;
  }

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
