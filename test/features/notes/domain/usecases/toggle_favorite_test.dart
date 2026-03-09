import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:codivium_notes_app/features/notes/domain/usecases/toggle_favorite.dart';
import '../../../../helpers/test_helpers.mocks.dart';

void main() {
  late MockNotesRepository mockRepository;
  late ToggleFavorite usecase;

  setUp(() {
    mockRepository = MockNotesRepository();
    usecase = ToggleFavorite(mockRepository);
  });

  group('ToggleFavorite', () {
    test('should toggle favorite via the repository', () async {
      when(mockRepository.toggleFavorite('note_1')).thenAnswer((_) async => const Right(null));

      final result = await usecase('note_1');

      expect(result, const Right(null));
      verify(mockRepository.toggleFavorite('note_1')).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}

