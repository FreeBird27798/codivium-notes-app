import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFonts {
  AppFonts._();

  static TextTheme getTextTheme(String fontFamily) {
    switch (fontFamily) {
      case 'Roboto':
        return GoogleFonts.robotoTextTheme();
      case 'Lato':
        return GoogleFonts.latoTextTheme();
      case 'OpenSans':
        return GoogleFonts.openSansTextTheme();
      case 'Montserrat':
        return GoogleFonts.montserratTextTheme();
      case 'Poppins':
      default:
        return GoogleFonts.poppinsTextTheme();
    }
  }

  static const List<String> availableFonts = [
    'Poppins',
    'Roboto',
    'Lato',
    'OpenSans',
    'Montserrat',
  ];
}

