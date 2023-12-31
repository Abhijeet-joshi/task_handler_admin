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
    apiKey: 'AIzaSyBTz_7XYonjDabMSQghlU3alKeg573vEW8',
    appId: '1:894094696657:web:963255807b928a7337e5f0',
    messagingSenderId: '894094696657',
    projectId: 'task-manager-84abc',
    authDomain: 'task-manager-84abc.firebaseapp.com',
    storageBucket: 'task-manager-84abc.appspot.com',
    measurementId: 'G-K4VN6G59J5',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAvVNpB78JPxWT10NtVZUi1rAFpJAH2Kps',
    appId: '1:894094696657:android:b996b9bf1d47bb4137e5f0',
    messagingSenderId: '894094696657',
    projectId: 'task-manager-84abc',
    storageBucket: 'task-manager-84abc.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA2Y3KPhc6aBZdiO3KosyiWe6pGzelq2jo',
    appId: '1:894094696657:ios:7c5b0d61db82d03437e5f0',
    messagingSenderId: '894094696657',
    projectId: 'task-manager-84abc',
    storageBucket: 'task-manager-84abc.appspot.com',
    iosBundleId: 'com.abhidroid.flutterdev.taskManager',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA2Y3KPhc6aBZdiO3KosyiWe6pGzelq2jo',
    appId: '1:894094696657:ios:7c5b0d61db82d03437e5f0',
    messagingSenderId: '894094696657',
    projectId: 'task-manager-84abc',
    storageBucket: 'task-manager-84abc.appspot.com',
    iosBundleId: 'com.abhidroid.flutterdev.taskManager',
  );
}
