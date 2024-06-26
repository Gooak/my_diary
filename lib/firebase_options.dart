// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCwQ4h3CHu_dGHPkWaSHFvj03v6Q6pNG18',
    appId: '1:125557249109:web:c815f80573508f10eb70dc',
    messagingSenderId: '125557249109',
    projectId: 'mydiary-ddcf6',
    authDomain: 'mydiary-ddcf6.firebaseapp.com',
    storageBucket: 'mydiary-ddcf6.appspot.com',
    measurementId: 'G-7ZWP4SQRQB',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBKkMnFX2Vc2XvGnixswsaMPlaUdn5nkME',
    appId: '1:125557249109:android:cd1859cbf81d35baeb70dc',
    messagingSenderId: '125557249109',
    projectId: 'mydiary-ddcf6',
    storageBucket: 'mydiary-ddcf6.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCe10rVh_Wy_3OK27FRzezHAeMrHw1L6-g',
    appId: '1:125557249109:ios:5bc9691d8566bc2feb70dc',
    messagingSenderId: '125557249109',
    projectId: 'mydiary-ddcf6',
    storageBucket: 'mydiary-ddcf6.appspot.com',
    androidClientId: '125557249109-4th55d9pqljv66gs6ao90t3argps2ar5.apps.googleusercontent.com',
    iosClientId: '125557249109-6sl9tjaqboi95j5r3p01ou1om3b1ufj6.apps.googleusercontent.com',
    iosBundleId: 'com.myDiary',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCe10rVh_Wy_3OK27FRzezHAeMrHw1L6-g',
    appId: '1:125557249109:ios:d503b184ac85f07deb70dc',
    messagingSenderId: '125557249109',
    projectId: 'mydiary-ddcf6',
    storageBucket: 'mydiary-ddcf6.appspot.com',
    androidClientId: '125557249109-4th55d9pqljv66gs6ao90t3argps2ar5.apps.googleusercontent.com',
    iosClientId: '125557249109-bd52ui0r5kc9292umnlq4b95a0tkaem2.apps.googleusercontent.com',
    iosBundleId: 'com.myDiary.RunnerTests',
  );
}
