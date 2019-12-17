// A list item

import 'package:flutter/material.dart';

class ListItem extends StatefulWidget {
  ListItem(this.m, {Key key}) : super(key: key);

  // Model which handles all the data
  final ListItemModel m;

  @override
  _ItemView createState() => _ItemView();
}

class ListItemModel {
  ListItemModel({
    @required this.title,
    @required this.checked
  });

  String title;
  bool checked;
}

class _ItemView extends State<ListItem> {
  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Checkbox(
        onChanged: (value) => setState(() => widget.m.checked = value),
        value: widget.m.checked,
      ),
      Text(
        widget.m.title
      )
    ]);
  }
}
