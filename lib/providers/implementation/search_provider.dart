import 'package:flutter/material.dart';

class SearchProvider extends ChangeNotifier {
  int tabIndex = 0;
  String search = '';

  SearchProvider() {}

  setTabIndex(int index) {
    tabIndex = index;
    notifyListeners();
  }
}
