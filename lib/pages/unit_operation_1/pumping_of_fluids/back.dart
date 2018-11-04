/*

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
                    AppLocalizations.of(context).hintSelectLiquid,
                  ),
                  //value: model.fluidInputs.liquid,
                  items: model.fluidInput.fluidInputDropDownItems(context),
                  onChanged: (dynamic value) {
                    print(value.name);
                    model.setFluid(value);
                  }),
            )),
            Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Column(children: <Widget>[
                ScopedModelDescendant<PumpingOfFluidsInputModel>(
                  builder: (context, _, model) => TextFormField(
                        autocorrect: false,
                        keyboardType: TextInputType.number,
                        initialValue: model.fluidInput.temperature,
                        decoration: InputDecoration(
                            labelText:
                                AppLocalizations.of(context).hintTemperature),
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
                        decoration: InputDecoration(
                            labelText:
                                AppLocalizations.of(context).hintPressure),
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

*/