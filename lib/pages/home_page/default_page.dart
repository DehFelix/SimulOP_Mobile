import 'package:flutter/material.dart';

class DefaultPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sobre"),
        ),
        body: Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Center(
            child: Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Text(
                      "Deselvolvido por:",
                      style: TextStyle(fontSize: 30.0),
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Text(
                      "André Antonio, Rafael Terras e Roland Frauendorf",
                      style: TextStyle(fontSize: 20.0),
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Text(
                      "Projeto de TCC - PQI - 2018 e 2021",
                      style: TextStyle(fontSize: 25.0),
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Text(
                      "Professor orientador: Moises Teles",
                      style: TextStyle(fontSize: 20.0),
                    )),
              ],
              mainAxisAlignment: MainAxisAlignment.start,
            ),
          ),
        ));
  }
}
