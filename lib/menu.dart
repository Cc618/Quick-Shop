// The menu where we display the list of shopping lists

import 'package:flutter/material.dart';
import 'package:quick_shop/main.dart';
import 'package:quick_shop/settings.dart';
import 'package:quick_shop/settings_data.dart';
import 'dialogs.dart';
import 'files.dart';
import 'list.dart';
import 'package:url_launcher/url_launcher.dart';

class ListMenu extends StatefulWidget {
  ListMenu({Key key}) : super(key: key);

  @override
  _MenuView createState() => _MenuView();
}

enum _MoreMenuEntries {
  settings,
  about
}

class _MenuView extends State<ListMenu> {
  List<Widget> lists = [];

  BuildContext _scaffoldContext;

  final listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    if (!ioInitialized)
      initIO().then((_) => updateLists());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Settings.primaryColor,
        title: Text('My Lists'),
        actions: <Widget>[
          PopupMenuButton<_MoreMenuEntries>(
            onSelected: (sel) {
              switch (sel) {
                case _MoreMenuEntries.settings:
                  displaySettings();
                  break;

                case _MoreMenuEntries.about:
                  displayAbout();
                  break;
              }
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem<_MoreMenuEntries>(
                value: _MoreMenuEntries.settings,
                child: Text('Settings'),
              ),
              const PopupMenuItem<_MoreMenuEntries>(
                value: _MoreMenuEntries.about,
                child: Text('About'),
              ),
            ]
          )
        ],
      ),
      body: Builder(builder: (scaffoldContext) {
        _scaffoldContext = scaffoldContext;

      return ListView.builder(
          itemBuilder: (context, i) => lists[i],
          itemCount: lists.length,
        );

        // TODO : Implement animated list
        // return AnimatedList(
        //   key: listKey,
        //   itemBuilder: (context, i, anim) => SizeTransition(
        //     sizeFactor: anim,
        //     axis: Axis.vertical,
        //     child: lists[i],
        //   ),
        //   initialItemCount: lists.length,
        // );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createList(),
        child: Icon(Icons.add),
      ),
    );
  }

  // Loads a list and display it
  Future<void> loadList(String title) async {
    var listModel = await readListFile(title);

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ListPage(listModel)));
  }

  // Loads all list files in the view
  Future<void> updateLists() async {
    lists = [];
    List<String> listNames = await listLists();

    setState(() {
      for (var list in listNames)
        lists.add(
          Dismissible(
          key: UniqueKey(),
          onDismissed: (dir) => removeListFile(list),
          confirmDismiss: (dir) => confirmDialog('Remove $list ?', context),
          child: Card(
            child: ListTile(
          title: Text(list),
          onTap: () => loadList(list),
          onLongPress: () => showListMenu(list),
          trailing: Icon(Icons.arrow_forward_ios),
          )
        )));
    });
  }

  void createList() => lineDialog('New List', 'List Title',
          'Please enter a title', context, _scaffoldContext, (title) async {
        if (!await listExists(title)) {
          await writeListFile(ListModel(title: title, categories: []));
          await updateLists();
          setState(() {});
          loadList(title);
        }
      });

  // When we long tap a list
  Future<void> showListMenu(String title) async {
    bool rename = false;

    await menuDialog(title, context, [
      MenuItem('Rename', () => rename = true, Icons.edit, false),
      MenuItem('Remove', () async {
        await removeListFile(title);
        await updateLists();
      }, Icons.delete, true),
    ]);

    if (rename)
      await lineDialog('Rename', 'New title', 'Please select a new title',
          context, _scaffoldContext, (input) async {
        await renameListFile(title, input);

        updateLists();
      });
  }

  Future<void> launchUrl(String url) async {
    if (await canLaunch(url))
      await launch(url);
  }

  void displayAbout()
    => showAboutDialog(
      context: context,
      applicationName: 'Quick-Shop',
      applicationVersion: '1.0',
      children: [
        Text('This application is free and open source :'),
        RaisedButton(
          child: Text('Github'),
          onPressed: () => launchUrl('https://github.com/Cc618/Quick-Shop')
        )
      ]
    );
  
  Future<void> displaySettings() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              SettingsPage()));

    if (result == 'update_lists')
      await updateLists();

    // Save
    saveSettings(Settings.toJson());

    QuickShopState.reload();
  }
}
