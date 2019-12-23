// A list page

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quick_shop/files.dart';
import 'category.dart';
import 'dialogs.dart';

class ListPage extends StatefulWidget {
  // To display messages on snackbar
  static BuildContext scaffoldContext;

  // Model which handles all the data
  final ListModel m;
  
  const ListPage(this.m, {Key key}) : super(key: key);

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

class _ListView extends State<ListPage> with WidgetsBindingObserver {
  @override
  void dispose() {
    save();
    
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive)
      save();
  }

  @protected
  void initState() {
    super.initState();

    // To have app state events
    WidgetsBinding.instance.addObserver(this);

    // Set onMenu function for each category
    for (var cat in widget.m.categories)
      cat.m.onRemoval = onCategoryRemoveEntry;
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
        onPressed: newCategoryDialog,
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
    data.onRemoval = onCategoryRemoveEntry;
    setState(() => widget.m.categories.add(ListCategory(data)));
  }

  void onCategoryRemoveEntry(ListCategory category)
    => setState(() => widget.m.categories.remove(category));

  // Save or update the file on the device
  Future<void> save()
    => writeListFile(widget.m);
}

// Describes a file linked to a list
class ListDescriptor {
  String name;
}
