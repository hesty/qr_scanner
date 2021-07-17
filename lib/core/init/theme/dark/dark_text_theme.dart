import 'package:flutter/material.dart';

class DarkTextTheme {
  static DarkTextTheme? _instance;
  static DarkTextTheme get instance {
    _instance ??= _instance = DarkTextTheme._init();
    return _instance!;
  }

  DarkTextTheme._init();

  final TextStyle appBarTextTheme =
      TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.bold);
}
