import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

Map<TargetPlatform, String> lastestVersionKey = {
  TargetPlatform.android: 'lastVersionAndroid',
  TargetPlatform.iOS: 'lastVersionIOS',
};

Future<String> fetchLastestVersion() async {
  final remoteConfig = FirebaseRemoteConfig.instance;
  remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(seconds: 10),
    minimumFetchInterval: const Duration(days: 7),
  ));

  try {
    await remoteConfig.fetchAndActivate();
    final String key = lastestVersionKey[defaultTargetPlatform]!;
    return remoteConfig.getString(key);
  } catch (e) {
    return '1.0.0';
  }
}
