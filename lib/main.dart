import 'package:flutter/material.dart';
import 'package:quick_shop/menu.dart';
import 'settings_data.dart';

void main() => runApp(QuickShop());

// App entry
class QuickShop extends StatefulWidget {
  @override
  State<StatefulWidget> createState()
    => QuickShopState();
}

class QuickShopState extends State<QuickShop> {
  static QuickShopState _instance;

  QuickShopState() {
    _instance = this;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quick Shop',
      theme: ThemeData(
        primarySwatch: Settings.primaryColor
      ),
      home: ListMenu()
    );
  }

  // To reload settings
  static void reload()
    => _instance.setState(() {});
}
