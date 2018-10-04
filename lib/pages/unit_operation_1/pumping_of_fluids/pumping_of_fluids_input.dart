import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:simulop_v1/locale/locales.dart';

import 'package:simulop_v1/pages/helper_classes/app_bar_menu_itens.dart';
import 'package:simulop_v1/pages/helper_classes/helper_dialog.dart';
import 'package:simulop_v1/pages/unit_operation_1/pumping_of_fluids/input_data.dart';
import 'package:simulop_v1/pages/unit_operation_1/pumping_of_fluids/pumping_of_fluids_results.dart';
import 'package:url_launcher/url_launcher.dart';

final _headerTextStyle = TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);

List<HelpItem> helpItems = List<HelpItem>();

final fluidFormKey = GlobalKey<FormState>();
final inletTubeFormKey = GlobalKey<FormState>();
final outletTubeFormKey = GlobalKey<FormState>();
final distancesFormKey = GlobalKey<FormState>();

final fluidInputModel = FluidInput();
final inletTubeInputModel = InletTubeInput();
final outletTubeInputModel = OutletTubeInput();
final distancesInputModel = DistancesInput();

/// The input Widget
class PumpingOfFluidsInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    helpItems = [
      HelpItem(
          AppLocalizations.of(context).defaultInputs, "runWithDefaultInputs", ActionType.widgetAction),
      HelpItem(AppLocalizations.of(context).moreInfoBtn, "showPumpingOfFluidsHelp", ActionType.widgetAction),
      HelpItem("About", "/default", ActionType.route),
    ];

    return ScopedModel<PumpingOfFluidsInputModel>(
      model: PumpingOfFluidsInputModel(
          fluidInputs: fluidInputModel,
          inletTubeInput: inletTubeInputModel,
          outletTubeInput: outletTubeInputModel,
          distancesInput: distancesInputModel),
      child: Theme(
        data: ThemeData(primarySwatch: Colors.green),
        child: Scaffold(
          appBar: _FluidInputAppBar(),
          body: Container(child: _mainBody(context)),
          floatingActionButton:
              ScopedModelDescendant<PumpingOfFluidsInputModel>(
            builder: (context, _, model) => FloatingActionButton(
                  child: Icon(model.getFabIcon),
                  onPressed: () {
                    if (!model.canCreateSimulation()) {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        duration: Duration(seconds: 2),
                        content: Text("Incomple inputs"),
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
                          builder: (context) => PumpingOfFluidsResults(
                                simulation: model.createSimulation(),
                              ),
                        ));
                  },
                ),
          ),
        ),
      ),
    );
  }

  /// The main body of the input forms.
  Widget _mainBody(BuildContext context) {
    return ListView(
      children: <Widget>[
        _picCard(context),
        Container(
          height: 340.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            addAutomaticKeepAlives: true,
            children: <Widget>[
              SizedBox(width: 250.0, child: _FluidInputCard()),
              SizedBox(width: 250.0, child: _InletTubeInputCard()),
              SizedBox(width: 250.0, child: _OutletTubeInputCard()),
              SizedBox(width: 250.0, child: _DistancesInputCard()),
            ],
          ),
        ),
        _SumaryCard(),
      ],
    );
  }

  Widget _picCard(BuildContext context) {
    return Card(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ListTile(
          leading: Icon(Icons.picture_in_picture),
          title: Text(AppLocalizations.of(context).picture, style: _headerTextStyle),
        ),
        Image(
          image: AssetImage('assets/images/pumpingOfLiquids_placeholder.png'),
        )
      ]),
    );
  }
}

/// AppBar for the Scaffold
class _FluidInputAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => AppBar().preferredSize;

  @override
  __FluidInputAppBarState createState() => __FluidInputAppBarState();
}

