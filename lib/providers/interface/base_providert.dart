import 'package:flutter/foundation.dart';

abstract class BaseProvider<T> extends ChangeNotifier {
  T? data;
  bool isLoading;
  Exception? exception;

  BaseProvider({required this.data, this.isLoading = false});

  fetchData();

  onRefresh() {
    data = null;
    isLoading = true;
    exception = null;
    notifyListeners();
  }
}
