// IO related functions

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'list.dart';
import 'settings_data.dart';
import 'props.dart';

// Whether initIO has been called
bool ioInitialized = false;

Directory _appDir;
Directory _listsDir;

Future<void> initIO() async {
  // Init folders
  _appDir = await getApplicationDocumentsDirectory();
  _listsDir = Directory(_appDir.path + '/lists');
  await _listsDir.create();

  // Init settings
  var settings = File(_appDir.path + '/settings');

  if (await settings.exists())
    Settings.load(await settings.readAsString());
  else
    saveSettings(Settings.toJson());


  ioInitialized = true;
}

// Return all list names
Future<List<String>> listLists() async {
  List<String> lists = [];
  var stream = await _listsDir.list().toList();

  stream.sort((a, b)
    => -File(a.path).lastModifiedSync().compareTo(File(b.path).lastModifiedSync())
  );

  // Append all names
  for (var list in stream)
    lists.add(list.path.substring(list.path.lastIndexOf('/') + 1));

  return lists;
} 

// Write list file json data
Future<void> writeListFile(ListModel list) async {
  if (isListNameValid(list.title)) {
    try {
      // Write to the file the data
      await File(_listsDir.path + '/' + list.title).writeAsString(list.toJson());
    } catch (e) {}
  }
}

// Read list file json data
Future<ListModel> readListFile(String listName) async {
  if (isListNameValid(listName)) {
    try {
      var file = File(_listsDir.path + '/' + listName);

      // Read raw data
      String jsonData = await file.readAsString();

      return ListModel.fromJson(listName, jsonData);
    } catch (e) {
      return null;
    }
  }

  return null;
}

Future<void> removeListFile(String listName) async
  => await File(_listsDir.path + '/' + listName).delete();

// Checks whether the list exists
Future<bool> listExists(String title) async {
  return await File(_listsDir.path + '/' + title).exists();
}

Future<void> renameListFile(String listName, String newName, void Function() onInvalidName) async
{
  if (isListNameValid(newName))
    await File(_listsDir.path + '/' + listName).rename(_listsDir.path + '/' + newName);
  else
    onInvalidName();
}

Future<void> saveSettings(String jsonData) async {
  try {
    // Write to the file the data
    File(_appDir.path + '/settings').writeAsString(jsonData);
  } catch (e) {}
}

// Removes all lists
// !!! No confirm dialog + No app reload
Future<void> deleteLists() async {
  var lists = await _listsDir.list().toList();
  for (var file in lists)
    await file.delete();
}
