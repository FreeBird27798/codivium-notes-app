import 'package:dartz/dartz.dart';
import 'package:codivium_notes_app/features/search/data/datasources/search_local_datasource.dart';
import 'package:codivium_notes_app/features/notes/domain/entities/note.dart';
import 'package:codivium_notes_app/features/search/domain/repositories/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchLocalDatasource localDatasource;

  SearchRepositoryImpl({required this.localDatasource});

  @override
  Future<Either<Exception, List<Note>>> searchNotes(String query) async {
    throw UnimplementedError();
  }
}

