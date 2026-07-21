# Codivium

A notes app built with Flutter — create, organize, and manage notes with to-dos, calendar views, search, and customizable themes.

## Features

- **Notes:** create, edit, delete, favorite, and sort notes by importance; rich text formatting toolbar; to-do lists within notes; share notes
- **Calendar:** browse notes by date or date range, filter by category, horizontal date picker
- **Search:** full-text search across notes
- **Settings:** light/dark theme toggle, font picker

## Tech Stack

- **State management:** `flutter_bloc`, `get` (routing/utilities), `equatable`
- **Storage:** `sqflite` (local SQLite database)
- **Dependency injection:** `get_it`
- **Error handling:** `dartz` (Either)
- **Fonts:** `google_fonts`
- **Utilities:** `intl`, `uuid`, `share_plus`, `shared_preferences`, `path_provider`
- **Testing:** `mockito`, `bloc_test`, `sqflite_common_ffi`

## Architecture

Clean Architecture, organized by feature:

```
lib/
├── core/
│   ├── constants/     # app strings, DB constants, note colors
│   ├── database/      # sqflite database helper
│   ├── di/            # get_it dependency injection
│   ├── error/         # failures
│   ├── routes/        # app routing
│   ├── theme/         # theme & fonts
│   └── utils/         # clipboard, date formatting helpers
├── features/
│   ├── notes/
│   ├── calendar/
│   ├── search/
│   └── settings/
│       ├── data/          # datasources, models, repositories (impl)
│       ├── domain/        # entities, repositories (contracts), usecases
│       └── presentation/  # bloc, screens, widgets
├── app.dart
└── main.dart
```

Each feature follows the standard data → domain → presentation split, with BLoC managing presentation state and `get_it` wiring dependencies.

## Getting Started

```bash
flutter pub get
flutter run
```

Run tests:

```bash
flutter test
```
