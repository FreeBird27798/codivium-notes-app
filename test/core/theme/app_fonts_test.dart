import 'package:flutter_test/flutter_test.dart';
import 'package:codivium_notes_app/core/theme/app_fonts.dart';

void main() {
  group('AppFonts', () {
    test('availableFonts should contain Poppins', () {
      expect(AppFonts.availableFonts.contains('Poppins'), true);
    });

    test('availableFonts should have 5 fonts', () {
      expect(AppFonts.availableFonts.length, 5);
    });
  });
}
