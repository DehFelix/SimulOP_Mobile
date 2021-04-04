import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:simulop_v1/locale/locales.dart';
import 'package:simulop_v1/pages/unit_operation_3/absorption_column/absorption_column_results_animated.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:simulop_v1/pages/helper_classes/app_bar_menu_itens.dart';
import 'package:simulop_v1/pages/unit_operation_3/absorption_column/input_data_new.dart';

final _headerTextStyle = TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);

List<HelpItem> helpItems = List<HelpItem>();

final mixtureFormKey = GlobalKey<FormState>();
final purityFormKey = GlobalKey<FormState>();
final contaminantFormKey = GlobalKey<FormState>();
final fluidInputsFormKey = GlobalKey<FormState>();

final mixtureInputModel = MixtureInput();
final columnInputModel = ColumnInput();

class McCabeThieleMethodInput2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    helpItems = [
      HelpItem(AppLocalizations.of(context).moreInfoBtn, "/default",
          ActionType.route),
    ];

    return ScopedModel<AbsorptionColumnInputData>(
      model: AbsorptionColumnInputData(
          input: mixtureInputModel, columnInput: columnInputModel),
      child: Theme(
        data: ThemeData(primarySwatch: Colors.blueGrey),
        child: Scaffold(
            appBar: _McCabeThieleInputAppBar(),
            body: Container(child: _mainBody()),
            floatingActionButton:
                ScopedModelDescendant<AbsorptionColumnInputData>(
              builder: (context, _, model) => FloatingActionButton(
                child: Icon(model.getFabIcon),
                onPressed: () {
                  if (!model.canCreateSimulation()) {
                    String erro =
                        (model.getAlpha < 1.0 && model.getAlpha != 0.0)
                            ? "HK more volatile than LK"
                            : "Incomplete inputs";
                    Scaffold.of(context).showSnackBar(SnackBar(
                      duration: Duration(seconds: 2),
                      content: Text(erro),
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
                      builder: (context) => AbsorptionColumnResultsAnimated(
                        simulation: model.createSimulation(),
                      ),
                    ),
                  );
                },
              ),
            )),
      ),
    );
  }

  /// The main body of the input forms.
  Widget _mainBody() {
    return ListView(
      children: <Widget>[
        Container(
          child: SizedBox(width: 250.0, child: _ColumnTypeRadio()),
        ),
        Container(child: SizedBox(width: 250.0, child: _ColumnInputCard())),
        Container(child: SizedBox(width: 250.0, child: _ColumnInputCard2())),
        Container(child: SizedBox(width: 250.0, child: _ColumnInputCard3())),
        _SumaryCard()
      ],
    );
  }
}

/// AppBar for the Scaffold
class _McCabeThieleInputAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  @override
  Size get preferredSize => AppBar().preferredSize;

  @override
  _McCabeThieleInputAppBarState createState() =>
      _McCabeThieleInputAppBarState();
}

/// State for the AppBar
class _McCabeThieleInputAppBarState extends State<_McCabeThieleInputAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 2.0,
      title: Text(AppLocalizations.of(context).absorptionColumnName),
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
        break;
      default:
    }
  }
}

class _ColumnInputCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Form(
        key: purityFormKey,
        autovalidate: true,
        onChanged: () {
          if (purityFormKey.currentState.validate()) {
            purityFormKey.currentState.save();
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
                leading: Icon(Icons.invert_colors_on),
                title: Text(AppLocalizations.of(context).desiredPurity,
                    style: _headerTextStyle)),
            SizedBox(
                width: 166,
                child: Padding(
                    padding:
                        EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                    child: Column(children: <Widget>[
                      ScopedModelDescendant<AbsorptionColumnInputData>(
                        builder: (context, _, model) => TextFormField(
                          autocorrect: false,
                          keyboardType: TextInputType.number,
                          initialValue: model.columnInput.purity,
                          decoration: InputDecoration(
                              labelText: AppLocalizations.of(context).purity),
                          validator: model.columnInput.purityValidator,
                          onSaved: model.setPurity,
                        ),
                      ),
                    ]))),
          ],
        ),
      ),
    );
  }
}

