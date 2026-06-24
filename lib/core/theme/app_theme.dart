import 'package:flutter/material.dart';

/// MedConnect "Modern Medical" palette - bright theme.
/// Mirrors the Vitality Health Systems design system (Stitch redesign).
class AppColors {
  static const primary = Color(0xFF0059BB);
  static const primaryContainer = Color(0xFF0070EA);
  static const onPrimary = Color(0xFFFFFFFF);
  static const primaryFixed = Color(0xFFD8E2FF);
  static const primaryFixedDim = Color(0xFFADC7FF);

  static const secondary = Color(0xFF00696E);
  static const secondaryContainer = Color(0xFF61F4FD);
  static const onSecondaryContainer = Color(0xFF006E73);

  static const surface = Color(0xFFF8F9FA);
  static const surfaceContainerLowest = Color(0xFFFFFFFF);
  static const surfaceContainerLow = Color(0xFFF3F4F5);
  static const surfaceContainer = Color(0xFFEDEEEF);
  static const surfaceContainerHigh = Color(0xFFE7E8E9);
  static const surfaceVariant = Color(0xFFE1E3E4);

  static const onSurface = Color(0xFF191C1D);
  static const onSurfaceVariant = Color(0xFF414754);
  static const outline = Color(0xFF717786);
  static const outlineVariant = Color(0xFFC1C6D7);

  static const star = Color(0xFFFFC107);
  static const error = Color(0xFFBA1A1A);

  /// Soft, diffused "medical shadow" with a subtle blue tint.
  static List<BoxShadow> get medicalShadow => const [
        BoxShadow(
          color: Color.fromRGBO(0, 64, 133, 0.06),
          blurRadius: 24,
          spreadRadius: -8,
          offset: Offset(0, 12),
        ),
      ];
}

class AppTheme {
  static ThemeData get light {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.onPrimary,
      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.secondaryContainer,
      onSecondaryContainer: AppColors.onSecondaryContainer,
      tertiary: Color(0xFF545D65),
      onTertiary: Colors.white,
      error: AppColors.error,
      onError: Colors.white,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      onSurfaceVariant: AppColors.onSurfaceVariant,
      outline: AppColors.outline,
      outlineVariant: AppColors.outlineVariant,
      surfaceContainerLowest: AppColors.surfaceContainerLowest,
      surfaceContainerLow: AppColors.surfaceContainerLow,
      surfaceContainer: AppColors.surfaceContainer,
      surfaceContainerHigh: AppColors.surfaceContainerHigh,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.surface,
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.primary,
        titleTextStyle: TextStyle(
          color: AppColors.primary,
          fontSize: 22,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      chipTheme: const ChipThemeData(showCheckmark: false),
    );
  }
}
