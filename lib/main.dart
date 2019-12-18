import 'package:flutter/material.dart';
import 'list.dart';
import 'category.dart';
import 'item.dart';

void main() => runApp(QuickShop());

// TODO
String jsonList = '{"categories":[{"title":"Fruits","items":[{"title":"Bananas","checked":false},{"title":"Apples","checked":true},{"title":"Strawberries","checked":false}]}]}';

// App entry
class QuickShop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quick Shop',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: ListPage(ListModel.fromJson('First List', jsonList)),
      // home: ListPage(ListModel(
      //     title: 'First List',
      //     categories: [
      //       ListCategory(ListCategoryModel(
      //         title: 'Fruits',
      //         items: [
      //           ListItem(ListItemModel(
      //             title: 'Bananas',
      //             checked: false
      //           )),
      //           ListItem(ListItemModel(
      //             title: 'Apples',
      //             checked: true
      //           )),
      //           ListItem(ListItemModel(
      //             title: 'Strawberries',
      //             checked: false
      //           )),
      //         ],
      //         collapsed: false
      //       ))
      //     ]
      //   )),
    );
  }
}
