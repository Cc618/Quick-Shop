import 'package:flutter/material.dart';
import 'package:quick_shop/menu.dart';
import 'list.dart';
import 'files.dart';
import 'sample_data.dart';

// TODO
// String currentListName = 'sample';
// ListPage(ListModel.fromJson('My First List', sampleData)),

void main() => runApp(QuickShop());

// App entry
class QuickShop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
        return MaterialApp(
      title: 'Quick Shop',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: ListMenu()
    );
  }
}
