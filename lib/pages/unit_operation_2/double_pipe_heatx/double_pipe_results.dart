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
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Center(
      child: Text("data"),
    ));
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
                  onTap: () {model.toggleChartView(!model.getChartView());},
                ),
          ),
          Container(
            height: 300.0,
            child: Padding(
              padding: EdgeInsets.only(left: 8.0, right: 8.0),
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
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(text: "Sumary1: \n", style: _textStyle),
                  TextSpan(text: "Sumary2: \n", style: _textStyle),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
