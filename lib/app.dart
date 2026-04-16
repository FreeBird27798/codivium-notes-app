import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:codivium_notes_app/core/di/injection_container.dart';
import 'package:codivium_notes_app/core/routes/app_routes.dart';
import 'package:codivium_notes_app/core/theme/app_theme.dart';
import 'package:codivium_notes_app/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:codivium_notes_app/features/settings/presentation/bloc/settings_state.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SettingsBloc>(),
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          
         ThemeMode currentThemeMode = ThemeMode.system;
          String? currentFont;

          if (state is SettingsLoaded) {
            currentThemeMode = state.settings.isDarkMode ? ThemeMode.dark : ThemeMode.light;
            currentFont = state.settings.fontFamily;
          }

          return GetMaterialApp(
            title: 'Codivium Notes',
            debugShowCheckedModeBanner: false,
            themeMode: currentThemeMode,
            theme: AppTheme.lightTheme.copyWith(
              textTheme: AppTheme.lightTheme.textTheme.apply(fontFamily: currentFont),
            ),
            darkTheme: AppTheme.darkTheme.copyWith(
              textTheme: AppTheme.darkTheme.textTheme.apply(fontFamily: currentFont),
            ),
            initialRoute: notesListScreen,
            getPages: appRoutes(),
          );
        },
      ),
    );
  }
}