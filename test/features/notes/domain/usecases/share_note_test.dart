import 'package:flutter_test/flutter_test.dart';
import 'package:codivium_notes_app/features/notes/domain/usecases/share_note.dart';

void main() {
  group('ShareNote', () {
    test('should call share with formatted title and content', () async {
      String? sharedText;
      final usecase = ShareNote(
        share: (text) async {
          sharedText = text;
        },
      );

      await usecase(title: 'My Note', content: 'Some content here');

      expect(sharedText, 'My Note\n\nSome content here');
    });

    test('should handle empty title and content', () async {
      String? sharedText;
      final usecase = ShareNote(
        share: (text) async {
          sharedText = text;
        },
      );

      await usecase(title: '', content: '');

      expect(sharedText, '\n\n');
    });

    test('should preserve multiline content', () async {
      String? sharedText;
      final usecase = ShareNote(
        share: (text) async {
          sharedText = text;
        },
      );

      await usecase(title: 'Title', content: 'Line 1\nLine 2\nLine 3');

      expect(sharedText, 'Title\n\nLine 1\nLine 2\nLine 3');
    });
  });
}
