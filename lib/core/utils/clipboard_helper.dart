import 'package:flutter/services.dart';

typedef CopyFunction = Future<void> Function(String text);

class ClipboardHelper {
  final CopyFunction _copy;

  ClipboardHelper({CopyFunction? copy}) : _copy = copy ?? _defaultCopy;

  static Future<void> _defaultCopy(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  Future<bool> copy(String text) async {
    try {
      await _copy(text);
      return true;
    } catch (_) {
      return false;
    }
  }
}
