import 'package:flutter/services.dart';

class ClipboardHelper {
  ClipboardHelper._();

  static Future<void> copy(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }
}

