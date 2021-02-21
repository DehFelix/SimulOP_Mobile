import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:simulop_v1/locale/locales.dart';
import 'package:simulop_v1/pages/home_page/home_page.dart';
import 'package:simulop_v1/pages/home_page/default_page.dart';
import 'package:simulop_v1/pages/unit_operation_1/example.dart';
import 'package:simulop_v1/pages/unit_operation_1/pumping_of_fluids/pumping_of_fluids_input.dart';
import 'package:simulop_v1/pages/unit_operation_3/mccabe_thiele_method/mccabe_thiele_input.dart';
import 'package:simulop_v1/pages/unit_operation_3/absorption_column/absorption_column_input.dart';
import 'package:simulop_v1/pages/unit_operation_2/double_pipe_heatx/double_pipe_input.dart';

void main() => runApp(SimulOPAPP());

class SimulOPAPP extends StatelessWidget {
  final ThemeData simulopTheme = ThemeData(
    primarySwatch: Colors.blue,
  );

  // This widget is the root of SimulOP.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      localizationsDelegates: [
        AppLocalizationDelegade(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale("en", ""),
        Locale("pt", ""),
      ],
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context).simulop,
      theme: simulopTheme,
      home: HomePage(),
      routes: {
        "/default": (context) => DefaultPage(),
        "/exemple1": (context) => ExempleOne(),
        "/pumpingOfFluidsInput": (context) => PumpingOfFluidsInput(),
        "/mcCabeThieleMethod": (context) => McCabeThieleMethodInput(),
        "/doublePipeHeatX": (context) => DoublePiPeInput(),
        "/absorption_columns": (context) => McCabeThieleMethodInput2(),
        "/about": (context) => DefaultPage(),
      },
    );
  }
}
