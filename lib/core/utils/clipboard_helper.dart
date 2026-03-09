import 'package:flutter/services.dart';

typedef CopyFunction = Future<void> Function(String text);

class ClipboardHelper {
  final CopyFunction _copy;

  ClipboardHelper({CopyFunction? copy})
      : _copy = copy ?? _defaultCopy;

  static Future<void> _defaultCopy(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  Future<void> copy(String text) async {
    await _copy(text);
  }
}
