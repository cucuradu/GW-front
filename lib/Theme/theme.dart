import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      background: Color.fromARGB(255, 255, 255, 255),
      primary: Color.fromARGB(255, 255, 255, 255),
      secondary: Color.fromARGB(255, 102, 166, 255),
      tertiary: Color.fromARGB(255, 0, 0, 0),
    ));

ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      background: Color.fromARGB(255, 23, 24, 31),
      primary: Color.fromARGB(255, 13, 14, 18),
      secondary: Color.fromARGB(255, 102, 102, 255),
      tertiary: Color.fromARGB(255, 255, 255, 255),
    ));
