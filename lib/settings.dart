// The settings page

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quick_shop/color_picker.dart';
import 'package:quick_shop/main.dart';
import 'settings_data.dart';
import 'files.dart';
import 'dialogs.dart';

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
                    => setState(() => Settings.primaryColorName = col.id),
                  colors: [
                    ColorEntry(
                      id: 'red',
                      color: Colors.red
                    ),
                    ColorEntry(
                      id: 'purple',
                      color: Colors.purple
                    ),
                    ColorEntry(
                      id: 'blue',
                      color: Colors.blue
                    ),
                    ColorEntry(
                      id: 'green',
                      color: Colors.green
                    ),
                    ColorEntry(
                      id: 'yellow',
                      color: Colors.yellow
                    ),
                  ],  
                )
              )
            ),
            Card(
              child: FlatButton(
                onPressed: () async {
                  if (await confirmDialog('Delete All Lists ?', context))
                  {
                    await deleteLists();
                    Navigator.pop(context, 'update_lists');
                  }
                },
                child: Text(
                  'Delete Lists',
                  style: TextStyle(color: Theme.of(context).errorColor),
                ),
              ),  
            )
          ],
        )
      )
    );
  }

  Future<void> save()
    => saveSettings(Settings.toJson());
}
