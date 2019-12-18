// A category handle items

import 'package:flutter/material.dart';
import 'item.dart';
import 'list.dart';
import 'dialogs.dart';

class ListCategory extends StatefulWidget {
  // Model which handles all the data
  final ListCategoryModel m;
  // When the more button is pressed
  final Function(ListCategory) onMenu;

  const ListCategory(this.m, this.onMenu, {Key key}) : super(key: key);

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
          onPressed: () => widget.onMenu(widget),
        ),
      ),
    ];

    // Add items
    if (!widget.m.collapsed)
      children.addAll(widget.m.items);

    // Add Button
    children.add(RaisedButton.icon(
      onPressed: addItemDialog,
      label: Text('Add'),
      icon: Icon(Icons.add),
      color: Theme.of(context).accentColor, // TODO : categoryColor,
      textColor: Color(0xFFFFFFFF),
    ));

    return Card(
      child: InkWell(
            onLongPress: () => widget.onMenu(widget),
            child: Column(
              children: children,
            )));
  }

  // Shows the dialog to add an item
  void addItemDialog()
    => lineDialog(
      'New Item', 'Item Title', 'Please enter a title',
      context, ListPage.scaffoldContext, (input) => setState(() {
        widget.m.collapsed = false;
        widget.m.items.add(ListItem(ListItemModel(title: input, checked: false)));
      }));

}
