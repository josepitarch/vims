import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vims/models/enums/platforms.dart';

final class FCMTokenDialog {
  static Future<bool> createFcmToken() {
    return FirebaseMessaging.instance
        .requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    )
        .then((value) {
      return value.authorizationStatus == AuthorizationStatus.authorized;
    });
  }
}

class JustwatchAlarmDialog extends StatefulWidget {
  const JustwatchAlarmDialog({super.key});

  @override
  State<JustwatchAlarmDialog> createState() => _JustwatchAlarmDialogState();
}

class _JustwatchAlarmDialogState extends State<JustwatchAlarmDialog> {
  final platforms = Platforms.values
      .where((e) => e.showInTopFilters)
      .map((e) => {'name': e.name, 'checked': false})
      .toList();

  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListView(
            children: platforms
                .map((e) => CheckboxListTile.adaptive(
                    title: Row(children: [
                      Image.asset('assets/justwatch/${e['name']}.jpg',
                          width: 30, height: 30),
                      Text(e['name'].toString()),
                    ]),
                    value: e['checked'] as bool,
                    onChanged: (bool? value) {
                      setState(() {
                        e['checked'] = value!;
                      });
                    }))
                .toList()));
  }
}
