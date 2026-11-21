import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.inverse,
    required this.text,
    required this.textSecondary,
    required this.textInverse,
    required this.border,
    required this.borderStrong,
    required this.primary,
    required this.onPrimary,
    required this.success,
    required this.onSuccess,
  });

  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color inverse;
  final Color text;
  final Color textSecondary;
  final Color textInverse;
  final Color border;
  final Color borderStrong;
  final Color primary;
  final Color onPrimary;
  final Color success;
  final Color onSuccess;

  static const _ember = Color(0xFFD85A30);
  static const _green = Color(0xFF5DAA79);
  static const _black = Color(0xFF161615);

  static const light = AppColors(
    background: Color(0xFFF7F7F6),
    surface: Color(0xFFEFEFEE),
    surfaceVariant: Color(0xFFE4E4E3),
    inverse: Color(0xFF2B2B2A),
    text: Color(0xFF2B2B2A),
    textSecondary: Color(0xFF5C5C5B),
    textInverse: Color(0xFFF7F7F6),
    border: Color(0xFFD6D6D5),
    borderStrong: Color(0xFF2B2B2A),
    primary: _ember,
    onPrimary: _black,
    success: _green,
    onSuccess: _black,
  );

  static const dark = AppColors(
    background: _black,
    surface: Color(0xFF1E1E1D),
    surfaceVariant: Color(0xFF2B2B2A),
    inverse: Color(0xFFE9E9E8),
    text: Color(0xFFE9E9E8),
    textSecondary: Color(0xFF8C8C8B),
    textInverse: _black,
    border: Color(0xFF2B2B2A),
    borderStrong: Color(0xFFE9E9E8),
    primary: _ember,
    onPrimary: _black,
    success: _green,
    onSuccess: _black,
  );

  static AppColors of(BuildContext context) =>
      Theme.of(context).extension<AppColors>() ?? light;

  @override
  AppColors copyWith({
    Color? background,
    Color? surface,
    Color? surfaceVariant,
    Color? inverse,
    Color? text,
    Color? textSecondary,
    Color? textInverse,
    Color? border,
    Color? borderStrong,
    Color? primary,
    Color? onPrimary,
    Color? success,
    Color? onSuccess,
  }) {
    return AppColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      inverse: inverse ?? this.inverse,
      text: text ?? this.text,
      textSecondary: textSecondary ?? this.textSecondary,
      textInverse: textInverse ?? this.textInverse,
      border: border ?? this.border,
      borderStrong: borderStrong ?? this.borderStrong,
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    Color mix(Color a, Color b) => Color.lerp(a, b, t) ?? a;
    return AppColors(
      background: mix(background, other.background),
      surface: mix(surface, other.surface),
      surfaceVariant: mix(surfaceVariant, other.surfaceVariant),
      inverse: mix(inverse, other.inverse),
      text: mix(text, other.text),
      textSecondary: mix(textSecondary, other.textSecondary),
      textInverse: mix(textInverse, other.textInverse),
      border: mix(border, other.border),
      borderStrong: mix(borderStrong, other.borderStrong),
      primary: mix(primary, other.primary),
      onPrimary: mix(onPrimary, other.onPrimary),
      success: mix(success, other.success),
      onSuccess: mix(onSuccess, other.onSuccess),
    );
  }
}

extension AppColorsExtension on BuildContext {
  AppColors get colors => AppColors.of(this);
}
