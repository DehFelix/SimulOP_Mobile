import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:simulop_v1/pages/helper_classes/app_bar_menu_itens.dart';
import 'package:simulop_v1/pages/unit_operation_2/double_pipe_heatx/double_pipe_results.dart';
import 'package:simulop_v1/pages/unit_operation_2/double_pipe_heatx/input_handler.dart';

final _headerTextStyle = TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);

final helpItems = [
  HelpItem("Default inputs", "runWithDefaultInputs", ActionType.widgetAction),
  HelpItem("More info", "/default", ActionType.route),
  HelpItem("About", "/default", ActionType.route),
];

final outerFormKey = GlobalKey<FormState>();
final innerFormKey = GlobalKey<FormState>();
final heatXFormKey = GlobalKey<FormState>();

final InputModel inputModel = InputModel();

class DoublePiPeInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data:
          ThemeData(primarySwatch: Colors.teal, cursorColor: Colors.teal[500]),
      child: ScopedModel<InputModel>(
        model: inputModel,
        child: Scaffold(
          appBar: _DoublePipeInputAppBar(),
          body: Center(
            child: _mainBody(),
          ),
          floatingActionButton: ScopedModelDescendant<InputModel>(
            builder: (context, _, model) => FloatingActionButton(
                  child: Icon(model.getFabIcon()),
                  onPressed: () {
                    if (!model.canCreateSimulation()) {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        duration: Duration(seconds: 2),
                        content: Text(model.getErroMessage()),
                        action: SnackBarAction(
                          label: "Ok",
                          onPressed: () {},
                        ),
                      ));
                      return;
                    }
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DoublePiPeResults(
                                  simulation: model.createSimulation(),
                                )));
                  },
                ),
          ),
        ),
      ),
    );
  }

  Widget _mainBody() {
    return ListView(
      children: <Widget>[
        _picCard(),
        SizedBox(
            height: 370.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                SizedBox(width: 250.0, child: _OuterInputCard()),
                SizedBox(width: 250.0, child: _InnerInputCard()),
                SizedBox(width: 250.0, child: _HeatXInputCard()),
              ],
            )),
        _SumaryCard(),
      ],
    );
  }

  Widget _picCard() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.picture_in_picture),
            title: Text("Picture", style: _headerTextStyle),
          ),
          Image.asset("assets/images/double_pipe_heatx_placeholder.png"),
        ],
      ),
    );
  }
}

/// AppBar for the Scaffold
class _DoublePipeInputAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  @override
  Size get preferredSize => AppBar().preferredSize;
  @override
  __DoublePipeInputAppBarState createState() => __DoublePipeInputAppBarState();
}

/// State for the AppBar
class __DoublePipeInputAppBarState extends State<_DoublePipeInputAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 2.0,
      title: Text("Double Pipe HeatX"),
      actions: <Widget>[
        PopupMenuButton(
          itemBuilder: (BuildContext context) => _appBarMenu(),
          onSelected: _selectMenu,
        )
      ],
    );
  }

  List<PopupMenuItem> _appBarMenu() {
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
        if (item.action == "runWithDefaultInputs") {
          InputModel.of(context).setDefaultInputs();
          var simulation = InputModel.of(context).createSimulation();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DoublePiPeResults(
                        simulation: simulation,
                      )));
        }
        break;
      default:
        break;
    }
  }
}

