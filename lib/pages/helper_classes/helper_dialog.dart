import 'package:flutter/material.dart';

class HelpDialog extends StatelessWidget {
  final _textStyle = TextStyle(fontSize: 14.0, color: Colors.black);

  final String help;

  HelpDialog(this.help);

  final tes = "Help not found \n Please report on GitHub \n Help not found \n Please report on GitHub \n Help not found \n Please report on GitHub \n Help not found \n Please report on GitHub \n Help not found \n Please report on GitHub \n Help not found \n Please report on GitHub \n Help not found \n Please report on GitHub \n Help not found \n Please report on GitHub \n Help not found \n Please report on GitHub \n Help not found \n Please report on GitHub \n Help not found \n Please report on GitHub \n Help not found \n Please report on GitHub \n Help not found \n Please report on GitHub \n Help not found \n Please report on GitHub \n Help not found \n Please report on GitHub \n ";

  @override
  Widget build(BuildContext context) {    
    return AlertDialog(
      title: Text(help),
      content: SingleChildScrollView(
        child: RichText(
          text: TextSpan(style: _textStyle, text: tes),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Ok"),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );
  }
}
