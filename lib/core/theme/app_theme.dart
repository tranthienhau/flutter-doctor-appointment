import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: const Color(0xFFF8FAFC),
    ),
  );
}
