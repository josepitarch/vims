import 'package:flutter/cupertino.dart';

class CupertinoCustomTheme {
  static CupertinoThemeData cupertinoTheme = const CupertinoThemeData()
      .copyWith(
          barBackgroundColor: CupertinoColors.black,
          scaffoldBackgroundColor: CupertinoColors.black,
          textTheme: const CupertinoTextThemeData());
}
