// The menu where we display the list of shopping lists

import 'package:flutter/material.dart';
import 'list.dart';
import 'files.dart';
import 'dialogs.dart';

class ListMenu extends StatefulWidget {
  ListMenu({Key key}) : super(key: key);

  @override
  _MenuView createState() => _MenuView();
}

class _MenuView extends State<ListMenu> {
  List<Widget> lists = [];

  BuildContext _scaffoldContext;

  @override
  Widget build(BuildContext context) {
    if (!ioInitialized) initIO().then((_) => updateLists());

    return Scaffold(
      appBar: AppBar(
        title: Text('My Lists'),
      ),
      body: Builder(
        builder: (scaffoldContext) {
          _scaffoldContext = scaffoldContext;
          
          return ListView.builder(
            itemBuilder: (context, i) => lists[i],
            itemCount: lists.length,
          );
        }
      ),
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
        context, MaterialPageRoute(builder: (context) => ListPage(listModel)));
  }

  Future<void> updateLists() async {
    lists = [];
    List<String> listNames = await listLists();

    setState(() {
      for (var list in listNames)
        lists.add(Card(
            child: ListTile(
          title: Text(list),
          onTap: () => loadList(list),
          onLongPress: () => removeList(list),
          trailing:
              Icon(Icons.arrow_forward_ios), // TODO : More menu with delete
        )));
    });
  }

  void createList() => lineDialog(
    'New List', 'List Title', 'Please enter a title', context, _scaffoldContext,
    (title) async {
      if (!await listExists(title))
      {
        await writeListFile(ListModel(title: title, categories: []));
        await updateLists();
        setState(() {});
      }
    });
  
  Future<void> removeList(String title) => menuDialog(
    title, context, [
      MenuItem('Remove', () async {
          await removeListFile(title);
          await updateLists();

          setState(() {});
        },
        true
      )]);
}
