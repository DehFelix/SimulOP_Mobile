import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:simulop_v1/locale/locales.dart';

import 'package:simulop_v1/bloc/base_provider.dart';
import 'package:simulop_v1/bloc/mcCabeResultsBloc.dart';
import 'package:simulop_v1/pages/helper_classes/animated_toast.dart';
import 'package:simulop_v1/pages/helper_classes/app_bar_menu_itens.dart';

final _headerTextStyle = TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);

List<HelpItem> helpItems = List<HelpItem>();

class McCabeThieleMethodResultsAnimated extends StatelessWidget {
  final McCabeThieleSimulation simulation;

  McCabeThieleMethodResultsAnimated({Key key, @required this.simulation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    helpItems = [
      HelpItem(AppLocalizations.of(context).moreInfoBtn, "/default",
          ActionType.route),
    ];
    return BlocProvider<McCabeResultsBloc>(
      builder: (_, bloc) =>
          bloc ??
          McCabeResultsBloc(
            simulation: simulation,
          ),
      onDispose: (_, bloc) => bloc.dispose(),
      child: Theme(
        data:
            //Theme.of(context).copyWith(primaryColor: Colors.blueGrey),
            ThemeData(primarySwatch: Colors.blueGrey),
        child: Scaffold(
          appBar: _McCabeThieleResultsAppBar(),
          drawer: _McCabeThieleResultsDrawer(),
          body: _mainBody(),
          floatingActionButton: _FloatingButton(),
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

class _FloatingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<McCabeResultsBloc>(context);

    final List<SpeedDialChild> fabChildern = [
      SpeedDialChild(
        label: AppLocalizations.of(context).drawerReflxRatio.split(":")[0],
        child: Center(child: Text("Rr")),
        onTap: () {
          AnimetedToast.createToast(
            context,
            title: AppLocalizations.of(context).drawerReflxRatio,
            description: "Value:",
            variableRange: Tween<double>(begin: 1.2, end: 10),
            color: Theme.of(context).primaryColor,
            duration: ToastDuration.medium,
            pos: ToastPos.bottom,
            updateVariable: (val) => bloc.inputSink
                .add(InputVar(variable: Variable.refluxRatio, value: val)),
            initialValue: bloc.simpleValue[Variable.refluxRatio],
          );
        },
      ),
      SpeedDialChild(
        label: AppLocalizations.of(context).drawerLKFeed.split(":")[0],
        child: Center(child: Text("Fz")),
        onTap: () {
          AnimetedToast.createToast(
            context,
            title: AppLocalizations.of(context).drawerLKFeed,
            description: "Value:",
            variableRange: Tween<double>(begin: 0.3, end: 0.7),
            color: Theme.of(context).primaryColor,
            duration: ToastDuration.medium,
            updateVariable: (val) => bloc.inputSink
                .add(InputVar(variable: Variable.feedFraction, value: val)),
            initialValue: bloc.simpleValue[Variable.feedFraction],
          );
        },
      ),
      SpeedDialChild(
        label: AppLocalizations.of(context).drawerFeedCond.split(":")[0],
        child: Center(child: Text("Fc")),
        onTap: () {
          AnimetedToast.createToast(
            context,
            title: AppLocalizations.of(context).drawerFeedCond,
            description: "Value:",
            variableRange: Tween<double>(begin: -0.5, end: 1.5),
            color: Theme.of(context).primaryColor,
            duration: ToastDuration.long,
            updateVariable: (val) => bloc.inputSink
                .add(InputVar(variable: Variable.feedCondition, value: val)),
            initialValue: bloc.simpleValue[Variable.feedCondition],
          );
        },
      ),
    ];

    return SpeedDial(
      overlayColor: Colors.black,
      overlayOpacity: 0.2,
      animatedIcon: AnimatedIcons.menu_close,
      children: fabChildern,
    );
  }
}

class _McCabeThieleResultsDrawer extends StatelessWidget {
  final int _sliderDiv = 40;

  Widget _variables(BuildContext context, Map<Variable, double> currentValue) {
    final bloc = Provider.of<McCabeResultsBloc>(context);

    final _feedFractionSlider = Slider(
      min: 0.20,
      max: 0.80,
      divisions: _sliderDiv,
      value: currentValue[Variable.feedFraction],
      onChanged: (val) => bloc.inputSink
          .add(InputVar(variable: Variable.feedFraction, value: val)),
    );

    final _feedConditionSlider = Slider(
      min: -2.0,
      max: 2.0,
      divisions: _sliderDiv,
      value: currentValue[Variable.feedCondition],
      onChanged: (val) => bloc.inputSink
          .add(InputVar(variable: Variable.feedCondition, value: val)),
    );

    final _refluxRationSlider = Slider(
      min: 1.20,
      max: 10.0,
      divisions: _sliderDiv,
      value: currentValue[Variable.refluxRatio],
      onChanged: (val) => bloc.inputSink
          .add(InputVar(variable: Variable.refluxRatio, value: val)),
    );

    final _targetXDSlider = Slider(
      min: 0.500,
      max: 0.999,
      divisions: _sliderDiv,
      value: currentValue[Variable.targetXD],
      onChanged: (val) =>
          bloc.inputSink.add(InputVar(variable: Variable.targetXD, value: val)),
    );

    final _targetXBSlider = Slider(
      min: 0.001,
      max: 0.490,
      divisions: _sliderDiv,
      value: currentValue[Variable.targetXB],
      onChanged: (val) =>
          bloc.inputSink.add(InputVar(variable: Variable.targetXB, value: val)),
    );

    final _pressureSlider = Slider(
      min: 1.0,
      max: 5.0,
      divisions: _sliderDiv,
      value: currentValue[Variable.pressure],
      onChanged: (val) =>
          bloc.inputSink.add(InputVar(variable: Variable.pressure, value: val)),
    );

    return Column(
      children: <Widget>[
        ListTile(
          title: Text(AppLocalizations.of(context).drawerLKFeed),
          subtitle: _feedFractionSlider,
          trailing:
              Text(currentValue[Variable.feedFraction].toStringAsFixed(2)),
        ),
        ListTile(
          title: Text(AppLocalizations.of(context).drawerFeedCond),
          subtitle: _feedConditionSlider,
          trailing:
              Text(currentValue[Variable.feedCondition].toStringAsFixed(1)),
        ),
        ListTile(
          title: Text(AppLocalizations.of(context).drawerReflxRatio),
          subtitle: _refluxRationSlider,
          trailing: Text(currentValue[Variable.refluxRatio].toStringAsFixed(1)),
        ),
        ListTile(
          title: Text(AppLocalizations.of(context).drawerTargetXD),
          subtitle: _targetXDSlider,
          trailing: Text(currentValue[Variable.targetXD].toStringAsFixed(3)),
        ),
        ListTile(
          title: Text(AppLocalizations.of(context).drawerTargetXB),
          subtitle: _targetXBSlider,
          trailing: Text(currentValue[Variable.targetXB].toStringAsFixed(3)),
        ),
        ListTile(
          title: Text(AppLocalizations.of(context).hintPressure),
          subtitle: _pressureSlider,
          trailing: Text(currentValue[Variable.pressure].toStringAsFixed(1)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<McCabeResultsBloc>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Center(
                child: Text(
              AppLocalizations.of(context).drawerVariables,
              style: TextStyle(fontSize: 35.0, color: Colors.white),
              textAlign: TextAlign.center,
            )),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          StreamBuilder<Map<Variable, double>>(
              stream: bloc.currentValue,
              builder: (context, snapshot) {
                return (snapshot.hasError || !snapshot.hasData)
                    ? CircularProgressIndicator()
                    : _variables(context, snapshot.data);
              }),
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
      title: Text(AppLocalizations.of(context).results),
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
      List<math.Point> dataStages,
      List<math.Point> qLine,
      BuildContext context) {
    List<math.Point> linha = [math.Point(0.0, 0.0), math.Point(1.0, 1.0)];
    return [
      charts.Series<math.Point, double>(
        id: "45° Line",
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        dashPatternFn: (_, __) => [10, 10],
        domainFn: (math.Point point, _) => point.x,
        measureFn: (math.Point point, _) => point.y,
        data: linha,
      ),
      charts.Series<math.Point, double>(
        id: AppLocalizations.of(context).graphEquilibrium,
        domainFn: (math.Point point, _) => point.x,
        measureFn: (math.Point point, _) => point.y,
        data: dataEquilibrium,
      ),
      charts.Series<math.Point, double>(
        id: AppLocalizations.of(context).graphOperationCurves,
        colorFn: (_, __) => charts.MaterialPalette.gray.shade500,
        dashPatternFn: (_, __) => [3, 3],
        domainFn: (math.Point point, _) => point.x,
        measureFn: (math.Point point, _) => point.y,
        data: dataOperationCurves,
      ),
      charts.Series<math.Point, double>(
        id: AppLocalizations.of(context).graphStages,
        colorFn: (_, __) => charts.MaterialPalette.gray.shade800,
        domainFn: (math.Point point, _) => point.x,
        measureFn: (math.Point point, _) => point.y,
        data: dataStages,
      ),
      charts.Series<math.Point, double>(
        id: AppLocalizations.of(context).graphStages,
        colorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault,
        domainFn: (math.Point point, _) => point.x,
        measureFn: (math.Point point, _) => point.y,
        data: qLine,
      ),
    ];
  }

  Widget _chart(PlotPoints plotPoints, BuildContext context) {
    return charts.LineChart(
      _createSeries(plotPoints.equilibrium, plotPoints.operationCurve,
          plotPoints.stages, plotPoints.qline, context),
      animate: false,
      defaultInteractions: false,
      primaryMeasureAxis: charts.NumericAxisSpec(
        viewport: charts.NumericExtents(0.0, 1.0),
        tickProviderSpec: charts.BasicNumericTickProviderSpec(
            dataIsInWholeNumbers: false, desiredTickCount: 5),
      ),
      domainAxis: charts.NumericAxisSpec(
        viewport: charts.NumericExtents(0.0, 1.0),
        tickProviderSpec: charts.BasicNumericTickProviderSpec(
            dataIsInWholeNumbers: false, desiredTickCount: 5),
      ),
      // behaviors: [
      //   charts.SeriesLegend(
      //     position: charts.BehaviorPosition.top,
      //     cellPadding: EdgeInsets.all(4.0),
      //   ),
      // ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<McCabeResultsBloc>(context);

    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.insert_chart),
            title: Text(
              AppLocalizations.of(context).graph,
              style: _headerTextStyle,
            ),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        AppLocalizations.of(context).mcCabThieleFunctionAxis,
                        style: TextStyle(color: Colors.black87),
                      )),
                ),
              ),
              Expanded(
                child: Container(
                  height: 300.0,
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0, right: 8.0),
                    child: StreamBuilder<PlotPoints>(
                        stream: bloc.plotPoints,
                        builder: (context, snapshot) {
                          return (snapshot.hasError || !snapshot.hasData)
                              ? CircularProgressIndicator()
                              : _chart(snapshot.data, context);
                        }),
                  ),
                ),
              ),
            ],
          ),
          Text(
            AppLocalizations.of(context).mcCabThieleDomainAxis,
            style: TextStyle(color: Colors.black87),
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
    final bloc = Provider.of<McCabeResultsBloc>(context);

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.done_all),
            title: Text(
              AppLocalizations.of(context).results,
              style: _headerTextStyle,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            child: StreamBuilder<Results>(
              stream: bloc.results,
              initialData:
                  Results(idialStage: "0", numberOfStages: "0", alpha: "0"),
              builder: (context, snapshot) => RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text:
                                "${AppLocalizations.of(context).alphaValue} ${snapshot.data.alpha}\n",
                            style: _textStyle),
                        TextSpan(
                            text:
                                "${AppLocalizations.of(context).resultsNumberOfStages} ${snapshot.data.numberOfStages}\n",
                            style: _textStyle),
                        TextSpan(
                            text:
                                "${AppLocalizations.of(context).resultsIdialFeed} ${snapshot.data.idialStage}\n",
                            style: _textStyle),
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
