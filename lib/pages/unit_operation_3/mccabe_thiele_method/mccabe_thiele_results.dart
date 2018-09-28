import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:simulop_v1/pages/helper_classes/app_bar_menu_itens.dart';
import 'package:simulop_v1/pages/unit_operation_3/mccabe_thiele_method/simulation_data.dart';

final _headerTextStyle = TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);

final helpItems = [
  HelpItem("More info", "/default", ActionType.route),
  HelpItem("About", "/default", ActionType.route),
];

class McCabeThieleMethodResults extends StatelessWidget {
  final McCabeThieleSimulation simulation;

  McCabeThieleMethodResults({Key key, @required this.simulation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModel<McCabeThieleSimulationModel>(
      model: McCabeThieleSimulationModel(simulation),
      child: Theme(
        data: ThemeData(primarySwatch: Colors.blueGrey),
              child: Scaffold(
          appBar: _McCabeThieleResultsAppBar(),
          drawer: _McCabeThieleResultsDrawer(),
          body: _mainBody(),
        ),
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

class _McCabeThieleResultsDrawer extends StatelessWidget {
  final int _sliderDiv = 40;

  Widget _variables(BuildContext context) {
    final _feedFractionSlider =
        ScopedModelDescendant<McCabeThieleSimulationModel>(
      builder: (contex, _, model) => Slider(
            min: 0.20,
            max: 0.80,
            divisions: _sliderDiv,
            value: model.getfeedFraction,
            onChanged: model.onFeedFractionChanged,
          ),
    );

    final _feedConditionSlider =
        ScopedModelDescendant<McCabeThieleSimulationModel>(
      builder: (contex, _, model) => Slider(
            min: -2.0,
            max: 2.0,
            divisions: _sliderDiv,
            value: model.getfeedCondition,
            onChanged: model.onFeedFractionConditionChanged,
          ),
    );

    final _refluxRationSlider =
        ScopedModelDescendant<McCabeThieleSimulationModel>(
      builder: (contex, _, model) => Slider(
            min: 1.20,
            max: 10.0,
            divisions: _sliderDiv,
            value: model.getRefluxRatio,
            onChanged: model.onRefluxRationChanged,
          ),
    );

    final _targetXDSlider = ScopedModelDescendant<McCabeThieleSimulationModel>(
      builder: (contex, _, model) => Slider(
            min: 0.500,
            max: 0.999,
            divisions: _sliderDiv,
            value: model.getTargetXD,
            onChanged: model.onTargetXDChanged,
          ),
    );

    final _targetXBSlider = ScopedModelDescendant<McCabeThieleSimulationModel>(
      builder: (contex, _, model) => Slider(
            min: 0.001,
            max: 0.490,
            divisions: _sliderDiv,
            value: model.getTargetXB,
            onChanged: model.onTargetXBChanged,
          ),
    );

    final _pressureSlider = ScopedModelDescendant<McCabeThieleSimulationModel>(
      builder: (contex, _, model) => Slider(
            min: 1.0,
            max: 5.0,
            divisions: _sliderDiv,
            value: model.getPressure,
            onChanged: model.onPressureChanged,
          ),
    );

    return Column(
      children: <Widget>[
        ListTile(
          title: Text("LK Feed Fraction: "),
          subtitle: _feedFractionSlider,
          trailing: ScopedModelDescendant<McCabeThieleSimulationModel>(
            builder: (contex, _, model) =>
                Text((model.getfeedFraction).toStringAsFixed(2)),
          ),
        ),
        ListTile(
          title: Text("Feed Condition: "),
          subtitle: _feedConditionSlider,
          trailing: ScopedModelDescendant<McCabeThieleSimulationModel>(
            builder: (contex, _, model) =>
                Text((model.getfeedCondition).toStringAsFixed(1)),
          ),
        ),
        ListTile(
          title: Text("Relux Ratio: "),
          subtitle: _refluxRationSlider,
          trailing: ScopedModelDescendant<McCabeThieleSimulationModel>(
            builder: (contex, _, model) =>
                Text((model.getRefluxRatio).toStringAsFixed(1)),
          ),
        ),
        ListTile(
          title: Text("Target XD: "),
          subtitle: _targetXDSlider,
          trailing: ScopedModelDescendant<McCabeThieleSimulationModel>(
            builder: (contex, _, model) =>
                Text((model.getTargetXD).toStringAsFixed(3)),
          ),
        ),
        ListTile(
          title: Text("Target XB: "),
          subtitle: _targetXBSlider,
          trailing: ScopedModelDescendant<McCabeThieleSimulationModel>(
            builder: (contex, _, model) =>
                Text((model.getTargetXB).toStringAsFixed(3)),
          ),
        ),
        ListTile(
          title: Text("Pressure: (bar)"),
          subtitle: _pressureSlider,
          trailing: ScopedModelDescendant<McCabeThieleSimulationModel>(
            builder: (contex, _, model) =>
                Text((model.getPressure).toStringAsFixed(1)),
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
          _variables(context),
        ],
      ),
    );
  }
}

class _McCabeThieleResultsAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  @override
  Size get preferredSize => AppBar().preferredSize;

  @override
  __McCabeThieleResultsAppBarState createState() =>
      __McCabeThieleResultsAppBarState();
}

class __McCabeThieleResultsAppBarState
    extends State<_McCabeThieleResultsAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 2.0,
      title: Text("Results"),
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

  void _lunchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "Could not lunch $url";
    }
  }

  void _selectMenu(dynamic item) {
    switch (item.actionType) {
      case ActionType.route:
        Navigator.of(context).pushNamed(item.action);
        break;
      case ActionType.url:
        _lunchURL(item.action);
        break;
      case ActionType.widgetAction:
        break;
      default:
    }
  }
}

class _ChartCard extends StatelessWidget {
  List<charts.Series<math.Point, double>> _createSeries(
      List<math.Point> dataEquilibrium,
      List<math.Point> dataOperationCurves,
      List<math.Point> dataStages) {
    return [
      charts.Series<math.Point, double>(
        id: "Equilibrium",
        domainFn: (math.Point point, _) => point.x,
        measureFn: (math.Point point, _) => point.y,
        data: dataEquilibrium,
      ),
      charts.Series<math.Point, double>(
        id: "Operation Curves",
        colorFn: (_, __) => charts.MaterialPalette.gray.shade500,
        dashPatternFn: (_, __) => [3, 3],
        domainFn: (math.Point point, _) => point.x,
        measureFn: (math.Point point, _) => point.y,
        data: dataOperationCurves,
      ),
      charts.Series<math.Point, double>(
        id: "Stages",
        colorFn: (_, __) => charts.MaterialPalette.gray.shade800,
        domainFn: (math.Point point, _) => point.x,
        measureFn: (math.Point point, _) => point.y,
        data: dataStages,
      ),
    ];
  }

  Widget _chart(McCabeThieleSimulationModel model) {
    return charts.LineChart(
      _createSeries(
          model.getEquilibrium, model.getOperationCurves, model.getStages),
      animate: false,
      defaultInteractions: false,
      primaryMeasureAxis: charts.NumericAxisSpec(
        viewport: charts.NumericExtents(0.0, 1.0),
          tickProviderSpec:
              charts.BasicNumericTickProviderSpec(dataIsInWholeNumbers: false, desiredTickCount: 5)),
      domainAxis: charts.NumericAxisSpec(
        viewport: charts.NumericExtents(0.0, 1.0),
          tickProviderSpec:
              charts.BasicNumericTickProviderSpec(dataIsInWholeNumbers: false, desiredTickCount: 5)),
      behaviors: [
        charts.SeriesLegend(
          position: charts.BehaviorPosition.top,
          cellPadding: EdgeInsets.all(4.0),
        ),
      ],
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
              "Graph",
              style: _headerTextStyle,
            ),
          ),
          Container(
            height: 300.0,
            child: Padding(
              padding: EdgeInsets.only(left: 8.0, right: 8.0),
              child: ScopedModelDescendant<McCabeThieleSimulationModel>(
                builder: (context, _, model) => _chart(model),
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

class _ResultsCard extends StatelessWidget {
  final _textStyle = TextStyle(fontSize: 14.0, color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.done_all),
            title: Text(
              "Results",
              style: _headerTextStyle,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            child: ScopedModelDescendant<McCabeThieleSimulationModel>(
              builder: (context, _, model) => StreamBuilder<Results>(
                    stream: model.getResults,
                    initialData: Results(idialStage: "0", numberOfStages: "0"),
                    builder: (context, snapshot) => RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                  text: "Alpha value: ${model.getAlpha}\n",
                                  style: _textStyle),
                              TextSpan(
                                  text:
                                      "Number of theoretical stages: ${snapshot.data.numberOfStages}\n",
                                  style: _textStyle),
                              TextSpan(
                                  text:
                                      "Idial feed stage: ${snapshot.data.idialStage}\n",
                                  style: _textStyle),
                            ],
                          ),
                        ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
