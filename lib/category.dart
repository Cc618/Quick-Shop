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

  ListCategoryModel({
    @required this.title,
    @required this.items
  });
}

class _CategoryView extends State<ListCategory> {
  @override
  Widget build(BuildContext context) {
    // Generate the children
    List<Widget> children = <Widget>[
      // Title
      Text(widget.m.title),
    ];

    // Add items
    children.addAll(widget.m.items);

    return Card(
      child: Column(
        children: children
      ),
    );
  }
}
