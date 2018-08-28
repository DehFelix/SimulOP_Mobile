import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:simulop_v1/pages/helper_classes/app_bar_menu_itens.dart';
import 'package:simulop_v1/pages/unit_operation_1/pumping_of_fluids/input_data.dart';

final _headerTextStyle = TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);
final _normalTextStyle = TextStyle(fontSize: 16.0);

final helpItems = [
  HelpItem("More info", "/default"),
  HelpItem("About", "/default"),
];

final fluidFormKey = GlobalKey<FormState>();
final inletTubeFormKey = GlobalKey<FormState>();
final outletTubeFormKey = GlobalKey<FormState>();
final distancesFormKey = GlobalKey<FormState>();

final fluidInputModel = FluidInput();
final inletTubeInputModel = InletTubeInput();
final outleTubeInputModel = OutletTubeInput();
final distancesInputModel = DistancesInput();

class PumpingOfFluidsInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<PumpingOfFluidsInputModel>(
      model: PumpingOfFluidsInputModel(
          fluidInputs: fluidInputModel,
          inletTubeInput: inletTubeInputModel,
          outletTubeInput: outleTubeInputModel,
          distancesInput: distancesInputModel),
      child: Scaffold(
        appBar: _FluidInputAppBar(),
        body: Container(child: _mainBody()),
        floatingActionButton: ScopedModelDescendant<PumpingOfFluidsInputModel>(
          rebuildOnChange: false,
          builder: (context, _, model) => FloatingActionButton(
                child: Icon(Icons.refresh),
                onPressed: () {
                  model.debugPrint();
                },
              ),
        ),
      ),
    );
  }

  /// The main body of the input forms.
  Widget _mainBody() {
    return ListView(
      children: <Widget>[
        _picCard(),
        Container(
          height: 400.0,
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

  Widget _picCard() {
    return Card(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ListTile(
          leading: Icon(Icons.picture_in_picture),
          title: Text("Picture:", style: _headerTextStyle),
        ),
        Image.network(
            "https://preview.ibb.co/g5VPk9/Bombeamento_Completov2.png"),
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
      title: Text("Pumping of fluids"),
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
    Navigator.of(context).pushNamed(item.route);
  }
}

/// The Card for the fluid Input
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
                "Fluid Input: ",
                style: _headerTextStyle,
              ),
            ),
            Center(
                child: ScopedModelDescendant<PumpingOfFluidsInputModel>(
              builder: (context, _, model) => DropdownButton(
                  hint: Text(
                    "Select Fluid",
                  ),
                  value: model.fluidInput.name,
                  items: model.fluidInput.fluidInputDropDownItems(),
                  onChanged: (dynamic value) => model.setFluidName(value)),
            )),
            Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Column(children: <Widget>[
                ScopedModelDescendant<PumpingOfFluidsInputModel>(
                  rebuildOnChange: false,
                  builder: (context, _, model) => TextFormField(
                        autocorrect: false,
                        keyboardType: TextInputType.number,
                        initialValue: model.fluidInput.temperature,
                        decoration:
                            InputDecoration(labelText: "Temperature (°C)"),
                        validator: model.fluidInput.temperatureValidator,
                        onSaved: model.setFluidTemperature,
                      ),
                ),
                ScopedModelDescendant<PumpingOfFluidsInputModel>(
                  rebuildOnChange: false,
                  builder: (context, _, model) => TextFormField(
                        autocorrect: false,
                        autovalidate: true,
                        keyboardType: TextInputType.number,
                        initialValue: model.fluidInput.inletPressure,
                        decoration:
                            InputDecoration(labelText: "Pressure (bar)"),
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

/// The input card for the suction tube
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
                "Inlet Tube Input: ",
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
                  rebuildOnChange: false,
                  builder: (context, _, model) => TextFormField(
                        autocorrect: false,
                        keyboardType: TextInputType.number,
                        initialValue: model.inletTubeInput.diametre,
                        decoration: InputDecoration(labelText: "Diametre (cm)"),
                        validator: model.inletTubeInput.diametreValidator,
                        onSaved: model.setInletTubeDiametre,
                      ),
                ),
                ScopedModelDescendant<PumpingOfFluidsInputModel>(
                  rebuildOnChange: false,
                  builder: (context, _, model) => TextFormField(
                        autocorrect: false,
                        autovalidate: true,
                        keyboardType: TextInputType.number,
                        initialValue: model.inletTubeInput.equivalentDistance,
                        decoration: InputDecoration(labelText: "Distances (m)"),
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

/// The input card for the suction tube
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
                "Outlet Tube Input: ",
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
                  rebuildOnChange: false,
                  builder: (context, _, model) => TextFormField(
                        autocorrect: false,
                        keyboardType: TextInputType.number,
                        initialValue: model.outletTubeInput.diametre,
                        decoration: InputDecoration(labelText: "Diametre (cm)"),
                        validator: model.outletTubeInput.diametreValidator,
                        onSaved: model.setOutletTubeDiametre,
                      ),
                ),
                ScopedModelDescendant<PumpingOfFluidsInputModel>(
                  rebuildOnChange: false,
                  builder: (context, _, model) => TextFormField(
                        autocorrect: false,
                        autovalidate: true,
                        keyboardType: TextInputType.number,
                        initialValue: model.outletTubeInput.equivalentDistance,
                        decoration: InputDecoration(labelText: "Distances (m)"),
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

/// The input card for the suction tube
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.straighten),
              title: Text(
                "Distances Input: ",
                style: _headerTextStyle,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Column(children: <Widget>[
                ScopedModelDescendant<PumpingOfFluidsInputModel>(
                  rebuildOnChange: false,
                  builder: (context, _, model) => TextFormField(
                        autocorrect: false,
                        keyboardType: TextInputType.number,
                        initialValue: model.distancesInput.dzInlet,
                        decoration: InputDecoration(labelText: "Dz inlet (m)"),
                        validator: model.distancesInput.heightValidator,
                        onSaved: model.setDistancesDzInlet,
                      ),
                ),
                ScopedModelDescendant<PumpingOfFluidsInputModel>(
                  rebuildOnChange: false,
                  builder: (context, _, model) => TextFormField(
                        autocorrect: false,
                        autovalidate: true,
                        keyboardType: TextInputType.number,
                        initialValue: model.distancesInput.lInlet,
                        decoration: InputDecoration(labelText: "L Inlet (m)"),
                        validator: model.distancesInput.distanceValidator,
                        onSaved: model.setDistancesLInlet,
                      ),
                ),
                ScopedModelDescendant<PumpingOfFluidsInputModel>(
                  rebuildOnChange: false,
                  builder: (context, _, model) => TextFormField(
                        autocorrect: false,
                        keyboardType: TextInputType.number,
                        initialValue: model.distancesInput.dzOutlet,
                        decoration: InputDecoration(labelText: "Dz Outlet (m)"),
                        validator: model.distancesInput.heightValidator,
                        onSaved: model.setDistancesDzOutlet,
                      ),
                ),
                ScopedModelDescendant<PumpingOfFluidsInputModel>(
                  rebuildOnChange: false,
                  builder: (context, _, model) => TextFormField(
                        autocorrect: false,
                        autovalidate: true,
                        keyboardType: TextInputType.number,
                        initialValue: model.distancesInput.lOutlet,
                        decoration: InputDecoration(labelText: "L Outlet (m)"),
                        validator: model.distancesInput.distanceValidator,
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

class _SumaryCard extends StatelessWidget {
  final _titleStyle = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black);

  final _textStyle = TextStyle(fontSize: 14.0, color: Colors.black);

  TextSpan _fluidSumary(PumpingOfFluidsInputModel model) {
    String fluid;
    String density;
    String viscosity;
    String vaporPressure;

    if (model.createFluid()) {
      fluid = "Fluid - ${model.fluidInput.name} \n";
      density = "Density: 1000 kg/m^3 \n";
      viscosity = "Viscosity: 1 cP \n";
      vaporPressure = "Vapor pressure: 300 KPa \n";
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

  TextSpan _inletTubeSumary(PumpingOfFluidsInputModel model) {
    String tube;
    String roughness;
    String diametre;
    String lenth;
    String elevation;

    if (model.createInletTube()) {
      tube = "Inlet Tube - ${model.inletTubeInput.material} \n";
      roughness = "Roughness: 0.001 cm \n";
      diametre = "Diametre: ${model.inletTubeInput.diametre} cm \n";
      lenth = "Lenth: ${model.distancesInput.lInlet} m \n";
      elevation = "Elevation: ${model.distancesInput.dzInlet} m \n";
    }

    return TextSpan(children: <TextSpan>[
      TextSpan(text: tube, style: _titleStyle),
      TextSpan(text: roughness, style: _textStyle),
      TextSpan(text: diametre, style: _textStyle),
      TextSpan(text: lenth, style: _textStyle),
      TextSpan(text: elevation, style: _textStyle),
    ]);
  }

  TextSpan _outletTubeSumary(PumpingOfFluidsInputModel model) {
    String tube;
    String roughness;
    String diametre;
    String lenth;
    String elevation;

    if (model.createOutletTube()) {
      tube = "Inlet Tube - ${model.outletTubeInput.material} \n";
      roughness = "Roughness: 0.001 cm \n";
      diametre = "Diametre: ${model.outletTubeInput.diametre} cm \n";
      lenth = "Lenth: ${model.distancesInput.lOutlet} m \n";
      elevation = "Elevation: ${model.distancesInput.dzOutlet} m \n";
    }

    return TextSpan(children: <TextSpan>[
      TextSpan(text: tube, style: _titleStyle),
      TextSpan(text: roughness, style: _textStyle),
      TextSpan(text: diametre, style: _textStyle),
      TextSpan(text: lenth, style: _textStyle),
      TextSpan(text: elevation, style: _textStyle),
    ]);
  }

  TextSpan _distancesSumary(PumpingOfFluidsInputModel model) {}

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
            child: ScopedModelDescendant<PumpingOfFluidsInputModel>(
              builder: (context, _, model) => RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        _fluidSumary(model),
                        TextSpan(text: "\n"),
                        _inletTubeSumary(model),
                        TextSpan(text: "\n"),
                        _outletTubeSumary(model),
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