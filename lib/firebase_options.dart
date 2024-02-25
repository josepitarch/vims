import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyDcN3C8FtbQPfwRrEHexd6mEAnJUjEhADM',
    appId: '1:938335500353:android:15ffadd054e647a19b6ec0',
    messagingSenderId: '938335500353',
    projectId: 'vims-app',
    storageBucket: 'vims-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAnm258gLA3DFQs_4Cl2SuTyz74jb8I-iU',
    appId: '1:938335500353:ios:1fd617d1a89e75cc9b6ec0',
    messagingSenderId: '938335500353',
    projectId: 'vims-app',
    storageBucket: 'vims-app.appspot.com',
    androidClientId:
        '938335500353-okabudlrvoufnp4rq44f4gnfpsn0d4k6.apps.googleusercontent.com',
    iosClientId:
        '938335500353-uk6polcsq69i8l7vi3t4862fuvcf4gt1.apps.googleusercontent.com',
    iosBundleId: 'com.jopimir.vims',
  );
}
