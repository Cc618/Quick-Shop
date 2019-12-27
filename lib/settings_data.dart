// All the data to be saved in the settings file

import 'dart:convert';
import 'package:flutter/material.dart';
import 'main.dart';

class Settings {
  // Returns the color data
  static MaterialColor get primaryColor {
    switch (primaryColorName) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.yellow;
      case 'purple':
      default:
        return Colors.purple;
    }
  }

  // ID for primaryColor
  static String primaryColorName = 'purple';

  // Loads the settings with the JSON data
  static void load(String jsonData) {
    // Convert json
    var data = jsonDecode(jsonData);

    primaryColorName = data['primaryColor'];

    // Reload the app
    QuickShopState.reload();
  }

  // Serializes the attributes to JSON data
  static String toJson() {
    var data = {
      'primaryColor': primaryColorName
    };

    return jsonEncode(data);
  }
}