class _ColumnInputCard3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Form(
        key: fluidInputsFormKey,
        autovalidate: true,
        onChanged: () {
          if (fluidInputsFormKey.currentState.validate()) {
            fluidInputsFormKey.currentState.save();
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
                leading: Icon(Icons.invert_colors_on),
                title: Text(
                    /*AppLocalizations.of(context).desiredPurity*/ 'Selecione os Dados de Corrente',
                    style: _headerTextStyle)),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Text(
                      /*AppLocalizations.of(context).liquidLK*/ 'Líquido: '),
                ),
                ScopedModelDescendant<AbsorptionColumnInputData>(
                  builder: (context, _, model) => DropdownButton(
                      // hint: Text(
                      //     /*AppLocalizations.of(context).hintLiquidLK,*/
                      //     'líquido'),
                      value: model.columnInput.liquid,
                      items: model.columnInput.fluidInputDropDownItems(context),
                      onChanged: (dynamic value) => model.setLiquidName(value)),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Text(
                      /*AppLocalizations.of(context).liquidLK*/ 'Gás: '),
                ),
                ScopedModelDescendant<AbsorptionColumnInputData>(
                  builder: (context, _, model) => DropdownButton(
                      // hint: Text(
                      //     /*AppLocalizations.of(context).hintLiquidLK,*/
                      //     'gás'),
                      value: model.columnInput.gas,
                      items: model.columnInput.gasInputDropDownItems(context),
                      onChanged: (dynamic value) => model.setGasName(value)),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Text(
                      /*AppLocalizations.of(context).liquidLK*/ 'Contaminante: '),
                ),
                ScopedModelDescendant<AbsorptionColumnInputData>(
                  builder: (context, _, model) => DropdownButton(
                      // hint: Text(
                      //     /*AppLocalizations.of(context).hintLiquidLK,*/
                      //     ''),
                      value: model.columnInput.contaminant,
                      items: model.columnInput.dropdownList,
                      onChanged: (dynamic value) =>
                          model.setContaminantName(value)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ColumnInputCard2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Form(
        key: contaminantFormKey,
        autovalidate: true,
        onChanged: () {
          if (contaminantFormKey.currentState.validate()) {
            contaminantFormKey.currentState.save();
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
                leading: Icon(Icons.invert_colors_on),
                title: Text(
                    /*AppLocalizations.of(context).desiredPurity*/ 'Concentração Máxima de Contaminante na Saída',
                    style: _headerTextStyle)),
            SizedBox(
                width: 166,
                child: Padding(
                    padding:
                        EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                    child: Column(children: <Widget>[
                      ScopedModelDescendant<AbsorptionColumnInputData>(
                        builder: (context, _, model) => TextFormField(
                            autocorrect: false,
                            keyboardType: TextInputType.number,
                            initialValue: model.columnInput.contaminantOut,
                            decoration: InputDecoration(
                                labelText: /*AppLocalizations.of(context).purity*/ 'Contaminante (%)'),
                            validator: model.columnInput.purityValidator,
                            onSaved: model.setContaminantOut),
                      )
                    ])))
          ],
        ),
      ),
    );
  }
}

class _ColumnTypeRadio extends StatefulWidget {
  @override
  _ColumnTypeCard createState() => _ColumnTypeCard();
}

class _ColumnTypeCard extends State<_ColumnTypeRadio> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text(
              AppLocalizations.of(context).columnType,
              style: _headerTextStyle,
            ),
          ),
          Row(
            children: <Widget>[
              ScopedModelDescendant<AbsorptionColumnInputData>(
                  builder: (context, _, model) => ButtonBar(children: <Widget>[
                        Radio(
                            value: AppLocalizations.of(context).absorptionInput,
                            groupValue: columnInputModel.columnType,
                            activeColor: Colors.green,
                            onChanged: (String val) {
                              model.setColumnType(val, context);
                            }),
                        Padding(
                          padding: EdgeInsets.only(left: 0, right: 24.0),
                          child: Text(AppLocalizations.of(context).absorption),
                        ),
                        Radio(
                            value: AppLocalizations.of(context).strippingInput,
                            groupValue: columnInputModel.columnType,
                            activeColor: Colors.green,
                            onChanged: (val) {
                              model.setColumnType(val, context);
                            }),
                        Padding(
                          padding: EdgeInsets.only(left: 0, right: 24.0),
                          child: Text(AppLocalizations.of(context).stripping),
                        ),
                      ]))
            ],
          ),
        ],
      ),
    );
  }
}

class _SumaryCard extends StatelessWidget {
  final _titleStyle = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black);

  final _textStyle = TextStyle(fontSize: 14.0, color: Colors.black);

  TextSpan _mixtureSumary(
      AbsorptionColumnInputData model, BuildContext context) {
    String liquidLK;
    String liquidHK;
    String alpha;
    String columnType;
    String purity;
    String liquid;
    String gas;
    String contaminant;

    if (model.input.validateInput()) {
      liquidLK =
          "${AppLocalizations.of(context).liquidLK} ${model.input.liquidLK.name}\n";
      liquidHK =
          "${AppLocalizations.of(context).liquidHK} ${model.input.liquidHK.name}\n";
      alpha =
          "${AppLocalizations.of(context).alphaValue} ${model.getAlpha.toStringAsFixed(2)}";
    }

    if (model.columnInput.validateInput()) {
      purity =
          "${AppLocalizations.of(context).desiredPurity} ${model.columnInput.purity}%\n";
      columnType =
          "${AppLocalizations.of(context).columnType}: ${model.columnInput.columnType}\n";
      liquid = "Liquid Flow: ${model.columnInput.liquid}\n";
      gas = "Gas Flow: ${model.columnInput.gas}\n";
      contaminant = "Contaminant: ${model.columnInput.contaminant}\n";
    }

    return TextSpan(children: <TextSpan>[
      TextSpan(text: columnType, style: _textStyle),
      TextSpan(text: purity, style: _textStyle),
      TextSpan(text: liquid, style: _textStyle),
      TextSpan(text: gas, style: _textStyle),
      TextSpan(text: contaminant, style: _textStyle),
      TextSpan(text: liquidLK, style: _textStyle),
      TextSpan(text: liquidHK, style: _textStyle),
      TextSpan(text: alpha, style: _textStyle),
    ]);
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
              AppLocalizations.of(context).summary,
              style: _titleStyle,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            child: ScopedModelDescendant<AbsorptionColumnInputData>(
              builder: (context, _, model) => RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    _mixtureSumary(model, context),
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
