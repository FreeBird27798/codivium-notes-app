import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  await _initDatabase();
  _initNotes();
  _initSearch();
  _initCalendar();
  _initSettings();
}

Future<void> _initDatabase() async {}

void _initNotes() {}

void _initSearch() {}

void _initCalendar() {}

void _initSettings() {}

