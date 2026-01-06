import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'Web platform is not supported yet',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'iOS platform is not configured yet',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'macOS platform is not supported',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'Windows platform is not supported',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'Linux platform is not supported',
        );
      default:
        throw UnsupportedError(
          'This platform is not supported',
        );
    }
  }

  static final FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBvkn4nIgkbvYzw6dRWbdl0_L5bm6K4s_Q',
    appId: '1:732149306408:android:1c38e9c941428b77e4d11d',
    messagingSenderId: '732149306408',
    projectId: 'murpheys09z',
    storageBucket: 'murpheys09z.firebasestorage.app',
  );
}
