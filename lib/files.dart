// IO related functions

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'list.dart';

// Whether initIO has been called
bool ioInitialized = false;

Directory _appDir;
Directory _listsDir;

Future<void> initIO() async {
  _appDir = await getApplicationDocumentsDirectory();
  _listsDir = Directory(_appDir.path + '/lists');
  await _listsDir.create();

  ioInitialized = true;

  print('IO initialized : ${_listsDir.listSync(recursive: true)}');
}

// // Write text
// Future<void> writeFile(File file, String data) async {
//   try {
//     // Write to the file the data
//     await file.writeAsString(data);
//   } catch (e) {}
// }

// // TODO : chg
// // Write text
// Future<void> writeListFile(String title, String data) async {
//   try {
//     // Write to the file the data
//     await File(_appDir.path + '/' + title).writeAsString(data);
//   } catch (e) {}
// }

// // TODO
// Future<void> tstFile() async {
//   // await File(_appDir.path + '/sample').writeAsString('Hello World');
//   // print(await File(_listsDir.path + '/sample').readAsString());
// }


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
