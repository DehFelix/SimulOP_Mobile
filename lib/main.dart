import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:simulop_v1/locale/locales.dart';
import 'package:simulop_v1/pages/home_page/home_page.dart';
import 'package:simulop_v1/pages/home_page/default_page.dart' as Default;
import 'package:simulop_v1/pages/unit_operation_1/example.dart' as UO1;
import 'package:simulop_v1/pages/unit_operation_1/pumping_of_fluids/pumping_of_fluids_input.dart';

void main() => runApp(SimulOPAPP());

class SimulOPAPP extends StatelessWidget {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        AppLocalizationDelegade(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale("en",""),
        Locale("pt",""),
      ],
      onGenerateTitle: (BuildContext context) => 
      AppLocalizations.of(context).title,
      theme: simulopTheme,
      home: HomePage(),
      routes: {
        "/default": (context) => Default.DefaultPage(),
        "/exemple1": (context) => UO1.ExempleOne(),
        "/pumpingOfFluidsInput": (context) => PumpingOfFluidsInput(),
      },
    );
  }

  final ThemeData simulopTheme = ThemeData(
    primarySwatch: Colors.purple,    
  );
}
