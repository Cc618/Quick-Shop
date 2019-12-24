// The settings page

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quick_shop/color_picker.dart';
import 'settings_data.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsView createState() => _SettingsView();
}

class _SettingsView extends State<SettingsPage> with WidgetsBindingObserver {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Settings.primaryColor,
      ),
      body: Builder(
        builder: (context) => ListView(
          children: <Widget>[
            Card(
              child: ListTile(
                title: Text('App color'),
                leading: ColorPicker(
                  onColorSelect: (col)
                    => setState(() => Settings.primaryColor = col.color),
                  colors: [
                    ColorEntry(
                      id: 'Red',
                      color: Colors.red
                    ),
                    ColorEntry(
                      id: 'Purple',
                      color: Colors.purple
                    ),
                    ColorEntry(
                      id: 'Blue',
                      color: Colors.blue
                    ),
                    ColorEntry(
                      id: 'Green',
                      color: Colors.green
                    ),
                    ColorEntry(
                      id: 'Yellow',
                      color: Colors.yellow
                    ),
                  ],  
                )
              )
            )
          ],
        )
      )
    );
  }

  // TODO : Save data
  Future<void> save()
  {

  }
}
