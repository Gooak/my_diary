import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_little_memory_diary/src/core/provider/repository_providers.dart';

class ThemeNotifier extends Notifier<int> {
  @override
  int build() {
    final themeRepository = ref.watch(themeRepositoryProvider);
    return themeRepository.getThemeMode();
  }

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

  //색상 변경
  void changeColor(int index) {
    if (state == index) return;
    state = index;
    ref.watch(themeRepositoryProvider).setThemeMode(index);
  }
}
