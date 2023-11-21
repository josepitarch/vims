import 'package:flutter/material.dart';
import 'package:vims/ui/cupertino_theme.dart';
import 'package:vims/ui/text_theme_custom.dart';

class MaterialTheme {
  static ThemeData materialTheme = ThemeData.dark().copyWith(
    primaryColor: Colors.orange,
    colorScheme: const ColorScheme.dark().copyWith(
      primary: Colors.orange,
      secondary: Colors.blue,
      onSecondary: Colors.grey.shade200,
    ),
    textTheme: const TextTheme(
      displayLarge: TextThemeCustom.displayLarge,
      displayMedium: TextThemeCustom.displayMedium,
      displaySmall: TextThemeCustom.displaySmall,
      headlineMedium: TextThemeCustom.headlineMedium,
      headlineSmall: TextThemeCustom.headlineSmall,
      titleLarge: TextThemeCustom.titleLarge,
      bodyLarge: TextThemeCustom.bodyLarge,
      bodyMedium: TextThemeCustom.bodyMedium,
    ),
    cupertinoOverrideTheme: CupertinoCustomTheme.cupertinoTheme,
    scaffoldBackgroundColor: Colors.grey[900],
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: Colors.grey.shade200,
      backgroundColor: Colors.orange.shade400,
      elevation: 0,
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.red,
      textTheme: ButtonTextTheme.normal,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.black.withOpacity(0.2),
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      prefixIconColor: Colors.grey,
      suffixIconColor: Colors.grey,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.orange),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.red),
      ),
      labelStyle: const TextStyle(color: Colors.grey),
      hintStyle: const TextStyle(color: Colors.grey),
      errorStyle: const TextStyle(color: Colors.red),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      contentTextStyle: TextStyle(color: Colors.white),
    ),
  );
}
