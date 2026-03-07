import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:codivium_notes_app/core/routes/app_routes.dart';
import 'package:codivium_notes_app/core/theme/app_theme.dart';
import 'package:codivium_notes_app/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:codivium_notes_app/features/settings/presentation/bloc/settings_state.dart';
import 'package:codivium_notes_app/core/di/injection_container.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SettingsBloc>(),
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return GetMaterialApp(
            title: 'Codivium Notes',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            initialRoute: notesListScreen,
            getPages: appRoutes(),
          );
        },
      ),
    );
  }
}

