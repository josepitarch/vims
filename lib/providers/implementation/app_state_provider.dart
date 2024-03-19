import 'package:flutter/material.dart';

class AppStateProvider extends ChangeNotifier {
  bool _isMaintenance = false;

  bool get isMaintenance => _isMaintenance;

  void setMaintenance(bool isMaintenance) {
    _isMaintenance = isMaintenance;
    notifyListeners();
  }
}
