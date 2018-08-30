import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:math' as math;
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:simulop_v1/pages/helper_classes/app_bar_menu_itens.dart';
import 'package:simulop_v1/pages/unit_operation_1/pumping_of_fluids/simulation_data.dart';

final _headerTextStyle = TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);

final helpItems = [
  HelpItem("More info", "/default", ActionType.route),
  HelpItem("About", "/default", ActionType.route),
];

class PumpingOfFluidsResults extends StatelessWidget {
  final PumpingOfFluidsSimulation simulation;

  PumpingOfFluidsResults({Key key, @required this.simulation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModel<PumpingOfFluidsSimulationModel>(
      model: PumpingOfFluidsSimulationModel(simulation),
      child: Scaffold(
        appBar: _FluidResultsAppBar(),
        drawer: _FluidResultsDrawer(),
        body: _mainBody(),
      ),
    );
  }

  Widget _mainBody() {
    return ListView(
      children: <Widget>[
        _ChartCard(),
        _ResultsCard(),
      ],
    );
  }
}

/// Drawer with the variables
class _FluidResultsDrawer extends StatelessWidget {
  /// Sliders for the liquids variables
  Widget _liquidsVariables(BuildContext context) {
    final _flowSlider = ScopedModelDescendant<PumpingOfFluidsSimulationModel>(
      builder: (contex, _, model) => Slider(
            min: 0.0,
            max: 2.0,
            divisions: 20,
            value: model.getFlow,
            onChanged: model.onFlowChanged,
          ),
    );

    final _temperatureSlider =
        ScopedModelDescendant<PumpingOfFluidsSimulationModel>(
      builder: (contex, _, model) => Slider(
            min: 10.0,
            max: 90.0,
            divisions: 20,
            value: model.getTemperature,
            onChanged: model.onTemperatureChanged,
          ),
    );

    return Column(
      children: <Widget>[
        ListTile(
          title: Text(
            "Liquid: ",
            style: _headerTextStyle,
          ),
          leading: Icon(Icons.format_color_fill),
        ),
        ListTile(
          title: Text("Desired Flow: (m^3/s)"),
          subtitle: _flowSlider,
          trailing: ScopedModelDescendant<PumpingOfFluidsSimulationModel>(
            builder: (contex, _, model) => Text(
                  model.getFlow.toStringAsFixed(1),
                ),
          ),
        ),
        ListTile(
          title: Text("Liquid Temperature: (°C)"),
          subtitle: _temperatureSlider,
          trailing: ScopedModelDescendant<PumpingOfFluidsSimulationModel>(
            builder: (contex, _, model) => Text(
                  model.getTemperature.toStringAsFixed(1),
                ),
          ),
        )
      ],
    );
  }

  /// Sliders for the inlet variables
  Widget _inletVariables(BuildContext context) {
    final _inletValveSlider =
        ScopedModelDescendant<PumpingOfFluidsSimulationModel>(
      builder: (contex, _, model) => Slider(
            min: 1.0,
            max: 10.0,
            divisions: 20,
            value: model.getInletValve,
            onChanged: model.onInletValveChange,
          ),
    );

    final _inletPressureSlider =
        ScopedModelDescendant<PumpingOfFluidsSimulationModel>(
      builder: (contex, _, model) => Slider(
            min: 0.2,
            max: 5.0,
            divisions: 20,
            value: model.getInletTankPressure,
            onChanged: model.onInletTankPressureChanged,
          ),
    );

    return Column(
      children: <Widget>[
        ListTile(
          title: Text(
            "Inlet: ",
            style: _headerTextStyle,
          ),
          leading: Icon(Icons.arrow_forward),
        ),
        ListTile(
          title: Text("Inlet Valve Opening: "),
          subtitle: _inletValveSlider,
          trailing: ScopedModelDescendant<PumpingOfFluidsSimulationModel>(
            builder: (contex, _, model) => Text(
                  (model.getInletValve / 10.0).toStringAsFixed(1),
                ),
          ),
        ),
        ListTile(
          title: Text("Inlet Tank Pressure: (bar)"),
          subtitle: _inletPressureSlider,
          trailing: ScopedModelDescendant<PumpingOfFluidsSimulationModel>(
            builder: (contex, _, model) => Text(
                  model.getInletTankPressure.toStringAsFixed(1),
                ),
          ),
        ),
      ],
    );
  }

