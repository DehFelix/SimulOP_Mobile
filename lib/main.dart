import 'package:flutter/material.dart';

import 'package:simulop_v1/pages/home_page/home_page.dart';
import 'package:simulop_v1/pages/home_page/default_page.dart' as Default;
import 'package:simulop_v1/pages/unit_operation_1/example.dart' as UO1;

void main() => runApp(SimulOPAPP());

class SimulOPAPP extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
     home: HomePage(),
     routes: {
       "/default" : (context) => Default.DefaultPage(),
       "/exemple1" : (context) => UO1.ExempleOne(),
     },
    );
  }
}

