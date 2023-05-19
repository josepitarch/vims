import 'package:flutter/foundation.dart';

class BaseProvider<T> extends ChangeNotifier {
  T? data;
  bool isLoading = false;
  bool hasError = false;

  BaseProvider(T data) {
    data = data;
    isLoading = false;
    hasError = false;
  }
}
