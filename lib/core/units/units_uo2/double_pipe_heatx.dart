import 'dart:math' as math;
import 'package:flutter/foundation.dart';

import 'package:simulop_v1/core/units/units_uo1/tube.dart';
import 'package:simulop_v1/core/components/liquid/liquid.dart';
import 'package:simulop_v1/core/interfaces/materials/i_liquid_material.dart';
import 'package:simulop_v1/core/units/units_uo2/units_2.dart';

class DoublePipeHeatX extends Units2 {
  // Outer pipe
  DoublePibeTube outerPipe;
  Liquid outerLiquidIn;
  ILiquidMaterial outerBulckMaterial;
  double outerBulckTemp;
  ExchangeFluid outer;
  double outerExitTemp;

  // Inner Pipe
  DoublePibeTube innerPipe;
  Liquid innerLiquidIn;
  ILiquidMaterial innerBulckMaterial;
  double innerBulckTemp;
  ExchangeFluid inner;
  double innerExitTemp;

  double hotFlow;
  double coldFlow;

  // Exit Liquids
  Liquid outerLiquidExit;
  Liquid innerLiquidExit;

  // Othe exchanger variables
  double _lenght;
  double foulingFactor;
  double exchangeArea;
  double globalHeatTransCoeff;
  double exchangeHeat;
  HeaterConfig config;

  double get lenght => _lenght;

  set lenght(double l) {
    _lenght = l;
    outerPipe.length = l;
    innerPipe.length = l;
  }

  DoublePipeHeatX(
      {@required this.outerPipe,
      @required this.outerLiquidIn,
      @required this.outerExitTemp,
      @required this.innerPipe,
      @required this.innerLiquidIn,
      @required this.innerExitTemp,
      @required this.hotFlow,
      this.foulingFactor = 0.0,
      this.config = HeaterConfig.counterCurrent}) {
    if (outerLiquidIn.temperature > innerLiquidIn.temperature) {
      outer = ExchangeFluid.hot;
      inner = ExchangeFluid.cold;
    } else {
      outer = ExchangeFluid.cold;
      inner = ExchangeFluid.hot;
    }

    innerBulckMaterial = innerLiquidIn.material.clone();
    outerBulckMaterial = outerLiquidIn.material.clone();
  }

  void computeExchange() {
    // 1. Defining the bulck temperature
    outerBulckTemp = (outerLiquidIn.temperature + outerExitTemp) / 2.0;
    innerBulckTemp = (innerLiquidIn.temperature + innerExitTemp) / 2.0;

    outerBulckMaterial.temperature = outerBulckTemp;
    innerBulckMaterial.temperature = innerBulckTemp;

    outerLiquidExit = Liquid(
        material: outerLiquidIn.material.clone(), temperature: outerExitTemp);
    innerLiquidExit = Liquid(
        material: innerLiquidIn.material.clone(), temperature: innerExitTemp);

    // 2. Heat Exchange
    _computeHeatExchange();

    if (outer == ExchangeFluid.hot) {
      coldFlow = exchangeHeat /
          (innerBulckMaterial.density *
              innerBulckMaterial.specificHeat *
              (innerExitTemp - innerLiquidIn.temperature));
    } else {
      coldFlow = exchangeHeat /
          (outerBulckMaterial.density *
              outerBulckMaterial.specificHeat *
              (outerExitTemp - outerLiquidIn.temperature));
    }

    // 3. Global heat coeff
    _computeGloblaCoeff();

    // 4. Necessary area
    _computeExancheArea();

    // 5. Updates the heatX lenght
    lenght = exchangeArea / (math.pi * innerPipe.internalDiametre);

    // 6. Pressure drop
    double outerFlow = (outer == ExchangeFluid.hot) ? hotFlow : coldFlow;
    double innerFlow = (inner == ExchangeFluid.hot) ? hotFlow : coldFlow;

    _computepressureDrop(outerPipe, outerFlow);
    _computepressureDrop(innerPipe, innerFlow);
  }

  double _computeHeatExchange() {
    double heat;

    if (outer == ExchangeFluid.hot) {
      heat = hotFlow *
          outerBulckMaterial.density *
          outerBulckMaterial.specificHeat *
          (outerLiquidIn.temperature - outerExitTemp);
    } else {
      heat = hotFlow *
          innerBulckMaterial.density *
          innerBulckMaterial.specificHeat *
          (innerLiquidIn.temperature - innerExitTemp);
    }

    exchangeHeat = heat;

    return heat;
  }

  double _computeGloblaCoeff() {
    double outerFlow = (outer == ExchangeFluid.hot) ? hotFlow : coldFlow;
    double innerFlow = (inner == ExchangeFluid.hot) ? hotFlow : coldFlow;

    double outerH =
        _computeConvectionCoeff(outerPipe, outerBulckMaterial, outerFlow);
    double innerH =
        _computeConvectionCoeff(innerPipe, innerBulckMaterial, innerFlow);

    double hTotal = 0.0;
    double invH;

    invH = (1.0 / innerH) + (1.0 / outerH) + foulingFactor;
    hTotal = 1.0 / invH;

    globalHeatTransCoeff = hTotal;

    return hTotal;
  }

