import 'package:equatable/equatable.dart';

class AppSettings extends Equatable {
  final bool isDarkMode;
  final String fontFamily;

  const AppSettings({
    required this.isDarkMode,
    required this.fontFamily,
  });

  @override
  List<Object?> get props => [isDarkMode, fontFamily];
}

