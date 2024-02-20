import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:my_diary/firebase_options.dart';
import 'package:my_diary/root.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_diary/view/mainPage/calendar/my_calendar.dart';
import 'package:my_diary/view/mainPage/my_diary.dart';
import 'package:my_diary/view/mainPage/my_page.dart';

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  configLoading();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: EasyLoading.init(),
      theme: ThemeData(
        fontFamily: 'Nanum',
        colorSchemeSeed: const Color.fromRGBO(188, 0, 74, 1.0),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        fontFamily: 'Nanum',
        useMaterial3: true,
        colorSchemeSeed: const Color.fromRGBO(8, 32, 50, 1.0),
      ),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const Root(),
      initialRoute: '/',
      routes: {
        '/MyDiary': (context) => const MyDiary(),
        '/MyCalendar': (context) => const MyCalendar(),
        '/MyPage': (context) => const MyPage(),
      },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('ko', ''),
      ],
    );
  }
}
