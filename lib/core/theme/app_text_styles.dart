import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zero_gear/core/utils/scale_util.dart';

abstract final class AppTextStyles {
  static TextStyle _inter(
    double size,
    FontWeight weight,
    double lineHeight, [
    double letterSpacing = 0,
  ]) => GoogleFonts.inter(
    fontSize: size.sp,
    fontWeight: weight,
    height: lineHeight / size,
    letterSpacing: letterSpacing.sp,
  );

  static final display = _inter(30, FontWeight.w700, 36, -0.5);
  static final title = _inter(22, FontWeight.w700, 28, -0.3);
  static final heading = _inter(16, FontWeight.w600, 22);
  static final body = _inter(14, FontWeight.w400, 20);
  static final bodyMedium = _inter(14, FontWeight.w500, 20);
  static final caption = _inter(12, FontWeight.w400, 16);
  static final label = _inter(11, FontWeight.w600, 14, 0.6);
  static final numeric = _inter(64, FontWeight.w700, 72, -2);
}

extension TextStyleWeight on TextStyle {
  TextStyle weight(FontWeight weight) =>
      GoogleFonts.inter(fontWeight: weight, textStyle: this);
}
