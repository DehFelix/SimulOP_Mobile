import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SelectionTile {
  final String title;
  final IconData icon;
  final String description;
  final String route;

  SelectionTile(this.title, this.icon, this.description, [this.route = "/default"]);
}

/// Builds the selection tile with the [SelectionTile] provided.
Widget tileSelectionBuilder(BuildContext context, SelectionTile tile) {
  return ExpansionTile(
    title: Text(tile.title),
    leading: Icon(tile.icon),
    children: <Widget>[
      Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0),
        child: Text(
          tile.description,
          textAlign: TextAlign.justify,
        ),
      ),
      Padding(
        padding: EdgeInsets.only(right: 16.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
          FlatButton(
            child: Text("More info"),
            onPressed: () {_lunchURL();},
          ),
          RaisedButton(
            onPressed: () {Navigator.of(context).pushNamed(tile.route);},
            child: Text(
              "Lunch App",
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.blue[400],
          ),
        ]),
      ),
      Padding(
        padding: EdgeInsets.only(bottom: 10.0),
      ),
    ],
  );
}

void _lunchURL() async{
  const url = "https://github.com/rafaelterras/SimulOp";
  if (await canLaunch(url)) {
    await launch(url);
  } else {
      throw "Could not lunch $url";
  }
}

class TheGridViwer {
  Card makeGridCell(String name, IconData icon) {
    return Card(
      elevation: 1.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          Center(child: Icon(icon)),
          Center(child: Text(name))
        ],
      ),
    );
  }
}
