// A list page

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'category.dart';
import 'dialogs.dart';

class ListPage extends StatefulWidget {
  // To display messages on snackbar
  static BuildContext scaffoldContext;

  // Model which handles all the data
  final ListModel m;

  ListPage(this.m, {Key key}) : super(key: key);

  @override
  _ListView createState() => _ListView();
}

class ListModel {
  String title;
  List<ListCategory> categories;

  ListModel({
    @required this.title,
    @required this.categories
  });

  ListModel.fromJson(this.title, String jsonData) {
    // Convert json
    var data = jsonDecode(jsonData);

    // Set properties
    categories = [];

    var cats = data['categories'] ?? [];

    for (var c in cats)
      categories.add(ListCategory(ListCategoryModel.fromMap(c)));
  }

  String toJson() {
    List<Map<String, dynamic>> serializedCategories = [];
    for (var c in categories)
      serializedCategories.add(c.m.toMap());

    Map<String, dynamic> data = {
      'categories': serializedCategories,
    };

    return jsonEncode(data);
  }
}

class _ListView extends State<ListPage> {
  @protected
  void initState() {
    super.initState();

    // Set onMenu function for each category
    for (var cat in widget.m.categories)
      cat.m.onMenu = onCategoryMenu;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.m.title),
      ),
      body: Builder(
        builder: (BuildContext context) {
          // Update the scaffold context
          ListPage.scaffoldContext = context;
          
          return ListView.builder(
            itemBuilder: (context, i) => widget.m.categories[i],
            itemCount: widget.m.categories.length,
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => print(widget.m.toJson()),
        // TODO
        // onPressed: newCategoryDialog,
        tooltip: 'Add Category',
        child: Icon(Icons.add),
      ),
    );
  }

  // Displays a dialog to append a category
  void newCategoryDialog()
    => lineDialog(
      'New Category', 'Category Title', 'Please enter a title',
      context, ListPage.scaffoldContext, (input) => setState(()
        => addCategory(ListCategoryModel(title: input, items: [], collapsed: false))
      ));

  // Appends a category to the list
  // The onMenu function is initialised
  void addCategory(ListCategoryModel data) {
    data.onMenu = onCategoryMenu;
    setState(() => widget.m.categories.add(ListCategory(data)));
  }

  // When the user clicks on the more button in a category
  void onCategoryMenu(ListCategory category)
    => menuDialog(category.m.title, context, [
      MenuItem('Remove', () => setState(() => widget.m.categories.remove(category)), true)
    ]);
}
