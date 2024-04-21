import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

final class DeviceInfo {
  static getDeviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return await deviceInfoPlugin.androidInfo;
      case TargetPlatform.iOS:
        return await deviceInfoPlugin.iosInfo;
      default:
        throw UnsupportedError(
          'DeviceInfo is not supported for this platform.',
        );
    }
  }
}
