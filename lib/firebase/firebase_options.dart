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
    apiKey: 'AIzaSyBpDJJB0ikWhNYdK1Am_erRvVA24iH-deg',
    appId: '1:145266609486:web:0ffed495aad7c1fb98221f',
    messagingSenderId: '145266609486',
    projectId: 'prominent-ch03',
    authDomain: 'prominent-ch03.firebaseapp.com',
    storageBucket: 'prominent-ch03.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCjUFvq77VIuTt8tfzFaA3SNSEnYsu8gO8',
    appId: '1:145266609486:android:04f3e815d6f66a2a98221f',
    messagingSenderId: '145266609486',
    projectId: 'prominent-ch03',
    storageBucket: 'prominent-ch03.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDT-u_KM8B3LEI3pe7nSyH8Tu72QoTtZHw',
    appId: '1:145266609486:ios:d03b1eb35424e34898221f',
    messagingSenderId: '145266609486',
    projectId: 'prominent-ch03',
    storageBucket: 'prominent-ch03.appspot.com',
    iosBundleId: 'com.example.prominent',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDT-u_KM8B3LEI3pe7nSyH8Tu72QoTtZHw',
    appId: '1:145266609486:ios:4723cadf3b4cee4898221f',
    messagingSenderId: '145266609486',
    projectId: 'prominent-ch03',
    storageBucket: 'prominent-ch03.appspot.com',
    iosBundleId: 'com.example.prominent.RunnerTests',
  );
}
