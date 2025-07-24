import 'package:flutter/material.dart';
import 'package:kanban_app/styles/colors.dart';

ThemeData get lightTheme {
  return ThemeData(
    fontFamily: 'Inter',
    brightness: Brightness.light,
    scaffoldBackgroundColor: MyColors.mintCream,
    cardColor: Colors.white,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      bodySmall: TextStyle(fontSize: 14, color: MyColors.charcoal),
    ),
  );
}
