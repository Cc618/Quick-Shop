// A category handle items

import 'package:flutter/material.dart';
import 'item.dart';
import 'list.dart';
import 'dialogs.dart';

class ListCategory extends StatefulWidget {
  // Model which handles all the data
  final ListCategoryModel m;

  const ListCategory(this.m, {Key key}) : super(key: key);

  @override
  _CategoryView createState() => _CategoryView();
}

class ListCategoryModel {
  String title;
  List<ListItem> items;
  bool collapsed;

  // When we hit the remove entry in the more menu
  Function(ListCategory) onRemoval;

  ListCategoryModel({
    @required this.title,
    @required this.items,
    @required this.collapsed,
    this.onRemoval,
  });

  ListCategoryModel.fromMap(Map<String, dynamic> data) {
    title = data['title'];

    items = [];
    for (var item in data['items'])
      items.add(ListItem(ListItemModel.fromMap(item)));

    // Not collapsed by default
    collapsed = false;
  }

  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> serializedItems = [];
    for (var item in items) serializedItems.add(item.m.toMap());

    return {
      'title': title,
      'items': serializedItems,
    };
  }

  // Removes only the checked items
  void removeCheckedItems() => items.removeWhere((item) => item.m.checked);
}

class _CategoryView extends State<ListCategory> {
  @override
  void initState() {
    super.initState();

    for (var item in widget.m.items) item.m.onRemoval = onItemRemoval;
  }

  @override
  Widget build(BuildContext context) {
    // Generate the children
    List<Widget> children = <Widget>[
      // Title
      ListTile(
        title: Text(widget.m.title),
        onTap: () => setState(() => widget.m.collapsed = !widget.m.collapsed),
        trailing: IconButton(icon: Icon(Icons.more_vert), onPressed: onMenu),
      ),
    ];

    // Add items
    if (!widget.m.collapsed) children.addAll(widget.m.items);

    // Add Button
    children.add(RaisedButton.icon(
      onPressed: addItemDialog,
      label: Text('Add'),
      icon: Icon(Icons.add),
      color: Theme.of(context).accentColor, // TODO : categoryColor,
      textColor: Color(0xFFFFFFFF),
    ));

    return Dismissible(
      key: UniqueKey(),
      confirmDismiss: (dir) => confirmDialog('Remove ${widget.m.title} ?', context),
      onDismissed: (dir) => widget.m.onRemoval(widget),
        child: Card(
            child: Column(
      children: children,
    )));
  }

  // Shows the dialog to add an item
  void addItemDialog() => lineDialog(
      'New Item',
      'Item Title',
      'Please enter a title',
      context,
      ListPage.scaffoldContext,
      (input) => setState(() {
            widget.m.collapsed = false;
            widget.m.items.add(ListItem(
                ListItemModel(title: input, checked: false),
                key: UniqueKey()));
          }));

  // When the user clicks on the more button
  void onMenu() => menuDialog(widget.m.title, context, [
        MenuItem(
            'Remove checked items',
            () => setState(() => widget.m.removeCheckedItems()),
            Icons.delete_sweep),
        MenuItem(
            'Remove', () => widget.m.onRemoval(widget), Icons.delete, true),
      ]);

  // When we remove an item by a swipe
  void onItemRemoval(ListItem item) => setState(() {
        widget.m.items.remove(item);

        // Toast
        Scaffold.of(ListPage.scaffoldContext).showSnackBar(SnackBar(
          content: Text('${widget.m.title}/${item.m.title} removed'),
        ));
      });
}
