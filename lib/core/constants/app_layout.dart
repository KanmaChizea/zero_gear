import 'package:flutter/widgets.dart';

/// Widths that keep layouts readable on tablets. Phones are narrower than
/// all of these, so they're unaffected.
abstract final class AppLayout {
  /// Screens narrower than this are phones.
  static const double tabletBreakpoint = 600;

  /// True on tablets and other wide windows, where screens can use two columns.
  static bool isWide(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tabletBreakpoint;

  /// Confirmation dialogs, so they don't stretch across a wide window.
  static const double maxDialogWidth = 420;

  /// Forms, lists and text-heavy screens.
  static const double maxContentWidth = 600;

  /// Product and category grids, which add columns instead of stretching.
  static const double maxCatalogWidth = 1100;

  /// The sign-in and sign-up forms on tablets.
  static const double maxAuthFormWidth = 480;
}
