import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:simulop_v1/locale/locales.dart';
//import 'package:simulop_v1/pages/unit_operation_3/mccabe_thiele_method/mccabe_thiele_results.dart';
import 'package:simulop_v1/pages/unit_operation_3/mccabe_thiele_method/mccabe_thiele_results_animated.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:simulop_v1/pages/helper_classes/app_bar_menu_itens.dart';
import 'package:simulop_v1/pages/unit_operation_3/mccabe_thiele_method/input_data.dart';

final _headerTextStyle = TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);

List<HelpItem> helpItems = List<HelpItem>();

final mixtureFormKey = GlobalKey<FormState>();

final mixtureInputModel = MixtureInput();

class McCabeThieleMethodInput2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    helpItems = [
      HelpItem(AppLocalizations.of(context).moreInfoBtn, "/default",
          ActionType.route),
    ];
    return ScopedModel<McCabeThieleInputData>(
      model: McCabeThieleInputData(
        input: mixtureInputModel,
      ),
      child: Theme(
        data: ThemeData(primarySwatch: Colors.blueGrey),
        child: Scaffold(
            appBar: _McCabeThieleInputAppBar(),
            body: Container(child: _mainBody()),
            floatingActionButton: ScopedModelDescendant<McCabeThieleInputData>(
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
                      builder: (context) => McCabeThieleMethodResultsAnimated(
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
          //height: 200.0,
          child: SizedBox(width: 250.0, child: _MixtureInputCard()),
        ),
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
      title: Text(AppLocalizations.of(context).mcCabeTheileName),
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

/// The input card for the mixture
class _MixtureInputCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.invert_colors_off),
            title: Text(
              AppLocalizations.of(context).mixtureInput,
              style: _headerTextStyle,
            ),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                child: Text(AppLocalizations.of(context).liquidLK),
              ),
              ScopedModelDescendant<McCabeThieleInputData>(
                builder: (context, _, model) => DropdownButton(
                    hint: Text(
                      AppLocalizations.of(context).hintLiquidLK,
                    ),
                    value: model.input.liquidLK,
                    items: model.input.fluidInputDropDownItems(context),
                    onChanged: (dynamic value) => model.setLiquidLKName(value)),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                child: Text(AppLocalizations.of(context).liquidHK),
              ),
              ScopedModelDescendant<McCabeThieleInputData>(
                builder: (context, _, model) => DropdownButton(
                    hint: Text(
                      AppLocalizations.of(context).hintLiquidHK,
                    ),
                    value: model.input.liquidHK,
                    items: model.input.fluidInputDropDownItems(context),
                    onChanged: (dynamic value) => model.setLiquidHKName(value)),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 16.0),
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

  TextSpan _mixtureSumary(McCabeThieleInputData model, BuildContext context) {
    String liquidLK;
    String liquidHK;
    String alpha;

    if (model.input.validateInput()) {
      liquidLK =
          "${AppLocalizations.of(context).liquidLK} ${model.input.liquidLK.name}\n";
      liquidHK =
          "${AppLocalizations.of(context).liquidHK} ${model.input.liquidHK.name}\n";
      alpha =
          "${AppLocalizations.of(context).alphaValue} ${model.getAlpha.toStringAsFixed(2)}";
    }

    return TextSpan(children: <TextSpan>[
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
            child: ScopedModelDescendant<McCabeThieleInputData>(
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
