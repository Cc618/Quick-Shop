// Properties related functions

import 'package:flutter/material.dart';

// Returns the color from the id
MaterialColor deserializeColor(String id) {
  if (id == null)
    return null;

  switch (id) {
    case 'red':
      return Colors.red;
    case 'blue':
      return Colors.blue;
    case 'green':
      return Colors.green;
    case 'yellow':
      return Colors.yellow;
    case 'white':
      return Colors.grey;
    case 'purple':
    default:
      return Colors.purple;
  }
}
