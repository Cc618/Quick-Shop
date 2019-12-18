// Dialog functions

import 'package:flutter/material.dart';

// A dialog with one text field
Future<void> lineDialog(
    String title,
    String hint,
    String noInputText,
    BuildContext context,
    BuildContext scaffoldContext,
    Function(String) onInputValidated) async {
  String input = '';

  // Show dialog
  await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration.collapsed(hintText: hint),
            onChanged: (String s) => input = s,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                input = '';
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                // Error : No input
                if (input.isEmpty)
                  Scaffold.of(scaffoldContext).showSnackBar(SnackBar(
                    content: Text(noInputText),
                    duration: Duration(seconds: 1),
                  ));
                else
                  Navigator.of(context).pop();
              },
            ),
          ],
        );
      });

  // If input
  if (input.isNotEmpty) onInputValidated(input);
}

// Menu entry data
class MenuItem {
  String title;
  Function onPressed;
  bool isDangerous;

  MenuItem(this.title, this.onPressed, [this.isDangerous = false]);
}

// A dialog with one text field
Future<void> menuDialog(
    String title, BuildContext context, List<MenuItem> items) async {
  // Build the menu items
  var entries = List<Widget>();

  for (MenuItem item in items)
    entries.add(SimpleDialogOption(
      child: Text(
        item.title,
        style: TextStyle(
          color: item.isDangerous ? Theme.of(context).errorColor : Theme.of(context).textTheme.subtitle.color,
        )
      ),
      onPressed: () {
        item.onPressed();
        Navigator.of(context).pop();
      }
    ));

  // Display dialog
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(title: Text(title), children: entries);
    });
}
