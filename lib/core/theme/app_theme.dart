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
      scaffoldBackgroundColor: colors.bgPrimary,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: colors.accentPrimary,
        onPrimary: colors.accentOn,
        secondary: colors.successPrimary,
        onSecondary: colors.successOn,
        error: colors.error,
        onError: colors.onError,
        surface: colors.bgPrimary,
        onSurface: colors.textPrimary,
        surfaceContainer: colors.bgSecondary,
        surfaceContainerHighest: colors.bgTertiary,
        outline: colors.borderDefault,
        outlineVariant: colors.borderDefault,
        inverseSurface: colors.bgInverse,
        onInverseSurface: colors.textInverse,
      ),
      dividerColor: colors.borderDefault,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.bgPrimary,
        foregroundColor: colors.textPrimary,
        elevation: 0,
      ),
      extensions: [colors],
    );
  }
}
