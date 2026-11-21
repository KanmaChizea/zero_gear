import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.bgPrimary,
    required this.bgSecondary,
    required this.bgTertiary,
    required this.bgInverse,
    required this.textPrimary,
    required this.textSecondary,
    required this.textInverse,
    required this.borderDefault,
    required this.borderStrong,
    required this.accentPrimary,
    required this.accentOn,
    required this.successPrimary,
    required this.successOn,
    required this.error,
    required this.onError,
  });

  final Color bgPrimary;
  final Color bgSecondary;
  final Color bgTertiary;
  final Color bgInverse;
  final Color textPrimary;
  final Color textSecondary;
  final Color textInverse;
  final Color borderDefault;
  final Color borderStrong;
  final Color accentPrimary;
  final Color accentOn;
  final Color successPrimary;
  final Color successOn;
  final Color error;
  final Color onError;

  static const _ember = Color(0xFFD85A30);
  static const _green = Color(0xFF5DAA79);
  static const _red = Color(0xFFE5575F);
  static const _black = Color(0xFF161615);

  static const light = AppColors(
    bgPrimary: Color(0xFFF7F7F6),
    bgSecondary: Color(0xFFEFEFEE),
    bgTertiary: Color(0xFFE4E4E3),
    bgInverse: Color(0xFF2B2B2A),
    textPrimary: Color(0xFF2B2B2A),
    textSecondary: Color(0xFF5C5C5B),
    textInverse: Color(0xFFF7F7F6),
    borderDefault: Color(0xFFD6D6D5),
    borderStrong: Color(0xFF2B2B2A),
    accentPrimary: _ember,
    accentOn: _black,
    successPrimary: _green,
    successOn: _black,
    error: _red,
    onError: _black,
  );

  static const dark = AppColors(
    bgPrimary: _black,
    bgSecondary: Color(0xFF1E1E1D),
    bgTertiary: Color(0xFF2B2B2A),
    bgInverse: Color(0xFFE9E9E8),
    textPrimary: Color(0xFFE9E9E8),
    textSecondary: Color(0xFF8C8C8B),
    textInverse: _black,
    borderDefault: Color(0xFF2B2B2A),
    borderStrong: Color(0xFFE9E9E8),
    accentPrimary: _ember,
    accentOn: _black,
    successPrimary: _green,
    successOn: _black,
    error: _red,
    onError: _black,
  );

  static AppColors of(BuildContext context) =>
      Theme.of(context).extension<AppColors>() ?? light;

  @override
  AppColors copyWith({
    Color? bgPrimary,
    Color? bgSecondary,
    Color? bgTertiary,
    Color? bgInverse,
    Color? textPrimary,
    Color? textSecondary,
    Color? textInverse,
    Color? borderDefault,
    Color? borderStrong,
    Color? accentPrimary,
    Color? accentOn,
    Color? successPrimary,
    Color? successOn,
    Color? error,
    Color? onError,
  }) {
    return AppColors(
      bgPrimary: bgPrimary ?? this.bgPrimary,
      bgSecondary: bgSecondary ?? this.bgSecondary,
      bgTertiary: bgTertiary ?? this.bgTertiary,
      bgInverse: bgInverse ?? this.bgInverse,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textInverse: textInverse ?? this.textInverse,
      borderDefault: borderDefault ?? this.borderDefault,
      borderStrong: borderStrong ?? this.borderStrong,
      accentPrimary: accentPrimary ?? this.accentPrimary,
      accentOn: accentOn ?? this.accentOn,
      successPrimary: successPrimary ?? this.successPrimary,
      successOn: successOn ?? this.successOn,
      error: error ?? this.error,
      onError: onError ?? this.onError,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    Color mix(Color a, Color b) => Color.lerp(a, b, t) ?? a;
    return AppColors(
      bgPrimary: mix(bgPrimary, other.bgPrimary),
      bgSecondary: mix(bgSecondary, other.bgSecondary),
      bgTertiary: mix(bgTertiary, other.bgTertiary),
      bgInverse: mix(bgInverse, other.bgInverse),
      textPrimary: mix(textPrimary, other.textPrimary),
      textSecondary: mix(textSecondary, other.textSecondary),
      textInverse: mix(textInverse, other.textInverse),
      borderDefault: mix(borderDefault, other.borderDefault),
      borderStrong: mix(borderStrong, other.borderStrong),
      accentPrimary: mix(accentPrimary, other.accentPrimary),
      accentOn: mix(accentOn, other.accentOn),
      successPrimary: mix(successPrimary, other.successPrimary),
      successOn: mix(successOn, other.successOn),
      error: mix(error, other.error),
      onError: mix(onError, other.onError),
    );
  }
}

extension AppColorsExtension on BuildContext {
  AppColors get colors => AppColors.of(this);
}
