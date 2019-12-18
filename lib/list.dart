// A list page

import 'package:flutter/material.dart';
import 'category.dart';

class ListPage extends StatefulWidget {
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
}

class _ListView extends State<ListPage> {
  // To display messages on snackbar
  BuildContext _scaffoldContext;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.m.title),
      ),
      body: Builder(
        builder: (BuildContext context) {
          // Update the scaffold context
          _scaffoldContext = context;
          
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
  Future<void> newCategoryDialog() async {
    // Can be null if the user cancels
    String title = '';

    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('New Category'),
            content: TextField(
              autofocus: true,
              decoration: InputDecoration.collapsed(hintText: 'Title'),
              onChanged: (String s) => title = s,
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancel'),
                // Cancel input
                onPressed: () => Navigator.of(context).pop()
              ),
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  // Error : No name
                  if (title.isEmpty)
                    Scaffold.of(_scaffoldContext).showSnackBar(SnackBar(
                      content: Text('Please enter a title'),
                      duration: Duration(seconds: 1),
                    ));
                  else
                    // Validate input
                    Navigator.of(context).pop();
                },
              ),
            ],
          );
        });

    // Add the category if there is input
    if (title.isNotEmpty)
      addCategory(ListCategoryModel(title: title, items: [], collapsed: false));
  }

  // Appends a category to the list
  void addCategory(ListCategoryModel data) =>
      setState(() => widget.m.categories.add(ListCategory(data)));
}
