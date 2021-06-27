import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_scanner/core/init/theme/dark/dark_theme_interface.dart';
import 'package:qr_scanner/core/init/theme/app_theme.dart';

class DarkTheme extends AppTheme with IDarkTheme {
  static DarkTheme? _instance;
  static DarkTheme get instance {
    _instance ??= _instance = DarkTheme._init();
    return _instance!;
  }

  @override
  ThemeData get theme => ThemeData(
      scaffoldBackgroundColor: Color(0xff1D1F22),
      fontFamily: GoogleFonts.poppins().fontFamily,
      appBarTheme: _appBarTheme,
      inputDecorationTheme: _inputDecorationTheme);

  AppBarTheme get _appBarTheme => ThemeData.dark().appBarTheme.copyWith(
      centerTitle: true,
      color: Colors.transparent,
      elevation: 0,
      titleTextStyle: textTheme.appBarTextTheme);

  InputDecorationTheme get _inputDecorationTheme => InputDecorationTheme(
        hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: Colors.white)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      );

  DarkTheme._init();
}
