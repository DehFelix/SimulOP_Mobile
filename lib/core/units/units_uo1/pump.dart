import 'dart:math' as math;

import 'package:simulop_v1/core/components/liquid/liquid.dart';
import 'package:simulop_v1/core/units/units_uo1/units_1.dart';
import 'package:simulop_v1/core/units/units_uo1/tube.dart';

class Pump extends UnitsI {
  /// Volume flow of the liquid (m^3/s).
  double _volumeFlow;

  /// Work required by the pump (W).
  double _work;

  /// Coefficient of the pump head equation.
  ///
  /// (a3*Q^3 + a2*Q^2 + a1*Q^1 + a0).
  List<double> curveEquation;

  /// Head of the pump (m).
  double _head;

  /// [Liquid] that is beeing pumped.
  Liquid liquid;

  /// Outlet [Tube] attached to the pump.
  Tube outletTube;

  /// Eletric efficiency of the pump.
  double efficiency;

  /// Volume flow of the liquid (m^3/s).
  double get volumeFlow => _volumeFlow;

  /// Work required by the pump (W).
  double get work => _work;

  /// Head of the pump (m).
  double get head => _head;

  /// Creates a [Pump].
  ///
  /// [liquid] = liquid been pumped.
  ///
  /// [tube] = tube attached to the pump.
  ///
  /// [curveEquation] = coefficient of the pump head equation.
  ///
  /// [efficiency] = eletric efficiency of the pump.
  Pump(Liquid liquid, Tube tube,
      [List<double> curveEquation = const [], double efficiency = 1.0]) {
    this.liquid = liquid;
    this.outletTube = tube;
    this.curveEquation = curveEquation;
    this.efficiency = efficiency;
  }

  /// Pump head based on the volume flow.
  ///
  /// [volumeFlow] = volume flow of the liquid (m^3/s).
  double pumpHead(double volumeFlow) {
    double h = 0.0;

    for (int i = 3; i >= 0; i--) {
      h = h + curveEquation[3 - i] * math.pow(volumeFlow, i);
    }

    return h;
  }

  /// Bernoulli equation of the system pump + tube.
  ///
  /// [volumeFlow] = volume flow of the liquid (m^3/s).
  double bernoulli(double volumeFlow) {
    return pumpHead(volumeFlow) -
        outletTube.computePressureDrop(liquid.material, volumeFlow) -
        outletTube.elevationDiference;
  }

  /// Updates the volumeFlow of the system.
  void computeFlow() {
    double volumeFlow;

    volumeFlow = findRoot(bernoulli, 0.001, 10.0);

    _volumeFlow = volumeFlow;
    _head = pumpHead(volumeFlow);
    outletTube.computePressureDrop(liquid.material, volumeFlow);
  }

  /// Compure the work necessery head of the pump given a fixed volume flow.
  ///
  /// [volumeFlow] = volume flow of the liquid (m^3/s).
  double computeNecessaryHead(double volumeFlow) {
    double head;
    head = outletTube.computePressureDrop(liquid.material, volumeFlow) +
        outletTube.elevationDiference;

    _head = head;
    return head;
  }

  /// Compure the work necessery for the pump.
  ///
  /// [volumeFlow] = volume flow of the liquid (m^3/s).
  double computeWork(double volumeFlow) {
    double work;

    work = liquid.material.density * g * volumeFlow * _head / efficiency;

    _work = work;
    return work;
  }

  /// Return a list of a list of [math.Point], (0) = plot head (1) = plot tube
  ///
  /// [initalFlow] = initial volumetric flow to be plot (m^3/s).
  ///
  /// [finalFlow] = final volumetric flow to be plot (m^3/s).
  ///
  /// [div] = divisions (resolition) of the plot = 40.
  List<List<math.Point>> plotCurves(double initalFlow, double finalFlow,
      [int div = 40]) {
    List<math.Point> plotHead = List<math.Point>();
    List<math.Point> plotTube = List<math.Point>();

    double h;
    double hf;
    double flow;

    for (int i = 0; i < div; i++) {
      flow = initalFlow + i * (finalFlow - initalFlow) / div;

      h = pumpHead(flow);
      hf = computeNecessaryHead(flow);

      if (h > 0.0) {
        plotHead.add(math.Point(flow * 3600.0, h));
        plotTube.add(math.Point(flow * 3600.0, hf));
      } else {
        break;
      }
    }

    return [plotHead, plotTube];
  }

  /// Return a list of [math.Point] with the pois of the necessary head
  ///
  /// [initalFlow] = initial volumetric flow to be plot (m^3/s).
  ///
  /// [finalFlow] = final volumetric flow to be plot (m^3/s).
  ///
  /// [div] = divisions (resolition) of the plot = 40.
  List<math.Point> plotRequeredHead(double initalFlow, double finalFlow,
      [int div = 40]) {
    List<math.Point> plotHead = List<math.Point>();

    double hf;
    double flow;

    for (int i = 0; i < div; i++) {
      flow = initalFlow + i * (finalFlow - initalFlow) / div;

      hf = computeNecessaryHead(flow);

      plotHead.add(math.Point(flow * 3600.0, hf));
    }

    return plotHead;
  }
}

class CompletePump extends Pump {
  /// Inlet [Tube] attached to the pump.
  Tube inletTube;

