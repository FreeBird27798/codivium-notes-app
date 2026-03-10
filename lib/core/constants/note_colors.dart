import 'package:flutter/material.dart';

class NoteColors {
  NoteColors._();

  static const List<int> pastelPalette = [
    0xFFC8E6C9,
    0xFFFFF9C4,
    0xFFFFCDD2,
    0xFFFFE0B2,
    0xFFE1BEE7,
    0xFFFCE4EC,
    0xFFB3E5FC,
    0xFFD1C4E9,
    0xFFDCEDC8,
    0xFFFFECB3,
    0xFFB2EBF2,
    0xFFF8BBD0,
  ];

  static const List<int> darkPalette = [
    0xFF2E7D32,
    0xFFF9A825,
    0xFFC62828,
    0xFFEF6C00,
    0xFF6A1B9A,
    0xFFAD1457,
    0xFF0277BD,
    0xFF4527A0,
    0xFF558B2F,
    0xFFFF8F00,
    0xFF00838F,
    0xFFC2185B,
  ];

  static int getColor(int index) {
    return pastelPalette[index % pastelPalette.length];
  }

  static Color getTextColor(int noteColor) {
    final color = Color(noteColor);
    final brightness = ThemeData.estimateBrightnessForColor(color);
    return brightness == Brightness.light
        ? Colors.black87
        : Colors.white.withValues(alpha: 0.9);
  }

  static Color getSubtextColor(int noteColor) {
    final color = Color(noteColor);
    final brightness = ThemeData.estimateBrightnessForColor(color);
    return brightness == Brightness.light
        ? Colors.black54
        : Colors.white.withValues(alpha: 0.7);
  }
}

