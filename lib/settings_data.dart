// All the data to be saved in the settings file

import 'dart:convert';
import 'package:flutter/material.dart';
import 'props.dart';
import 'main.dart';

class Settings {
  // Returns the color data
  static MaterialColor get primaryColor
    => deserializeColor(primaryColorName);

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
