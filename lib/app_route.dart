import 'package:flutter/material.dart';
import 'package:my_little_memory_diary/src/presentation/features/home.dart';
import 'package:my_little_memory_diary/src/presentation/features/main_page/calendar/my_calendar.dart';
import 'package:my_little_memory_diary/src/presentation/features/main_page/diary/my_diary.dart';
import 'package:my_little_memory_diary/src/presentation/features/main_page/mypage/my_page.dart';

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const Home());
      case '/MyDiary':
        return MaterialPageRoute(builder: (_) => const MyDiary());
      case '/MyCalendar':
        return MaterialPageRoute(builder: (_) => const MyCalendar());
      case '/MyPage':
        return MaterialPageRoute(builder: (_) => const MyPage());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('페이지를 찾을 수 없습니다.')),
          ),
        );
    }
  }
}
