// A list page

import 'package:flutter/material.dart';
import 'category.dart';

class ListPage extends StatefulWidget {
  ListPage(this.m, {Key key}) : super(key: key);

  // Model which handles all the data
  final ListModel m;

  @override
  _ListView createState() => _ListView();
}

class ListModel {
  ListModel({
    @required this.title,
    @required this.categories
  });

  String title;
  List<ListCategory> categories;
}

class _ListView extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.m.title),
      ),
      body: Center(
        child: ListView(
          children: widget.m.categories
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Add Category',
        child: Icon(Icons.add),
      ),
    );
  }
}
