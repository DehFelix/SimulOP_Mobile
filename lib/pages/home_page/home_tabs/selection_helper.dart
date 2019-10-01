import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
// import 'package:url_launcher/url_launcher.dart';

import 'package:simulop_v1/locale/locales.dart';

class SelectionTile {
  final String title;
  final IconData icon;
  final String imagePath;
  final String description;
  final String route;
  final bool isDisable;

  SelectionTile(
      {@required this.description,
      @required this.isDisable,
      @required this.title,
      this.imagePath = "",
      this.icon = Icons.help,
      this.route = "/default"});

//  SelectionTile(this.title, this.icon, this.isDisable, this.description,
  //    [this.route = "/default"]);
}

/// Builds the selection tile with the [SelectionTile] provided.
Widget tileSelectionBuilder(BuildContext context, SelectionTile tile) {
  return ExpansionTile(
    title: Text(tile.title),
    leading: (tile.imagePath != "")
        ? Image.asset(
            tile.imagePath,
            scale: 2.0,
            color: Colors.black45,
          )
        : Icon(tile.icon),
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
          // FlatButton(
          //   child: Text(AppLocalizations.of(context).moreInfoBtn,
          //       style: TextStyle(
          //         color: Theme.of(context).accentColor,
          //       )),
          //   onPressed: () {
          //     _lunchURL();
          //   },
          // ),
          RaisedButton(
            onPressed: (tile.isDisable)
                ? null
                : () {
                    Navigator.of(context).pushNamed(tile.route);
                  },
            child: Text(
              AppLocalizations.of(context).lunchAppBtn,
              style: TextStyle(color: Colors.white),
            ),
            color: Theme.of(context).primaryColor,
          ),
        ]),
      ),
      Padding(
        padding: EdgeInsets.only(bottom: 10.0),
      ),
    ],
  );
}

// void _lunchURL() async {
//   const url = "https://github.com/rafaelterras/SimulOp";
//   if (await canLaunch(url)) {
//     await launch(url);
//   } else {
//     throw "Could not lunch $url";
//   }
// }

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
