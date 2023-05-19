import 'package:flutter/foundation.dart';

abstract class BaseProvider<T> extends ChangeNotifier {
  late T data;
  bool isLoading = false;
  Exception? exception;

  BaseProvider();
}