  /// Inlet pressure of the liquid (Pa).
  double inletPressure;

  /// Required NPSH (m).
  double requiredNPSH;

  /// Creates a [CompletePump].
  ///
  /// [liquid] = liquid been pumped.
  ///
  /// [inletTube] = inlet tube attached to the pump.
  ///
  /// [outletTube] = outlet tube attached to the pump.
  ///
  /// [inletPressure] = inlet pressure of the liquid (Pa).
  ///
  /// [requiredNPSH] = required NPSH (m).
  ///
  /// [curveEquation] = coefficient of the pump head equation = null.
  ///
  /// [efficiency] = eletric efficiency of the pump = 1.0.
  CompletePump(
      Liquid liquid, Tube inletTube, Tube outletTube, double inletPressure,
      [double requiredNPSH = 0.0,
      List<double> curveEquation = const [],
      double efficiency = 1.0])
      : super(liquid, outletTube, curveEquation, efficiency) {
    this.inletTube = inletTube;
    this.inletPressure = inletPressure;
    this.requiredNPSH = requiredNPSH;
  }

  @override
  double bernoulli(double volumeFlow) {
    return pumpHead(volumeFlow) -
        outletTube.computePressureDrop(liquid.material, volumeFlow) -
        inletTube.computePressureDrop(liquid.material, volumeFlow) +
        outletTube.elevationDiference -
        inletTube.elevationDiference +
        liquid.convertPressureToM(inletPressure - 1e5);
  }

  @override
  void computeFlow() {
    double volumeFlow;

    volumeFlow = findRoot(bernoulli, 0.001, 10.0);

    _volumeFlow = volumeFlow;
    _head = pumpHead(volumeFlow);
    outletTube.computePressureDrop(liquid.material, this.volumeFlow);
    inletTube.computePressureDrop(liquid.material, this.volumeFlow);
  }

  @override
  double computeNecessaryHead(double volumeFlow) {
    double h1 = inletTube.computePressureDrop(liquid.material, volumeFlow) -
        inletTube.elevationDiference;

    double h2 = outletTube.computePressureDrop(liquid.material, volumeFlow) +
        outletTube.elevationDiference;

    double h3 = liquid.convertPressureToM(1e5 - inletPressure);

    _head = h1 + h2 + h3;
    // _head = inletTube.computePressureDrop(liquid.material, volumeFlow) -
    //     inletTube.elevationDiference +
    //     outletTube.computePressureDrop(liquid.material, volumeFlow) +
    //     outletTube.elevationDiference +
    //     liquid.convertPressureToM(1e5 - inletPressure);
    return _head;
  }

  /// Returns the availeble NSPH of the pump.
  ///
  /// [volumeFlow] = volume flow of the liquid (m^3/s).
  double availebleNPSH(double volumeFlow) {
    double pSuccao;
    double diferenciaAltura;
    double pVap;
    double perdaCarga;

    pSuccao = liquid.convertPressureToM(inletPressure);
    diferenciaAltura = inletTube.elevationDiference;
    pVap = liquid.vaporPressure / (liquid.material.density * g);
    perdaCarga = inletTube.computePressureDrop(liquid.material, volumeFlow);

    return pSuccao - pVap - perdaCarga + diferenciaAltura;
  }

  @override
  List<List<math.Point<double>>> plotCurves(double initalFlow, double finalFlow,
      [int div = 40]) {
    List<math.Point> plotHead = List<math.Point>();
    List<math.Point> plotTube = List<math.Point>();

    double h;
    double hf;
    double flow;

    for (int i = 0; i < div; i++) {
      flow = initalFlow + i * (finalFlow - initalFlow) / div;

      h = pumpHead(flow);
      hf = computeNecessaryHead(flow);

      if (h > 0.0) {
        plotHead.add(math.Point(flow * 3600.0, h));
        plotTube.add(math.Point(flow * 3600.0, hf));
      } else {
        break;
      }
    }

    return [plotHead, plotTube];
  }

  @override
  List<math.Point> plotRequeredHead(double initalFlow, double finalFlow,
      [int div = 40]) {
    List<math.Point> plotHead = List<math.Point>();

    double hf;
    double flow;

    for (int i = 0; i < div; i++) {
      flow = initalFlow + i * (finalFlow - initalFlow) / div;

      hf = computeNecessaryHead(flow);

      //print(hf);

      plotHead.add(math.Point(flow, hf));
    }

    return plotHead;
  }

  /// Return a list of [math.Point] with the plot of the availeble NPSH.
  ///
  /// [initalFlow] = initial volumetric flow to be plot (m^3/s).
  ///
  /// [finalFlow] = final volumetric flow to be plot (m^3/s).
  ///
  /// [div] = divisions (resolition) of the plot = 40.
  List<math.Point> plotNPSH(double initalFlow, double finalFlow,
      [int div = 40]) {
    List<math.Point> plotHead = List<math.Point>();

    double npsh;
    double flow;

    for (int i = 0; i < div; i++) {
      flow = initalFlow + i * (finalFlow - initalFlow) / div;

      npsh = availebleNPSH(flow);

      plotHead.add(math.Point(flow, npsh));
    }

    return plotHead;
  }
}
