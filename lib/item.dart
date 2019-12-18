// A list item

import 'package:flutter/material.dart';

class ListItem extends StatefulWidget {
  // Model which handles all the data
  final ListItemModel m;

  ListItem(this.m, {Key key}) : super(key: key);

  @override
  _ItemView createState() => _ItemView();
}

class ListItemModel {
  String title;
  bool checked;
  
  ListItemModel({
    @required this.title,
    @required this.checked
  });

  ListItemModel.fromMap(Map<String, dynamic> data) {
    title = data['title'];
    checked = data['checked'];
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'checked': checked,
    };
  }
}

class _ItemView extends State<ListItem> {
  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Checkbox(
        onChanged: (value) => setState(() => widget.m.checked = value),
        value: widget.m.checked,
      ),
      Text(widget.m.title)
    ]);
  }
}
