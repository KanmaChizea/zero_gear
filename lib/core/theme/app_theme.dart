import 'package:flutter/material.dart';
import 'package:zero_gear/core/theme/app_colors.dart';

abstract final class AppTheme {
  static ThemeData get light =>
      _createTheme(brightness: Brightness.light, colors: AppColors.light);

  static ThemeData get dark =>
      _createTheme(brightness: Brightness.dark, colors: AppColors.dark);

  static ThemeData _createTheme({
    required Brightness brightness,
    required AppColors colors,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: colors.background,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: colors.primary,
        onPrimary: colors.onPrimary,
        secondary: colors.success,
        onSecondary: colors.onSuccess,
        error: colors.error,
        onError: colors.onError,
        surface: colors.background,
        onSurface: colors.text,
        surfaceContainer: colors.surface,
        surfaceContainerHighest: colors.surfaceVariant,
        outline: colors.border,
        outlineVariant: colors.border,
        inverseSurface: colors.inverse,
        onInverseSurface: colors.textInverse,
      ),
      dividerColor: colors.border,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.background,
        foregroundColor: colors.text,
        elevation: 0,
      ),
      extensions: [colors],
    );
  }
}
