import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:math' as math;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:url_launcher/url_launcher.dart';

import 'package:simulop_v1/pages/helper_classes/app_bar_menu_itens.dart';
import 'package:simulop_v1/pages/unit_operation_2/double_pipe_heatx/simulation_data.dart';

final _headerTextStyle = TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);

final helpItems = [
  HelpItem("More info", "/default", ActionType.route),
  HelpItem("About", "/default", ActionType.route),
];

class DoublePiPeResults extends StatelessWidget {
  final DoublePipeHeatXSimulation simulation;

  DoublePiPeResults({Key key, @required this.simulation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(primarySwatch: Colors.teal),
      child: ScopedModel<DoublePipeBloc>(
        model: DoublePipeBloc(simulation),
        child: Scaffold(
          appBar: _DoublePipeAppBar(),
          drawer: _DoublePipeDrawer(),
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

class _DoublePipeDrawer extends StatelessWidget {
  final int _sliderDiv = 40;

  /// Sliders for the outer tube
  Widget _outerTubeVariables(BuildContext context) {
    final _tempInSlider = ScopedModelDescendant<DoublePipeBloc>(
      builder: (context, _, model) => Slider(
            min: model.slidersMinMax.minOuterIn,
            max: model.slidersMinMax.maxOuterIn,
            divisions: _sliderDiv,
            value: model.outerTempIn,
            onChanged: model.setOuterTempIn,
          ),
    );

    final _tempExitSlider = ScopedModelDescendant<DoublePipeBloc>(
      builder: (context, _, model) => Slider(
            min: model.slidersMinMax.minOuterExit,
            max: model.slidersMinMax.maxOuterExit,
            divisions: _sliderDiv,
            value: model.outerTempExit,
            onChanged: model.setOuterTempExit,
          ),
    );

    final _diametreSlider = ScopedModelDescendant<DoublePipeBloc>(
      builder: (context, _, model) => Slider(
            min: 5.0,
            max: 30.0,
            divisions: _sliderDiv,
            value: model.outerDiametre,
            onChanged: model.setOuterDiametre,
          ),
    );

    return Column(
      children: <Widget>[
        ListTile(
          title: Text(
            "Outer Tube: ",
            style: _headerTextStyle,
          ),
          leading: Icon(Icons.trip_origin),
        ),
        ListTile(
          title: Text("Entry Temperature: (°C)"),
          subtitle: _tempInSlider,
          trailing: ScopedModelDescendant<DoublePipeBloc>(
            builder: (contex, _, model) => Text(
                  model.outerTempIn.toStringAsFixed(1),
                ),
          ),
        ),
        ScopedModelDescendant<DoublePipeBloc>(
          builder: (context, _, model) {
            if (model.showOuterTempExit()) {
              return ListTile(
                title: Text("Exit Temperature: (°C)"),
                subtitle: _tempExitSlider,
                trailing: Text(
                  model.outerTempExit.toStringAsFixed(1),
                ),
              );
            } else {
              return SizedBox();
            }
          },
        ),
        ListTile(
          title: Text("Diametre: (cm)"),
          subtitle: _diametreSlider,
          trailing: ScopedModelDescendant<DoublePipeBloc>(
            builder: (contex, _, model) => Text(
                  model.outerDiametre.toStringAsFixed(1),
                ),
          ),
        ),
      ],
    );
  }

  /// Sliders for the inner tube
  Widget _innerTubeVariables(BuildContext context) {
    final _tempInSlider = ScopedModelDescendant<DoublePipeBloc>(
      builder: (context, _, model) => Slider(
            min: model.slidersMinMax.minInnerIn,
            max: model.slidersMinMax.maxInnerIn,
            divisions: _sliderDiv,
            value: model.innerTempIn,
            onChanged: model.setInnerTempIn,
          ),
    );

    final _tempExitSlider = ScopedModelDescendant<DoublePipeBloc>(
      builder: (context, _, model) => Slider(
            min: model.slidersMinMax.minInnerExit,
            max: model.slidersMinMax.maxInnerExit,
            divisions: _sliderDiv,
            value: model.innerTempExit,
            onChanged: model.setInnerTempExit,
          ),
    );

    final _diametreSlider = ScopedModelDescendant<DoublePipeBloc>(
      builder: (context, _, model) => Slider(
            min: 2.0,
            max: 10.0,
            divisions: _sliderDiv,
            value: model.innerDiametre,
            onChanged: model.setInnerDiametre,
          ),
    );

    return Column(
      children: <Widget>[
        ListTile(
          title: Text(
            "Inner Tube: ",
            style: _headerTextStyle,
          ),
          leading: Icon(Icons.adjust),
        ),
        ListTile(
          title: Text("Entry Temperature: (°C)"),
          subtitle: _tempInSlider,
          trailing: ScopedModelDescendant<DoublePipeBloc>(
            builder: (contex, _, model) => Text(
                  model.innerTempIn.toStringAsFixed(1),
                ),
          ),
        ),
        ScopedModelDescendant<DoublePipeBloc>(
          builder: (context, _, model) {
            if (model.showInnerTempExit()) {
              return ListTile(
                title: Text("Exit Temperature: (°C)"),
                subtitle: _tempExitSlider,
                trailing: Text(
                  model.innerTempExit.toStringAsFixed(1),
                ),
              );
            } else {
              return SizedBox();
            }
          },
        ),
        ListTile(
          title: Text("Diametre: (cm)"),
          subtitle: _diametreSlider,
          trailing: ScopedModelDescendant<DoublePipeBloc>(
            builder: (contex, _, model) => Text(
                  model.innerDiametre.toStringAsFixed(1),
                ),
          ),
        ),
      ],
    );
  }

  /// Sliders for the heatX
  Widget _heatXVariables(BuildContext context) {
    final _hotFlowSlider = ScopedModelDescendant<DoublePipeBloc>(
      builder: (context, _, model) => Slider(
            min: 0.1,
            max: 20.0,
            divisions: _sliderDiv,
            value: model.hotFlow,
            onChanged: model.setHotFlow,
          ),
    );

    return Column(
      children: <Widget>[
        ListTile(
          title: Text(
            "HeatX: ",
            style: _headerTextStyle,
          ),
          leading: Icon(Icons.tune),
        ),
        ListTile(
          title: Text("Hot Flow: (m^3/h)"),
          subtitle: _hotFlowSlider,
          trailing: ScopedModelDescendant<DoublePipeBloc>(
            builder: (contex, _, model) => Text(
                  model.hotFlow.toStringAsFixed(1),
                ),
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
          _outerTubeVariables(context),
          Divider(),
          _innerTubeVariables(context),
          Divider(),
          _heatXVariables(context),
        ],
      ),
    );
  }
}

class _DoublePipeAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => AppBar().preferredSize;

  @override
  __DoublePipeAppBarState createState() => __DoublePipeAppBarState();
}

class __DoublePipeAppBarState extends State<_DoublePipeAppBar> {
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
  List<charts.Series<math.Point, double>> _createLenghtSeries(
      List<math.Point> data) {
    return [
      charts.Series(
        id: "Lenght",
        data: data,
        domainFn: (math.Point point, _) => point.x,
        measureFn: (math.Point point, _) => point.y,
      ),
    ];
  }

  List<charts.Series<math.Point, double>> _createPressureDropSeries(
      List<math.Point> outerData, List<math.Point> innerData) {
    return [
      charts.Series(
        id: "Outer Tube",
        data: outerData,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (math.Point point, _) => point.x,
        measureFn: (math.Point point, _) => point.y,
      ),
      charts.Series(
        id: "Inner Tube",
        data: innerData,
        colorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault,
        domainFn: (math.Point point, _) => point.x,
        measureFn: (math.Point point, _) => point.y,
      ),
    ];
  }

  Widget _chart(DoublePipeBloc model) {
    return StreamBuilder<Plot>(
      stream: model.getPlots,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Text("Loading...");
        var chartSeries = (snapshot.data.isChartPressure)
            ? _createPressureDropSeries(
                snapshot.data.outerPlot, snapshot.data.innerPlot)
            : _createLenghtSeries(snapshot.data.lenghtPlot);
        return charts.LineChart(
          chartSeries,
          animate: false,
          defaultInteractions: false,
          primaryMeasureAxis: charts.NumericAxisSpec(
              tickProviderSpec: charts.BasicNumericTickProviderSpec(
                  dataIsInWholeNumbers: false, desiredTickCount: 7)),
          domainAxis: charts.NumericAxisSpec(
              //viewport: charts.NumericExtents(28.0, 38.0),
              tickProviderSpec: charts.BasicNumericTickProviderSpec(
                  zeroBound: false,
                  dataIsInWholeNumbers: false,
                  desiredTickCount: 6)),
          behaviors: [
            charts.Slider(
              initialDomainValue: model.getSliderDomain,
              onChangeCallback: model.onSliderCanged,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          ScopedModelDescendant<DoublePipeBloc>(
            builder: (context, _, model) => ListTile(
                  leading: Icon(Icons.insert_chart),
                  title: Text(
                    model.getChartText(),
                    style: _headerTextStyle,
                  ),
                  trailing: Switch(
                    value: model.getChartView(),
                    onChanged: (val) {
                      model.toggleChartView(val);
                    },
                  ),
                  onTap: () {
                    model.toggleChartView(!model.getChartView());
                  },
                ),
          ),
          Container(
            height: 300.0,
            child: Padding(
              padding: EdgeInsets.only(left: 8.0, right: 8.0),
              child: ScopedModelDescendant<DoublePipeBloc>(
                  builder: (context, _, model) => _chart(model)),
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
  final _titleStyle = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black);

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
              style: _titleStyle,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            child: ScopedModelDescendant<DoublePipeBloc>(
              builder: (context, _, model) => StreamBuilder<Results>(
                    initialData: Results(),
                    stream: model.getResults,
                    builder: (context, snapshot) => RichText(
                          text: TextSpan(
                            style: _textStyle,
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                      "Hot Liquid Exit Temperature: ${snapshot.data.exitTemp} °C \n"),
                              TextSpan(
                                  text:
                                      "Inner Pipe Pressure Drop: ${snapshot.data.innerPressureDrop} KPa \n"),
                              TextSpan(
                                  text:
                                      "Outer Pipe Pressure Drop: ${snapshot.data.outerPressureDrop} KPa \n"),
                              TextSpan(
                                  text:
                                      "Global Coeff: ${snapshot.data.globalCoef} W/m^2 K \n"),
                              TextSpan(
                                  text:
                                      "HeatX lenght: ${snapshot.data.heatXLenght} m \n"),
                              TextSpan(
                                  text:
                                      "Cold Flow: ${snapshot.data.coldFlow} m^3/h \n"),
                              TextSpan(
                                  text:
                                      "Total Heat Exchanged: ${snapshot.data.heatExchanged} KW \n"),
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
