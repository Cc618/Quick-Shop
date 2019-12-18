// A category handle items

import 'package:flutter/material.dart';
import 'item.dart';

class ListCategory extends StatefulWidget {
  // Model which handles all the data
  final ListCategoryModel m;

  ListCategory(this.m, {Key key}) : super(key: key);

  @override
  _CategoryView createState() => _CategoryView();
}

class ListCategoryModel {
  String title;
  List<ListItem> items;
  bool collapsed;

  ListCategoryModel({
    @required this.title,
    @required this.items,
    @required this.collapsed,
  });
}

class _CategoryView extends State<ListCategory> {
  @override
  Widget build(BuildContext context) {
    // Generate the children
    List<Widget> children = <Widget>[
      // Title
      ListTile(
        title: Text(widget.m.title),
        onTap: () =>
            setState(() => widget.m.collapsed = !widget.m.collapsed),
        trailing: IconButton(
          icon: Icon(Icons.more_vert),
          onPressed: () {}, // TODO : widget.onMenuEvent,
        ),
      ),
    ];

    // Add items
    if (!widget.m.collapsed)
      children.addAll(widget.m.items);
    // + Button
    children.add(RaisedButton.icon(
      onPressed: () {}, // TODO : widget.onItemEvent,
      label: Text('Add'),
      icon: Icon(Icons.add),
      color: Theme.of(context).accentColor, // TODO : categoryColor,
      textColor: Color(0xFFFFFFFF),
    ));

    return Card(
      child: InkWell(
            onLongPress: () {}, // TODO : widget.onMenuEvent,
            child: Column(
              children: children,
            )));
  }
}
