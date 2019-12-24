
import 'package:flutter/material.dart';
import 'settings_data.dart';

class ColorEntry {
  Color color;
  String id;
  
  ColorEntry({this.id, this.color});
}

// A colored container 
class ColorItem  extends StatelessWidget {
  final double size, padding;
  final Color color;
  final Function onTap;

  const ColorItem({
    @required this.color,
    @required this.onTap,
    @required this.size,
    @required this.padding
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: size,
            height: size,
            color: color
          )
        )
      ),
    );
  }
}

class ColorPicker extends StatefulWidget {
  final List<ColorEntry> colors;
  final void Function(ColorEntry) onColorSelect;

  const ColorPicker({
    @required this.colors,
    @required this.onColorSelect,
    Key key
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ColorPickerView();
}

class _ColorPickerView extends State<ColorPicker> {
  @override
  Widget build(BuildContext context) {
    return ColorItem(
      size: 32,
      padding: 0,
      onTap: () async {
        // Build the menu items
        var entries = List<Widget>();

        for (var col in widget.colors)
          entries.add(ColorItem(
            size: 48,
            padding: 12,
            onTap: () => setState(() {
              widget.onColorSelect(col);
              Navigator.of(context).pop();
            }),
            color: col.color
          ));

        // Display dialog
        await showModalBottomSheet(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)
            ),
            context: context,
            builder: (BuildContext bc) {
              return Container(
                child: Column(
                  children: [
                    // Title
                    ListTile(
                      title: Text('Select Color'),
                    ),
                    // Colors
                    Wrap(children: entries),
                  ]
                )
              );
            });
      },
      color: Settings.primaryColor
    );
  }
}
