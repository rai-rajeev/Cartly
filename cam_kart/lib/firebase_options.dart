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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCWnTTEg77UrmKduofgxExNMVWdBDG8LTg',
    appId: '1:1024872019784:android:6e748a00d22dc41868657d',
    messagingSenderId: '1024872019784',
    projectId: 'campus-catalogue-bd94d',
    databaseURL: 'https://campus-catalogue-bd94d-default-rtdb.firebaseio.com',
    storageBucket: 'campus-catalogue-bd94d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDOfDc-SVHgmRmDmNBv4dDIPFOqUuGp3cc',
    appId: '1:1024872019784:ios:47f0e5bc6b67299b68657d',
    messagingSenderId: '1024872019784',
    projectId: 'campus-catalogue-bd94d',
    databaseURL: 'https://campus-catalogue-bd94d-default-rtdb.firebaseio.com',
    storageBucket: 'campus-catalogue-bd94d.appspot.com',
    androidClientId: '1024872019784-c9fja8i2uf87mh9vjncb1teaulcmkek4.apps.googleusercontent.com',
    iosClientId: '1024872019784-kk79l46m9volv2hu3is0g4jbug2dsfjk.apps.googleusercontent.com',
    iosBundleId: 'com.example.camKart',
  );
}