import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:codivium_notes_app/features/notes/presentation/screens/notes_list_screen.dart';
import 'package:codivium_notes_app/features/notes/presentation/screens/note_editor_screen.dart';
import 'package:codivium_notes_app/features/search/presentation/screens/search_screen.dart';
import 'package:codivium_notes_app/features/calendar/presentation/screens/calendar_screen.dart';
import 'package:codivium_notes_app/features/settings/presentation/screens/settings_screen.dart';

const notesListScreen = "/notesListScreen";
const noteEditorScreen = "/noteEditorScreen";
const searchScreen = "/searchScreen";
const calendarScreen = "/calendarScreen";
const settingsScreen = "/settingsScreen";

List<GetPage> appRoutes() => [
      fadeTransitionPage(
        name: notesListScreen,
        page: () => const NotesListScreen(),
      ),
      fadeTransitionPage(
        name: noteEditorScreen,
        page: () => const NoteEditorScreen(),
      ),
      fadeTransitionPage(
        name: searchScreen,
        page: () => const SearchScreen(),
      ),
      fadeTransitionPage(
        name: calendarScreen,
        page: () => const CalendarScreen(),
      ),
      fadeTransitionPage(
        name: settingsScreen,
        page: () => const SettingsScreen(),
      ),
    ];

GetPage fadeTransitionPage({
  required String name,
  required Widget Function() page,
}) {
  return GetPage(
    name: name,
    page: page,
    middlewares: [GetMiddlewareLogging()],
    transitionDuration: const Duration(milliseconds: 200),
    transition: Transition.fadeIn,
  );
}

class GetMiddlewareLogging extends GetMiddleware {
  @override
  GetPage? onPageCalled(GetPage? page) {
    log("${page?.name}");
    return super.onPageCalled(page);
  }
}

