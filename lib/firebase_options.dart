import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBe-qs7T7bJve1EbA2oOB0MdeWjg2eg35E',
    appId: '1:453254897016:web:5e7dac50ece5b738dbfc8d',
    messagingSenderId: '453254897016',
    projectId: 'wandersync-40edf',
    authDomain: 'wandersync-40edf.firebaseapp.com',
    storageBucket: 'wandersync-40edf.firebasestorage.app',
    measurementId: 'G-6T9M255PSM',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAuzK-PxNWYo0Bk0oLKkD8WvBbKMJTItfo',
    appId: '1:453254897016:android:b387983397f66854dbfc8d',
    messagingSenderId: '453254897016',
    projectId: 'wandersync-40edf',
    storageBucket: 'wandersync-40edf.firebasestorage.app',
  );
}
