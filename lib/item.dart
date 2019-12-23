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
  
  Function(ListItem) onRemoval;

  ListItemModel({
    @required this.title,
    @required this.checked,
    this.onRemoval
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
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (dir) => widget.m.onRemoval(widget),
      child: Row(
        children: <Widget>[
          Checkbox(
            onChanged: (value) => setState(() => widget.m.checked = value),
            value: widget.m.checked,
          ),
          Expanded(
            child: Text(widget.m.title)
          )
        ]
      )
    );
  }
}
