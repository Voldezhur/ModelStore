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
    apiKey: 'AIzaSyAV6ld0Kq1I9aCU3aUbeAMdUk5n8o-Kd4c',
    appId: '1:152441325410:web:df6531fdbce227de5f0e3b',
    messagingSenderId: '152441325410',
    projectId: 'modelstore-9db9a',
    authDomain: 'modelstore-9db9a.firebaseapp.com',
    storageBucket: 'modelstore-9db9a.firebasestorage.app',
    measurementId: 'G-SW4NXQ0LQY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAkz1eUHGLR4rN82wQ3NfqRYVdiJrK_mJY',
    appId: '1:152441325410:android:90142b88812b9a575f0e3b',
    messagingSenderId: '152441325410',
    projectId: 'modelstore-9db9a',
    storageBucket: 'modelstore-9db9a.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA8AxRL0RwEvyvMcDFc_7nMrJsMeJnjE2k',
    appId: '1:152441325410:ios:1b654a40581d9fa35f0e3b',
    messagingSenderId: '152441325410',
    projectId: 'modelstore-9db9a',
    storageBucket: 'modelstore-9db9a.firebasestorage.app',
    iosBundleId: 'com.example.modelstore',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA8AxRL0RwEvyvMcDFc_7nMrJsMeJnjE2k',
    appId: '1:152441325410:ios:1b654a40581d9fa35f0e3b',
    messagingSenderId: '152441325410',
    projectId: 'modelstore-9db9a',
    storageBucket: 'modelstore-9db9a.firebasestorage.app',
    iosBundleId: 'com.example.modelstore',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAV6ld0Kq1I9aCU3aUbeAMdUk5n8o-Kd4c',
    appId: '1:152441325410:web:f32ef983bffdb6645f0e3b',
    messagingSenderId: '152441325410',
    projectId: 'modelstore-9db9a',
    authDomain: 'modelstore-9db9a.firebaseapp.com',
    storageBucket: 'modelstore-9db9a.firebasestorage.app',
    measurementId: 'G-FXXZ6YGN2Y',
  );
}
