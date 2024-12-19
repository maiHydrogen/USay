// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyBUWt3dTcP4zPyhndmgMmBFfhBoXlQgqCA',
    appId: '1:325242529649:web:67abf8a658ddc27c8b38d0',
    messagingSenderId: '325242529649',
    projectId: 'usay-f2cb1',
    authDomain: 'usay-f2cb1.firebaseapp.com',
    storageBucket: 'usay-f2cb1.firebasestorage.app',
    measurementId: 'G-CX3R14XBTY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBbHbktbVty7zia9KbLsEG-xUqJaHUhwfg',
    appId: '1:325242529649:android:4bb7fc1a9714cb3d8b38d0',
    messagingSenderId: '325242529649',
    projectId: 'usay-f2cb1',
    storageBucket: 'usay-f2cb1.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDDMfRrAMp4XBktSfM2-cfKnpi14I15DGw',
    appId: '1:325242529649:ios:731bd40f210148278b38d0',
    messagingSenderId: '325242529649',
    projectId: 'usay-f2cb1',
    storageBucket: 'usay-f2cb1.firebasestorage.app',
    androidClientId: '325242529649-i27k56tid910g6g3g5cs3paka9gtk51h.apps.googleusercontent.com',
    iosClientId: '325242529649-2pdd5k1u6ianik37k14gsc71u9aueork.apps.googleusercontent.com',
    iosBundleId: 'com.usay.usay',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDDMfRrAMp4XBktSfM2-cfKnpi14I15DGw',
    appId: '1:325242529649:ios:731bd40f210148278b38d0',
    messagingSenderId: '325242529649',
    projectId: 'usay-f2cb1',
    storageBucket: 'usay-f2cb1.firebasestorage.app',
    androidClientId: '325242529649-i27k56tid910g6g3g5cs3paka9gtk51h.apps.googleusercontent.com',
    iosClientId: '325242529649-2pdd5k1u6ianik37k14gsc71u9aueork.apps.googleusercontent.com',
    iosBundleId: 'com.usay.usay',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBUWt3dTcP4zPyhndmgMmBFfhBoXlQgqCA',
    appId: '1:325242529649:web:b553159fbd5a8e9b8b38d0',
    messagingSenderId: '325242529649',
    projectId: 'usay-f2cb1',
    authDomain: 'usay-f2cb1.firebaseapp.com',
    storageBucket: 'usay-f2cb1.firebasestorage.app',
    measurementId: 'G-YBBDB6CWKZ',
  );

}