  /// Sliders for the outlet variables
  Widget _outletVariables(BuildContext context) {
    final _outletValveSlider =
        ScopedModelDescendant<PumpingOfFluidsSimulationModel>(
      builder: (contex, _, model) => Slider(
            min: 1.0,
            max: 10.0,
            divisions: 20,
            value: model.getOutletValve,
            onChanged: model.onOutletValveChange,
          ),
    );

    return Column(
      children: <Widget>[
        ListTile(
          title: Text(
            "Outlet: ",
            style: _headerTextStyle,
          ),
          leading: Icon(Icons.arrow_back),
        ),
        ListTile(
          title: Text("Outlet Valve Opening: "),
          subtitle: _outletValveSlider,
          trailing: ScopedModelDescendant<PumpingOfFluidsSimulationModel>(
            builder: (contex, _, model) =>
                Text((model.getOutletValve / 10.0).toStringAsFixed(1)),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Center(
                child: Text(
              "Variables: ",
              style: TextStyle(fontSize: 35.0, color: Colors.white),
              textAlign: TextAlign.center,
            )),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          _liquidsVariables(context),
          Divider(),
          _inletVariables(context),
          Divider(),
          _outletVariables(context),
        ],
      ),
    );
  }
}

/// AppBar for the Scaffold
class _FluidResultsAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  @override
  Size get preferredSize => AppBar().preferredSize;

  @override
  __FluidResultsAppBarState createState() => __FluidResultsAppBarState();
}

/// State for the AppBar
class __FluidResultsAppBarState extends State<_FluidResultsAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 2.0,
      title: Text("Pumping of fluids - Results"),
      actions: <Widget>[
        PopupMenuButton(
          itemBuilder: (BuildContext context) => _appBarMenu(),
          onSelected: _selectMenu,
        )
      ],
    );
  }

  List<Widget> _appBarMenu() {
    return helpItems.map((HelpItem item) {
      return PopupMenuItem(
        value: item,
        child: Text(item.name),
      );
    }).toList();
  }

  void _selectMenu(dynamic item) {
    Navigator.of(context).pushNamed(item.action);
  }
}

/// The chart card
class _ChartCard extends StatelessWidget {
  static const primaryMeasureAxisId = 'primaryMeasureAxisId';
  static const secondaryMeasureAxisId = 'secondaryMeasureAxisId';

  List<charts.Series<math.Point, double>> _createSeries(
      List<math.Point> dataHead, List<math.Point> dataNPSH) {
    return [
      charts.Series<math.Point, double>(
        id: "head",
        domainFn: (math.Point point, _) => point.x,
        measureFn: (math.Point point, _) => point.y,
        data: dataHead,
      )..setAttribute(charts.measureAxisIdKey, primaryMeasureAxisId),
      charts.Series<math.Point, double>(
        id: "npsh",
        domainFn: (math.Point point, _) => point.x,
        measureFn: (math.Point point, _) => point.y,
        data: dataNPSH,
      )..setAttribute(charts.measureAxisIdKey, secondaryMeasureAxisId),
    ];
  }

  Widget _chart(List<math.Point> dataHead, List<math.Point> dataNPSH) {
    return charts.LineChart(
      _createSeries(dataHead, dataNPSH),
      animate: false,
      primaryMeasureAxis: charts.NumericAxisSpec(
          tickProviderSpec:
              charts.BasicNumericTickProviderSpec(desiredTickCount: 5)),
      secondaryMeasureAxis: charts.NumericAxisSpec(
          tickProviderSpec:
              charts.BasicNumericTickProviderSpec(desiredTickCount: 5)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.insert_chart),
            title: Text(
              "Graphs: ",
              style: _headerTextStyle,
            ),
          ),
          Container(
            height: 300.0,
            child: Padding(
              padding: EdgeInsets.only(left: 8.0, right: 8.0),
              child: ScopedModelDescendant<PumpingOfFluidsSimulationModel>(
                builder: (context, _, model) => _chart(
                      model.getPointsHead,
                      model.getPointsNPSH,
                    ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
          ),
        ],
      ),
    );
  }
}

/// The results card
class _ResultsCard extends StatelessWidget {
  final _textStyle = TextStyle(fontSize: 14.0, color: Colors.black);

  TextSpan _bombResult(PumpingOfFluidsSimulationModel model) {
    String bombHead = "Necessary head: ${model.getHead} m \n";

    return TextSpan(
        children: <TextSpan>[TextSpan(text: bombHead, style: _textStyle)]);
  }

  TextSpan _npshResults(PumpingOfFluidsSimulationModel model) {
    String npshAvailable = "NPSH available: ${model.getNpsh} m \n";

    return TextSpan(
        children: <TextSpan>[TextSpan(text: npshAvailable, style: _textStyle)]);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.done_all),
            title: Text(
              "Results: ",
              style: _headerTextStyle,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            child: ScopedModelDescendant<PumpingOfFluidsSimulationModel>(
              builder: (context, _, model) => RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        _bombResult(model),
                        TextSpan(text: "\n"),
                        _npshResults(model),
                      ],
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
