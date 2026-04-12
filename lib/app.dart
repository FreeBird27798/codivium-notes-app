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