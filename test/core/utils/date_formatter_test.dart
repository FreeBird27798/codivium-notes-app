import 'package:flutter_test/flutter_test.dart';
import 'package:codivium_notes_app/core/utils/date_formatter.dart';

void main() {
  group('DateFormatter', () {
    test('format should return a formatted date string', () {
      final date = DateTime(2025, 1, 15);
      final result = DateFormatter.format(date);
      expect(result, isNotEmpty);
    });

    test('formatWithTime should return a formatted date with time', () {
      final date = DateTime(2025, 1, 15, 14, 30);
      final result = DateFormatter.formatWithTime(date);
      expect(result, isNotEmpty);
    });
  });
}

