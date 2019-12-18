// The menu where we display the list of shopping lists

import 'package:flutter/material.dart';
import 'package:quick_shop/sample_data.dart';
import 'list.dart';
import 'files.dart';

class ListMenu extends StatefulWidget {
  ListMenu({Key key}) : super(key: key);

  @override
  _MenuView createState() => _MenuView();
}

class _MenuView extends State<ListMenu> {
  List<Widget> lists = [];

  @override
  Widget build(BuildContext context) {
    if (!ioInitialized)
      initIO().then((_) async {
        // writeListFile(ListModel.fromJson('Sample', sampleData));
        // writeListFile(ListModel.fromJson('First', sampleData));
        // writeListFile(ListModel.fromJson('Empty', '{}'));
        // print((await readListFile('sample')).toJson());

        List<String> listNames = await listLists();

        setState(() {
          for (var list in listNames)
            lists.add(Card(
                child: ListTile(
                  title: Text(list),
                  onTap: () => loadList(list),
                  trailing: Icon(Icons.arrow_forward_ios), // TODO : More menu with delete
            )));
        });
      });

    return Scaffold(
      appBar: AppBar(
        title: Text('My Lists'),
      ),
      body: ListView.builder(
        itemBuilder: (context, i) => lists[i],
        itemCount: lists.length,
      ),
    );
  }

  // Loads a list and display it
  Future<void> loadList(String title) async {
    var listModel = await readListFile(title);

    await Navigator.push(context, MaterialPageRoute(
      builder: (context) => ListPage(listModel)
    ));
  }
}
