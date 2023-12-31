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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA5f3yD4O354HUConV_Eog-B54AxXAiCh0',
    appId: '1:483043320756:android:7e5afa00925ab0750188e1',
    messagingSenderId: '483043320756',
    projectId: 'gaff-15c42',
    storageBucket: 'gaff-15c42.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAapvqSJBljjl5IRbrz9ZUkHhhCsJ9_xac',
    appId: '1:483043320756:ios:466a69f5f24807930188e1',
    messagingSenderId: '483043320756',
    projectId: 'gaff-15c42',
    storageBucket: 'gaff-15c42.appspot.com',
    androidClientId: '483043320756-uo8imlm471octdv2t3babfunstmiqd8p.apps.googleusercontent.com',
    iosClientId: '483043320756-qfqm2v4c5h4d4s9mo2ff3jtrgejaulrf.apps.googleusercontent.com',
    iosBundleId: 'com.example.gaff',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAapvqSJBljjl5IRbrz9ZUkHhhCsJ9_xac',
    appId: '1:483043320756:ios:2fb597af09acc9210188e1',
    messagingSenderId: '483043320756',
    projectId: 'gaff-15c42',
    storageBucket: 'gaff-15c42.appspot.com',
    androidClientId: '483043320756-uo8imlm471octdv2t3babfunstmiqd8p.apps.googleusercontent.com',
    iosClientId: '483043320756-vr31bdud4fs7icusnqvq74ar595o4q6b.apps.googleusercontent.com',
    iosBundleId: 'com.example.gaff.RunnerTests',
  );
}
