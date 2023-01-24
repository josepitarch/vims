import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class L10n {
  static const supportedLocales = [Locale('es')];

  static const localizationsDelegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static Locale? Function(Locale?, Iterable<Locale>)? localeResolutionCallback =
      (locale, supportedLocales) => supportedLocales.firstWhere(
          (supportedLocale) =>
              supportedLocale.languageCode == locale?.languageCode,
          orElse: () => supportedLocales.first);
}
