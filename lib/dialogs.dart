// Dialog functions

import 'package:flutter/material.dart';

// The radius of a corner
double dialogCornerRadius = 16;

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
            textCapitalization: TextCapitalization.words,
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
  IconData icon;

  MenuItem(this.title, this.onPressed, this.icon, [this.isDangerous = false]);
}

// A dialog with one text field
Future<void> menuDialog(
    String title, BuildContext context, List<MenuItem> items) async {
  // Build the menu items
  var entries = List<Widget>();

  for (MenuItem item in items)
    entries.add(ListTile(
        leading: Icon(item.icon),
        title: Text(item.title,
            style: TextStyle(
              color: item.isDangerous
                  ? Theme.of(context).errorColor
                  : Theme.of(context).textTheme.subtitle.color,
            )),
        onTap: () {
          item.onPressed();
          Navigator.of(context).pop();
        }));

  // Display dialog
  await showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(dialogCornerRadius)
      ),
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: new Wrap(children: entries),
        );
      });
}
