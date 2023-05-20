import 'package:flutter/foundation.dart';

abstract class BaseProvider<T> extends ChangeNotifier {
  late T data;
  bool isLoading;
  Exception? exception;

  BaseProvider({required this.data, this.isLoading = false});

  onRefresh();
}
