import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CategoryUIConfig {
  static IconData iconFor(String name) {
    switch (name.toLowerCase()) {
      case 'fashion':
        return CupertinoIcons.shift;
      case 'beauty':
        return CupertinoIcons.heart;
      case 'electronics':
        return CupertinoIcons.tv;
      case 'jewellery':
        return CupertinoIcons.gift;
      case 'footwear':
        return CupertinoIcons.antenna_radiowaves_left_right;
      case 'toys':
        return CupertinoIcons.game_controller;
      case 'furniture':
        return CupertinoIcons.house;
      case 'mobiles':
        return CupertinoIcons.phone;
      default:
        return CupertinoIcons.square_grid_2x2;
    }
  }

  static Color bgColorFor(int index) {
    final colors = [
      Color(0xFF66CCFF), // blue
      Color(0xFFFFA8B8), // pink
      Color(0xFF87F2C1), // mint
      Color(0xFFFFE28A), // yellow
      Color(0xFFC9B6FF), // purple
      Color(0xFFA5DEFF), // cyan
    ];
    return colors[index % colors.length];
  }
}
