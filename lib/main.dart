import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_little_memory_diary/app_gate.dart';
import 'package:my_little_memory_diary/app_route.dart';
import 'package:my_little_memory_diary/src/core/constants.dart';
import 'package:my_little_memory_diary/src/presentation/features/providers/theme_provider.dart';
import 'package:my_little_memory_diary/src/data/local/open_hive.dart';
import 'package:my_little_memory_diary/src/core/services/package_info.dart';
import 'package:my_little_memory_diary/src/presentation/common/widgets/upgrader_message.dart';
import 'package:my_little_memory_diary/firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await dotenv.load(fileName: ".env");
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      await Upgrader.clearSavedSettings();
      await OpenHive.openHive();
      await PackageInfoService.packageInfo();
      runApp(
        const ProviderScope(
          child: MyApp(),
        ),
      );
    },
    (error, stack) => FirebaseCrashlytics.instance.recordError(
      error,
      stack,
      fatal: true,
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeColor = ref.watch(themeNotifierProvider);

    return UpgradeAlert(
      upgrader: Upgrader(
        messages: AppUpgradeMessages(),
      ),
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'Nanum',
          useMaterial3: true,
          colorSchemeSeed:
              ref.read(themeNotifierProvider.notifier).colors(themeColor),
        ),
        darkTheme: ThemeData(
          fontFamily: 'Nanum',
          useMaterial3: true,
          colorSchemeSeed:
              ref.read(themeNotifierProvider.notifier).colors(themeColor),
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
              Uri.parse(appStoreUrl!),
              mode: LaunchMode.externalNonBrowserApplication,
            );
            return true;
          },
          upgrader: Upgrader(
            messages: AppUpgradeMessages(),
          ),
          child: AuthGate(),
        ),
        initialRoute: '/',
        onGenerateRoute: AppRouter.onGenerateRoute,
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
}
