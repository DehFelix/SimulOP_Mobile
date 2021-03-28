// ignore: unused_import
import 'dart:math' as math;
// ignore: unused_import
import 'package:simulop_v1/core/components/liquid/liquid.dart';
// ignore: unused_import
import 'package:simulop_v1/core/units/units.dart';
import 'package:simulop_v1/pages/unit_operation_3/absorption_column/algorithmHandler.dart';

class AbsorptionColumnMethod {
  // double contaminantIn; // kmol/h;
  double gasFeed; // kmol/h;
  double purity;
  // double airIn; // kmol/h;
  // double airOut; // kmol/h
  // Map<String, double> fixedPoint; // (x, y)
  // double contaminantOut; // kmol/h

  math.Point _pointP;
  math.Point get pointP => _pointP;

  AbsorptionColumnMethod(
    // double contaminantIn,
    Calculos absorptionColumnData,
    // double airIn,
    // double baseDeCalculo,
    // double airOut,
    // Map<String, double> fixedPoint,
    // double contaminantOut,
  ) {
    // this.contaminantIn = contaminantIn;
    // this.gasFeed = gasFeed;
    // this.airIn = airIn;
    // this.baseDeCalculo = baseDeCalculo;
    // this.airOut = airOut;
    // this.fixedPoint = fixedPoint;
    // this.contaminantOut = contaminantOut;

    _pointP = math.Point(0.0, 0.0);
    this.gasFeed = absorptionColumnData.gasFeed;
    this.purity = absorptionColumnData.purity;
    computPointP();
  }

  void computPointP() {
    double x;
    double y;

    x = 0.0;
    y = 0.0; // TODO -> (contaminantOut / airOut);

    _pointP = math.Point(x, y);
  }
}