class _OuterInputCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Form(
        key: outerFormKey,
        autovalidate: true,
        onChanged: () {
          if (outerFormKey.currentState.validate()) {
            outerFormKey.currentState.save();
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.trip_origin),
              title: Text(
                "Outer Pipe: ",
                style: _headerTextStyle,
              ),
            ),
            ScopedModelDescendant<InputModel>(
              builder: (context, _, model) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        DropdownButton(
                            hint: Text(
                              "Select Liquid",
                            ),
                            value: model.outerInput.liquid,
                            items: model.outerInput.fluidInputDropDownItems(),
                            onChanged: (dynamic value) =>
                                model.setOuterLiquidName(value)),
                        SizedBox(
                          width: 45.0,
                          child: Opacity(
                            opacity: (model.outerInput.isOil) ? 1.0 : 0.0,
                            child: TextFormField(
                              autocorrect: false,
                              enabled: model.outerInput.isOil,
                              keyboardType: TextInputType.number,
                              initialValue: model.outerInput.apiDegree,
                              decoration: InputDecoration(labelText: "°API"),
                              validator: model.outerInput.apiValidator,
                              onSaved: model.setOuterLiquidAPI,
                            ),
                          ),
                        ),
                      ]),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Column(children: <Widget>[
                ScopedModelDescendant<InputModel>(
                  builder: (context, _, model) => TextFormField(
                        autocorrect: false,
                        keyboardType: TextInputType.number,
                        initialValue: model.outerInput.tempIN,
                        decoration: InputDecoration(
                            labelText: "Entry Temperature (°C)"),
                        validator: model.outerInput.temperatureValidator,
                        onSaved: model.setOuterTempIN,
                      ),
                ),
                ScopedModelDescendant<InputModel>(
                  builder: (context, _, model) => TextFormField(
                        autocorrect: false,
                        autovalidate: true,
                        keyboardType: TextInputType.number,
                        initialValue: model.outerInput.tempExit,
                        decoration:
                            InputDecoration(labelText: "Exit Temperature (°C)"),
                        validator: model.outerInput.temperatureValidator,
                        onSaved: model.setOuterTempExit,
                      ),
                ),
                ScopedModelDescendant<InputModel>(
                  builder: (context, _, model) => TextFormField(
                        autocorrect: false,
                        autovalidate: true,
                        keyboardType: TextInputType.number,
                        initialValue: model.heatInput.outerDiametre,
                        decoration: InputDecoration(labelText: "Diametre (cm)"),
                        validator: model.outerInput.diametreValidator,
                        onSaved: model.setHeatOuterDiametre,
                      ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

class _InnerInputCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Form(
        key: innerFormKey,
        autovalidate: true,
        onChanged: () {
          if (innerFormKey.currentState.validate()) {
            innerFormKey.currentState.save();
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.adjust),
              title: Text(
                "Inner Pipe: ",
                style: _headerTextStyle,
              ),
            ),
            ScopedModelDescendant<InputModel>(
              builder: (context, _, model) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        DropdownButton(
                            hint: Text(
                              "Select Liquid",
                            ),
                            value: model.innerInput.liquid,
                            items: model.innerInput.fluidInputDropDownItems(),
                            onChanged: (dynamic value) =>
                                model.setInnerLiquidName(value)),
                        SizedBox(
                          width: 45.0,
                          child: Opacity(
                            opacity: (model.innerInput.isOil) ? 1.0 : 0.0,
                            child: TextFormField(
                              autocorrect: false,
                              enabled: model.innerInput.isOil,
                              keyboardType: TextInputType.number,
                              initialValue: model.innerInput.apiDegree,
                              decoration: InputDecoration(labelText: "°API"),
                              validator: model.innerInput.apiValidator,
                              onSaved: model.setInnerLiquidAPI,
                            ),
                          ),
                        ),
                      ]),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Column(children: <Widget>[
                ScopedModelDescendant<InputModel>(
                  builder: (context, _, model) => TextFormField(
                        autocorrect: false,
                        keyboardType: TextInputType.number,
                        initialValue: model.innerInput.tempIN,
                        decoration:
                            InputDecoration(labelText: "Temperature In (°C)"),
                        validator: model.innerInput.temperatureValidator,
                        onSaved: model.setInnerTempIN,
                      ),
                ),
                ScopedModelDescendant<InputModel>(
                  builder: (context, _, model) => TextFormField(
                        autocorrect: false,
                        autovalidate: true,
                        keyboardType: TextInputType.number,
                        initialValue: model.innerInput.tempExit,
                        decoration:
                            InputDecoration(labelText: "Temperature Exit (°C)"),
                        validator: model.innerInput.temperatureValidator,
                        onSaved: model.setInnerTempExit,
                      ),
                ),
                ScopedModelDescendant<InputModel>(
                  builder: (context, _, model) => TextFormField(
                        autocorrect: false,
                        autovalidate: true,
                        keyboardType: TextInputType.number,
                        initialValue: model.heatInput.innerDiametre,
                        decoration: InputDecoration(labelText: "Diametre (cm)"),
                        validator: model.innerInput.diametreValidator,
                        onSaved: model.setHeatInnerDiametre,
                      ),
                )
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeatXInputCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Form(
        key: heatXFormKey,
        autovalidate: true,
        onChanged: () {
          if (heatXFormKey.currentState.validate()) {
            heatXFormKey.currentState.save();
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.tune),
              title: Text(
                "Heat X: ",
                style: _headerTextStyle,
              ),
            ),
            ScopedModelDescendant<InputModel>(
              builder: (context, _, model) => Center(
                    child: DropdownButton(
                        hint: Text(
                          "Select Tube Material",
                        ),
                        value: model.heatInput.tubeMaterial,
                        items: model.heatInput.tubeMaterialDropDownItems(),
                        onChanged: (dynamic value) =>
                            model.setHeatTubeMaterial(value)),
                  ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Column(children: <Widget>[
                ScopedModelDescendant<InputModel>(
                  builder: (context, _, model) => TextFormField(
                        autocorrect: false,
                        keyboardType: TextInputType.number,
                        initialValue: model.heatInput.hotFlow,
                        decoration:
                            InputDecoration(labelText: "Hot Flow (m^3/h)"),
                        validator: model.heatInput.hotFlowValidator,
                        onSaved: model.setHeatHotFlow,
                      ),
                ),
                ScopedModelDescendant<InputModel>(
                  builder: (context, _, model) => TextFormField(
                        autocorrect: false,
                        autovalidate: true,
                        keyboardType: TextInputType.number,
                        initialValue: model.heatInput.foolingFactor,
                        decoration:
                            InputDecoration(labelText: "Fooling Factor (mm)"),
                        validator: model.heatInput.foolingFactorValidator,
                        onSaved: model.setHeatFoolingFactor,
                      ),
                ),
                ScopedModelDescendant<InputModel>(
                  builder: (context, _, model) => TextFormField(
                        autocorrect: false,
                        autovalidate: true,
                        keyboardType: TextInputType.number,
                        initialValue: model.heatInput.thickness,
                        decoration:
                            InputDecoration(labelText: "Thicknnes (cm)"),
                        validator: model.heatInput.thicknessValidator,
                        onSaved: model.setThickness,
                      ),
                )
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

class _SumaryCard extends StatelessWidget {
  final _titleStyle = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black);

  final _textStyle = TextStyle(fontSize: 14.0, color: Colors.black);

  TextSpan _outerSumary(Sumary sumary) {
    String liquid = sumary.outerLiquidName;
    String bulckTemp = sumary.outerBulkTemp;
    String density = sumary.outerLiquidDensity;
    String viscosity = sumary.outerLiquidViscosity;
    String specificyHeat = sumary.outerLiquidSpecificHeat;

    return TextSpan(
      children: <TextSpan>[
        TextSpan(text: liquid, style: _titleStyle),
        TextSpan(text: bulckTemp, style: _textStyle),
        TextSpan(text: density, style: _textStyle),
        TextSpan(text: viscosity, style: _textStyle),
        TextSpan(text: specificyHeat, style: _textStyle),
      ],
    );
  }

  TextSpan _innerSumary(Sumary sumary) {
    String liquid = sumary.innerLiquidName;
    String bulckTemp = sumary.innerBulkTemp;
    String density = sumary.innerLiquidDensity;
    String viscosity = sumary.innerLiquidViscosity;
    String specificyHeat = sumary.innerLiquidSpecificHeat;

    return TextSpan(
      children: <TextSpan>[
        TextSpan(text: liquid, style: _titleStyle),
        TextSpan(text: bulckTemp, style: _textStyle),
        TextSpan(text: density, style: _textStyle),
        TextSpan(text: viscosity, style: _textStyle),
        TextSpan(text: specificyHeat, style: _textStyle),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.playlist_add_check),
          title: Text(
            "Sumary",
            style: _titleStyle,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
          child: ScopedModelDescendant<InputModel>(
            builder: (context, _, model) {
              Sumary sumary = model.simulation.getSumary();
              return RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    _outerSumary(sumary),
                    TextSpan(text: "\n"),
                    _innerSumary(sumary),
                  ],
                ),
              );
            },
          ),
        )
      ],
    ));
  }
}
