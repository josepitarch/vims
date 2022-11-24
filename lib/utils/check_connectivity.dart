import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';

class CheckConnectivity {
  static Future<bool> checkConnectivity() async {
    final Connectivity connectivity = Connectivity();

    try {
      return connectivity
          .checkConnectivity()
          .then((value) => value.name != ConnectivityResult.none.name);
    } on PlatformException {
      return false;
    }
  }
}
