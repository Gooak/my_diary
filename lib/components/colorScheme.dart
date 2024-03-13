import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SelectColor extends ChangeNotifier {
  final box = Hive.box<int>('AppTheme');
  int? selectNumb = 0;

  final streamController = StreamController<int>();

  final colorsName = <Map<String, dynamic>>[
    {'color': Colors.red, 'number': 0},
    {'color': Colors.orange, 'number': 1},
    {'color': Colors.yellow, 'number': 2},
    {'color': Colors.green, 'number': 3},
    {'color': Colors.blue, 'number': 4},
    {'color': Colors.brown, 'number': 5},
    {'color': Colors.purple, 'number': 6},
    {'color': Colors.pink, 'number': 7},
  ];
  Color? colors(int selectNumb) {
    switch (selectNumb) {
      case 0:
        return Colors.red;
      case 1:
        return Colors.orange;
      case 2:
        return Colors.yellow;
      case 3:
        return Colors.green;
      case 4:
        return Colors.blue;
      case 5:
        return Colors.brown;
      case 6:
        return Colors.purple;
      default:
        return Colors.pink;
    }
  }

  void changedColor(int index) async {
    streamController.add(index);
    box.put('AppTheme', index);
    notifyListeners();
  }
}