/// State for the AppBar
class __FluidInputAppBarState extends State<_FluidInputAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 2.0,
      title: Text(AppLocalizations.of(context).pumpingOfLiquidsName),
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
          PumpingOfFluidsInputModel.of(context).setDefaultInputs();
          var simalation =
              PumpingOfFluidsInputModel.of(context).createSimulation();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PumpingOfFluidsResults(
                    simulation: simalation,
                  ),
            ),
          );
        } else if (item.action == "showPumpingOfFluidsHelp") {
          showDialog(
            context: context,
            builder: (context) => HelpDialog("Helllow :")
          );
        }
        break;
      default:
    }
  }
}

/// The Card for the Liquid Input
class _FluidInputCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Form(
        key: fluidFormKey,
        autovalidate: true,
        onChanged: () {
          if (fluidFormKey.currentState.validate()) {
            fluidFormKey.currentState.save();
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.format_color_fill),
              title: Text(
                AppLocalizations.of(context).liquidInput,
                style: _headerTextStyle,
              ),
            ),
            Center(
                child: ScopedModelDescendant<PumpingOfFluidsInputModel>(
              builder: (context, _, model) => DropdownButton(
                  hint: Text(
                    "Select Liquid",
                  ),
                  value: model.fluidInput.name,
                  items: model.fluidInput.fluidInputDropDownItems(),
                  onChanged: (dynamic value) => model.setFluidName(value)),
            )),
            Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Column(children: <Widget>[
                ScopedModelDescendant<PumpingOfFluidsInputModel>(
                  builder: (context, _, model) => TextFormField(
                        autocorrect: false,
                        keyboardType: TextInputType.number,
                        initialValue: model.fluidInput.temperature,
                        decoration:
                            InputDecoration(labelText: AppLocalizations.of(context).hintTemperature),
                        validator: model.fluidInput.temperatureValidator,
                        onSaved: model.setFluidTemperature,
                      ),
                ),
                ScopedModelDescendant<PumpingOfFluidsInputModel>(
                  builder: (context, _, model) => TextFormField(
                        autocorrect: false,
                        autovalidate: true,
                        keyboardType: TextInputType.number,
                        initialValue: model.fluidInput.inletPressure,
                        decoration:
                            InputDecoration(labelText: AppLocalizations.of(context).hintPressure),
                        validator: model.fluidInput.pressureValidator,
                        onSaved: model.setFluidInletPressure,
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

/// The input card for the Inlet tube
class _InletTubeInputCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Form(
        key: inletTubeFormKey,
        autovalidate: true,
        onChanged: () {
          if (inletTubeFormKey.currentState.validate()) {
            inletTubeFormKey.currentState.save();
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.radio_button_checked),
              title: Text(
                AppLocalizations.of(context).inletInput,
                style: _headerTextStyle,
              ),
            ),
            Center(
                child: ScopedModelDescendant<PumpingOfFluidsInputModel>(
              builder: (context, _, model) => DropdownButton(
                  hint: Text("Select material"),
                  value: model.inletTubeInput.material,
                  items: model.inletTubeInput.inletMaterialInputDropDownItems(),
                  onChanged: (dynamic value) =>
                      model.setInletTubeMaterial(value)),
            )),
            Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Column(children: <Widget>[
                ScopedModelDescendant<PumpingOfFluidsInputModel>(
                  builder: (context, _, model) => TextFormField(
                        autocorrect: false,
                        keyboardType: TextInputType.number,
                        initialValue: model.inletTubeInput.diametre,
                        decoration: InputDecoration(labelText: AppLocalizations.of(context).hintDiametre),
                        validator: model.inletTubeInput.diametreValidator,
                        onSaved: model.setInletTubeDiametre,
                      ),
                ),
                ScopedModelDescendant<PumpingOfFluidsInputModel>(
                  builder: (context, _, model) => TextFormField(
                        autocorrect: false,
                        autovalidate: true,
                        keyboardType: TextInputType.number,
                        initialValue: model.inletTubeInput.equivalentDistance,
                        decoration: InputDecoration(
                            labelText: AppLocalizations.of(context).hintResistancesLenghts),
                        validator:
                            model.inletTubeInput.equivalentDistancesValidator,
                        onSaved: model.setInletTubeEquivalentDistances,
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

/// The input card for the Outlet tube
class _OutletTubeInputCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Form(
        key: outletTubeFormKey,
        autovalidate: true,
        onChanged: () {
          if (outletTubeFormKey.currentState.validate()) {
            outletTubeFormKey.currentState.save();
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.radio_button_checked),
              title: Text(
                AppLocalizations.of(context).outletInput,
                style: _headerTextStyle,
              ),
            ),
            Center(
                child: ScopedModelDescendant<PumpingOfFluidsInputModel>(
              builder: (context, _, model) => DropdownButton(
                  hint: Text("Select material"),
                  value: model.outletTubeInput.material,
                  items:
                      model.outletTubeInput.outletMaterialInputDropDownItems(),
                  onChanged: (dynamic value) =>
                      model.setOutletTubeMaterial(value)),
            )),
            Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Column(children: <Widget>[
                ScopedModelDescendant<PumpingOfFluidsInputModel>(
                  builder: (context, _, model) => TextFormField(
                        autocorrect: false,
                        keyboardType: TextInputType.number,
                        initialValue: model.outletTubeInput.diametre,
                        decoration: InputDecoration(labelText: AppLocalizations.of(context).hintDiametre),
                        validator: model.outletTubeInput.diametreValidator,
                        onSaved: model.setOutletTubeDiametre,
                      ),
                ),
                ScopedModelDescendant<PumpingOfFluidsInputModel>(
                  builder: (context, _, model) => TextFormField(
                        autocorrect: false,
                        autovalidate: true,
                        keyboardType: TextInputType.number,
                        initialValue: model.outletTubeInput.equivalentDistance,
                        decoration: InputDecoration(
                            labelText: AppLocalizations.of(context).hintResistancesLenghts),
                        validator:
                            model.outletTubeInput.equivalentDistancesValidator,
                        onSaved: model.setOutletTubeEquivalentDistances,
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

/// The input card for the Distances
class _DistancesInputCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Form(
        key: distancesFormKey,
        autovalidate: true,
        onChanged: () {
          if (distancesFormKey.currentState.validate()) {
            distancesFormKey.currentState.save();
          }
        },
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.straighten),
              title: Text(
               AppLocalizations.of(context).distancesInput,
                style: _headerTextStyle,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Column(children: <Widget>[
                ScopedModelDescendant<PumpingOfFluidsInputModel>(
                  builder: (context, _, model) => TextFormField(
                        autocorrect: false,
                        keyboardType: TextInputType.number,
                        initialValue: model.distancesInput.dzInlet,
                        decoration: InputDecoration(labelText: AppLocalizations.of(context).hintDzInlet),
                        validator: model.distancesInput.heightValidator,
                        onSaved: model.setDistancesDzInlet,
                      ),
                ),
                ScopedModelDescendant<PumpingOfFluidsInputModel>(
                  builder: (context, _, model) => TextFormField(
                        autocorrect: false,
                        autovalidate: true,
                        keyboardType: TextInputType.number,
                        initialValue: model.distancesInput.lInlet,
                        decoration: InputDecoration(labelText: AppLocalizations.of(context).hintLInlet),
                        validator: model.distancesInput.distanceInletValidator,
                        onSaved: model.setDistancesLInlet,
                      ),
                ),
                ScopedModelDescendant<PumpingOfFluidsInputModel>(
                  builder: (context, _, model) => TextFormField(
                        autocorrect: false,
                        keyboardType: TextInputType.number,
                        initialValue: model.distancesInput.dzOutlet,
                        decoration: InputDecoration(labelText: AppLocalizations.of(context).hintDzOutlet),
                        validator: model.distancesInput.heightValidator,
                        onSaved: model.setDistancesDzOutlet,
                      ),
                ),
                ScopedModelDescendant<PumpingOfFluidsInputModel>(
                  builder: (context, _, model) => TextFormField(
                        autocorrect: false,
                        autovalidate: true,
                        keyboardType: TextInputType.number,
                        initialValue: model.distancesInput.lOutlet,
                        decoration: InputDecoration(labelText: AppLocalizations.of(context).hintLOutlet),
                        validator: model.distancesInput.distanceOutletValidator,
                        onSaved: model.setDistancesLOutlet,
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

/// The sumary card
class _SumaryCard extends StatelessWidget {
  final _titleStyle = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black);

  final _textStyle = TextStyle(fontSize: 14.0, color: Colors.black);

  TextSpan _fluidSumary(PumpingOfFluidsInputModel model, BuildContext context) {
    String fluid;
    String density;
    String viscosity;
    String vaporPressure;

    if (model.validadeFluid()) {
      fluid = "${AppLocalizations.of(context).summaryLiquid} - ${model.fluidInput.name} \n";
      density = "${AppLocalizations.of(context).summaryDensity}: ${model.getSumaryLiquidDensity} kg/m^3 \n";
      viscosity = "${AppLocalizations.of(context).summaryViscosity}: ${model.getSumaryLiquidViscosity} cP \n";
      vaporPressure =
          "${AppLocalizations.of(context).summaryVaporPre} ${model.getSumaryLiquidVaporPressure} KPa \n";
    }

    return TextSpan(
      children: <TextSpan>[
        TextSpan(text: fluid, style: _titleStyle),
        TextSpan(text: density, style: _textStyle),
        TextSpan(text: viscosity, style: _textStyle),
        TextSpan(text: vaporPressure, style: _textStyle),
      ],
    );
  }

  TextSpan _inletTubeSumary(PumpingOfFluidsInputModel model, BuildContext context) {
    String tube;
    String roughness;
    String diametre;
    String lenth;
    String elevation;

    if (model.validateInletTube()) {
      tube = "${AppLocalizations.of(context).summayInletTube} - ${model.inletTubeInput.material} \n";
      roughness = "${AppLocalizations.of(context).summaryRoughness} ${model.getSumaryInletTubeRoughness} mm \n";
      diametre = "${AppLocalizations.of(context).summaryDiametre} ${model.inletTubeInput.diametre} cm \n";
      lenth = "${AppLocalizations.of(context).summaryLenght} ${model.distancesInput.lInlet} m \n";
      elevation = "${AppLocalizations.of(context).summaryElevation} ${model.distancesInput.dzInlet} m \n";
    }

    return TextSpan(children: <TextSpan>[
      TextSpan(text: tube, style: _titleStyle),
      TextSpan(text: roughness, style: _textStyle),
      TextSpan(text: diametre, style: _textStyle),
      TextSpan(text: lenth, style: _textStyle),
      TextSpan(text: elevation, style: _textStyle),
    ]);
  }

  TextSpan _outletTubeSumary(PumpingOfFluidsInputModel model, BuildContext context) {
    String tube;
    String roughness;
    String diametre;
    String lenth;
    String elevation;

    if (model.validateOutletTube()) {
      tube = "${AppLocalizations.of(context).summayInletTube} - ${model.outletTubeInput.material} \n";
      roughness = "${AppLocalizations.of(context).summaryRoughness} ${model.getSumaryOutletTubeRoughness} mm \n";
      diametre = "${AppLocalizations.of(context).summaryDiametre} ${model.outletTubeInput.diametre} cm \n";
      lenth = "${AppLocalizations.of(context).summaryLenght} ${model.distancesInput.lOutlet} m \n";
      elevation = "${AppLocalizations.of(context).summaryElevation} ${model.distancesInput.dzOutlet} m \n";
    }

    return TextSpan(children: <TextSpan>[
      TextSpan(text: tube, style: _titleStyle),
      TextSpan(text: roughness, style: _textStyle),
      TextSpan(text: diametre, style: _textStyle),
      TextSpan(text: lenth, style: _textStyle),
      TextSpan(text: elevation, style: _textStyle),
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
            child: ScopedModelDescendant<PumpingOfFluidsInputModel>(
              builder: (context, _, model) => RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        _fluidSumary(model, context),
                        TextSpan(text: "\n"),
                        _inletTubeSumary(model, context),
                        TextSpan(text: "\n"),
                        _outletTubeSumary(model, context),
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