  double _computeConvectionCoeff(
      DoublePibeTube tube, ILiquidMaterial bulckMaterial, double flow) {
    double re; // reynolds number
    double pr; // prandtl number
    double nu; // nusselt number
    double h; // Convection coefficiant

    re = tube.reynolds(bulckMaterial, flow);
    pr = bulckMaterial.pr;

    if (tube.tubeType == PipeType.inner) {
      if (re < 2300.0) // regime laminar
      {
        nu = 1.86 * math.pow(re * pr * (tube.internalDiametre / lenght), 0.33);
      } else if (re >= 2300.0 && re < 1e4) // regime intermediario
      {
        nu = 0.023 *
            math.pow(re, 0.8) *
            math.pow(pr, 0.4) *
            (1 - (6e5 / math.pow(re, 1.8)));
      } else // regime turbulendo
      {
        nu = 0.023 * math.pow(re, 0.8) * math.pow(pr, 0.4);
      }
    } else {
      if (re < 2300.0) // regime laminar
      {
        nu = 4.05 * math.pow(re, 0.17) * math.pow(pr, 0.33);
      } else if (re >= 2300.0 && re < 1e4) // regime intermediario
      {
        nu = 1.86 *
            math.pow(re * pr * (tube.internalDiametre / lenght), 0.33) *
            (1 - (6e5 / math.pow(re, 1.8)));
      } else // regime turbulendo
      {
        nu = 0.023 * math.pow(re, 0.8) * math.pow(pr, 0.4);
      }
    }

    h = (nu * bulckMaterial.thermalConductivity) / tube.internalDiametre;

    return h;
  }

  double _computeExancheArea() {
    double area = exchangeHeat / (globalHeatTransCoeff * _lmtd());

    exchangeArea = area;

    return area;
  }

  double _lmtd() {
    double dT1 = 0.0;
    double dT2 = 0.0;
    double lmtd;

    if (outer == ExchangeFluid.hot) {
      dT2 = outerLiquidIn.temperature - innerLiquidExit.temperature;
      dT1 = outerLiquidExit.temperature - innerLiquidIn.temperature;
    } else {
      dT2 = innerLiquidIn.temperature - outerLiquidExit.temperature;
      dT1 = innerLiquidExit.temperature - outerLiquidIn.temperature;
    }

    lmtd = (dT2 - dT1) / math.log(dT2 / dT1);

    if (lmtd.isNaN) {
      if (outer == ExchangeFluid.hot) {
        lmtd = ((outerLiquidIn.temperature + outerLiquidExit.temperature) -
                (innerLiquidIn.temperature + innerLiquidExit.temperature)) /
            2.0;
      } else {
        lmtd = ((innerLiquidIn.temperature + innerLiquidExit.temperature) -
                (outerLiquidIn.temperature + outerLiquidExit.temperature)) /
            2.0;
      }
    }

    return lmtd;
  }

  double _exitTemperature(ILiquidMaterial bulckMaterial,
      ExchangeFluid exchangeFluid, double flow, double inTemp) {
    double exitTemp;

    if (exchangeFluid == ExchangeFluid.hot) {
      exitTemp = inTemp -
          (exchangeHeat /
              (flow * bulckMaterial.density * bulckMaterial.specificHeat));
    } else {
      exitTemp = inTemp +
          (exchangeHeat /
              (flow * bulckMaterial.density * bulckMaterial.specificHeat));
    }

    return exitTemp;
  }

  double _computepressureDrop(DoublePibeTube tube, double flow) {
    double drop;

    if (tube.tubeType == PipeType.inner) {
      drop = tube.computePressureDrop(innerBulckMaterial, flow);
    } else {
      drop = tube.computePressureDrop(outerBulckMaterial, flow);
    }

    return drop;
  }

  void changeLiquidPossitions() {}

  List<List<math.Point>> plotresults(
      double minExitTemp, double maxTempExit, int div) {
    List<List<math.Point>> plot = List<List<math.Point>>();
    List<math.Point> plotOuterPressureDrop = List<math.Point>();
    List<math.Point> plotInnerPressureDrop = List<math.Point>();
    List<math.Point> plotLenght = List<math.Point>();

    double exitTemp;
    double tempInC;
    double outerPressureDrop;
    double innerPressureDrop;
    double lengh;

    for (int i = 0; i <= div; i++) {
      exitTemp = 273.15 + minExitTemp + i * (maxTempExit - minExitTemp) / div;

      if (outer == ExchangeFluid.hot) {
        outerExitTemp = exitTemp;
      } else {
        innerExitTemp = exitTemp;
      }

      computeExchange();

      if (_lmtd() > 2.0) {
        outerPressureDrop = outerPipe.pressureDrop;
        innerPressureDrop = innerPipe.pressureDrop;
        lengh = this.lenght;
        tempInC = exitTemp - 273.15;

        plotOuterPressureDrop
            .add(math.Point(tempInC, outerPressureDrop * 1e-3));
        plotInnerPressureDrop
            .add(math.Point(tempInC, innerPressureDrop * 1e-3));
        plotLenght.add(math.Point(tempInC, lengh));
      }
    }

    plot.add(plotOuterPressureDrop);
    plot.add(plotInnerPressureDrop);
    plot.add(plotLenght);

    return plot;
  }
}
