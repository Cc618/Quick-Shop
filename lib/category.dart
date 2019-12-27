// A category handle items

import 'package:flutter/material.dart';
import 'color_picker.dart';
import 'item.dart';
import 'list.dart';
import 'dialogs.dart';
import 'props.dart';

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
  String colorId;

  MaterialColor get color
    => deserializeColor(colorId);

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
    colorId = data['color'];

    items = [];
    for (var item in data['items'])
      items.add(ListItem(
        ListItemModel.fromMap(item),
      ));

    // Not collapsed by default
    collapsed = false;
  }

  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> serializedItems = [];
    for (var item in items)
      serializedItems.add(item.m.toMap());

    return {
      'title': title,
      'items': serializedItems,
      'color': colorId,
    };
  }

  // Removes only the checked items
  void removeCheckedItems() => items.removeWhere((item) => item.m.checked);
}

class _CategoryView extends State<ListCategory> {
  // Whether all color properties have been parsed
  bool colorInitialized = false;
  // For no color
  bool isColored;
  // Header color
  Color color;
  // Text + icon color
  Color textColor;
  // Add item button background color
  Color accent;

  @override
  void initState() {
    super.initState();

    for (var item in widget.m.items) item.m.onRemoval = onItemRemoval;
  }

  @override
  Widget build(BuildContext context) {
    // Set colors if there are not initialized
    if (!colorInitialized) {
      // This colors
      isColored = widget.m.colorId != null;
      color = isColored ? widget.m.color.shade400 : Colors.white;
      textColor = isColored ? Colors.white : Theme.of(context).textTheme.button.color;
      accent = isColored ? color : Theme.of(context).accentColor;

      // Items colors
      for (var item in widget.m.items)
        item.m.color = accent;

      colorInitialized = true;
    }

    // Generate the children
    List<Widget> children = <Widget>[
      // Title
      Container(
        color: color,
        child: ListTile(
          title: Text(
            widget.m.title,
            style: TextStyle(
              color: textColor
            )
          ),
          onTap: () => setState(() => widget.m.collapsed = !widget.m.collapsed),
          trailing: IconButton(
            color: textColor,
            icon: Icon(Icons.more_vert),
            onPressed: onMenu
          ),
        ),
      )
    ];

    // Add items
    if (!widget.m.collapsed) children.addAll(widget.m.items);

    // Add Button
    children.add(RaisedButton.icon(
      onPressed: addItemDialog,
      label: Text('Add'),
      icon: Icon(Icons.add),
      color: accent,
      textColor: Colors.white,
    ));

    return Dismissible(
      key: UniqueKey(),
      confirmDismiss: (dir) => confirmDialog('Remove ${widget.m.title} ?', context),
      onDismissed: (dir) => widget.m.onRemoval(widget),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0)
          ),
          child: Column(
            children: children,
          )
        )
      );
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
                ListItemModel(
                  title: input,
                  checked: false,
                  color: widget.m.color
                ),
                key: UniqueKey()));
          }));

  // When the user clicks on the more button
  Future<void> onMenu() async {
    bool colorize = false;
    
    await menuDialog(widget.m.title, context, [
      MenuItem(
        'Change Color',
        () => colorize = true,
        Icons.colorize
      ),
      MenuItem(
          'Remove checked items',
          () => setState(() => widget.m.removeCheckedItems()),
          Icons.delete_sweep),
      MenuItem(
          'Remove', () => widget.m.onRemoval(widget), Icons.delete, true),
    ]);

    if (colorize) {
      var color = await pickColor(context, [
        'white',
        'red',
        'purple',
        'blue',
        'green',
      ]);

      if (color != null)
        setState(() {
          widget.m.colorId = color == 'white' ? null : color;

          // To update generated color values
          colorInitialized = false;
        });
    }
  }

  // When we remove an item by a swipe
  void onItemRemoval(ListItem item) => setState(() {
        widget.m.items.remove(item);

        // Toast
        Scaffold.of(ListPage.scaffoldContext).showSnackBar(SnackBar(
          content: Text('${widget.m.title}/${item.m.title} removed'),
        ));
      });
}
