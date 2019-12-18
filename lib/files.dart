// IO related functions

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'list.dart';
import 'sample_data.dart';

// Whether initIO has been called
bool ioInitialized = false;

Directory _appDir;
Directory _listsDir;

Future<void> initIO() async {
  _appDir = await getApplicationDocumentsDirectory();
  _listsDir = Directory(_appDir.path + '/lists');
  await _listsDir.create();

  ioInitialized = true;
}

// Return all list names
Future<List<String>> listLists() async {
  List<String> lists = [];
  var stream = await _listsDir.list().toList();

  // Append all names
  for (var list in stream)
    lists.add(list.path.substring(list.path.lastIndexOf('/') + 1));

  return lists;
} 

// Write list file json data
Future<void> writeListFile(ListModel list) async {
  try {
    // Write to the file the data
    await File(_listsDir.path + '/' + list.title).writeAsString(list.toJson());
  } catch (e) {}
}

// Read list file json data
Future<ListModel> readListFile(String listName) async {
  try {
    var file = File(_listsDir.path + '/' + listName);

    // Read raw data
    String jsonData = await file.readAsString();

    return ListModel.fromJson(listName, jsonData);
  } catch (e) {}
}
