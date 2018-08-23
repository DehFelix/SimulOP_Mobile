import 'package:flutter/material.dart';

class ExempleOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Exaple 1"),
      ),
      body: Center(child: Text("404: Page not Found",style: TextStyle(fontSize: 25.0),)),
    );
  }
}