import 'package:flutter/material.dart';

class DefaultPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Default"),
      ),
      body: Center(child: Text("404: Page not Found",style: TextStyle(fontSize: 30.0),)),
    );
  }
}