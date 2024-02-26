import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:my_diary/Home.dart';
import 'package:my_diary/firebase_options.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_diary/view/login_page.dart/singIn_page.dart';
import 'package:my_diary/view/mainPage/calendar/my_calendar.dart';
import 'package:my_diary/view/mainPage/diary/my_diary.dart';
import 'package:my_diary/view/mainPage/mypage/my_page.dart';
import 'package:my_diary/viewModel/calendar_view_model.dart';
import 'package:my_diary/viewModel/diary_view_model.dart';
import 'package:my_diary/viewModel/user_view_model.dart';
import 'package:provider/provider.dart';

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
  configLoading();
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      MobileAds.instance.initialize();
      runApp(const MyApp());
    },
    (error, stack) => FirebaseCrashlytics.instance.recordError(
      error,
      stack,
      fatal: true,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, AsyncSnapshot<User?> userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          // 인증 상태 변경을 기다립니다.
          return const CircularProgressIndicator();
        } else {
          final email = userSnapshot.data?.email;
          return MultiProvider(
            providers: [
              // ChangeNotifierProvider<UserProvider>(create: (context) => UserProvider(email.toString())),
              ChangeNotifierProvider.value(
                value: UserProvider(email.toString()),
              ),
              ChangeNotifierProvider<CalendarViewModel>(create: (context) => CalendarViewModel()),
              ChangeNotifierProvider<DiaryViewModel>(create: (context) => DiaryViewModel()),
            ],
            child: MaterialApp(
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
              home: userSnapshot.hasData
                  ? Consumer<UserProvider>(
                      builder: (context, provider, child) {
                        if (provider.user == null || provider.user!.email == null) {
                          return const Scaffold(
                            body: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else {
                          return const Home();
                        }
                      },
                    )
                  : const SigninPage(),
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
            ),
          );
        }
      },
    );
  }
}
