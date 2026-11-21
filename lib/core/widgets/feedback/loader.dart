import 'package:flutter/foundation.dart';

abstract final class Loader {
  static final _count = ValueNotifier<int>(0);

  static ValueListenable<int> get count => _count;

  static bool get isShowing => _count.value > 0;

  static void show() => _count.value++;

  static void hide() {
    if (_count.value > 0) _count.value--;
  }
}
