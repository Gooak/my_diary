import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive/hive.dart';
import 'package:my_little_memory_diary/Home.dart';
import 'package:my_little_memory_diary/common/openHive.dart';
import 'package:my_little_memory_diary/common/packageInfo.dart';
import 'package:my_little_memory_diary/common/upgraderMessage.dart';
import 'package:my_little_memory_diary/components/colorScheme.dart';
import 'package:my_little_memory_diary/firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_little_memory_diary/view/login_page.dart/emailVerifed.dart';
import 'package:my_little_memory_diary/view/login_page.dart/singIn_page.dart';
import 'package:my_little_memory_diary/view/mainPage/calendar/my_calendar.dart';
import 'package:my_little_memory_diary/view/mainPage/diary/my_diary.dart';
import 'package:my_little_memory_diary/view/mainPage/mypage/my_page.dart';
import 'package:my_little_memory_diary/viewModel/calendar_view_model.dart';
import 'package:my_little_memory_diary/viewModel/diary_view_model.dart';
import 'package:my_little_memory_diary/viewModel/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';

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
      await Upgrader.clearSavedSettings();
      await OpenHive.openHive();
      await PackageInformation.packageInfo();
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
    final box = Hive.box<int>('AppTheme');
    return UpgradeAlert(
      upgrader: Upgrader(
        messages: AppUpgradeMessages(),
      ),
      child: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, AsyncSnapshot<User?> userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            final email = userSnapshot.data?.email;
            return MultiProvider(
              providers: [
                // ChangeNotifierProvider<UserProvider>(create: (context) => UserProvider(email.toString())),
                ChangeNotifierProvider.value(value: UserProvider(email.toString())),
                ChangeNotifierProvider<CalendarViewModel>(create: (context) => CalendarViewModel()),
                ChangeNotifierProvider<DiaryViewModel>(create: (context) => DiaryViewModel()),
                ChangeNotifierProvider<SelectColor>(create: (context) => SelectColor()),
              ],
              child: Consumer<SelectColor>(builder: (context, provider, child) {
                provider.selectNumb = box.get('AppTheme') ?? 0;
                return MaterialApp(
                  builder: EasyLoading.init(),
                  theme: ThemeData(
                    fontFamily: 'Nanum',
                    useMaterial3: true,
                    colorSchemeSeed: provider.colors(provider.selectNumb!),
                  ),
                  darkTheme: ThemeData(
                    fontFamily: 'Nanum',
                    useMaterial3: true,
                    colorSchemeSeed: provider.colors(provider.selectNumb!),
                    brightness: Brightness.dark,
                  ),
                  themeMode: ThemeMode.system,
                  debugShowCheckedModeBanner: false,
                  home: UpgradeAlert(
                    showLater: false,
                    showReleaseNotes: false,
                    showIgnore: false,
                    onUpdate: () {
                      launchUrl(
                        Uri.parse('https://play.google.com/store/apps/details?id=com.my_little_memory_diary'),
                        mode: LaunchMode.externalNonBrowserApplication,
                      );
                      return true;
                    },
                    upgrader: Upgrader(
                      messages: AppUpgradeMessages(),
                    ),
                    child: userSnapshot.hasData
                        ? Consumer<UserProvider>(
                            builder: (context, provider, child) {
                              if (provider.user == null || provider.user!.email == null) {
                                return const Scaffold(
                                  body: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              } else {
                                return userSnapshot.data!.emailVerified == false ? const EmailVerified() : const Home();
                              }
                            },
                          )
                        : const SigninPage(),
                  ),
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
              }),
            );
          }
        },
      ),
    );
  }
}
