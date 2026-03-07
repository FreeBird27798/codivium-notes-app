import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:codivium_notes_app/features/search/presentation/bloc/search_event.dart';
import 'package:codivium_notes_app/features/search/presentation/bloc/search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitial()) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<ClearSearch>(_onClearSearch);
  }

  Future<void> _onSearchQueryChanged(SearchQueryChanged event, Emitter<SearchState> emit) async {}

  Future<void> _onClearSearch(ClearSearch event, Emitter<SearchState> emit) async {}
}

