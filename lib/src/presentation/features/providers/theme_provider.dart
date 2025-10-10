//테마 컬러 변환 프로바이더
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_little_memory_diary/src/presentation/features/notifiers/theme_notifier.dart';

// 테마 뷰모델
final themeNotifierProvider = NotifierProvider<ThemeNotifier, int>(() {
  return ThemeNotifier();
});
