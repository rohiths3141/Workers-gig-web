import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Type scale.
///
/// Sizes start at 14 and the body default is 16. There is deliberately no 11pt
/// or 12pt style for content: the previous application used them for status
/// labels and amounts, which is unreadable outdoors at arm's length. 12pt
/// survives only for a badge, where the word is a single short token.
///
/// Numerals are tabular wherever an amount is shown, so a column of earnings
/// lines up and a changing balance does not make the layout jitter.
abstract final class AppTypography {
  static const _family = null; // Platform default: Roboto / SF. Ships no font.

  static const _tabular = [FontFeature.tabularFigures()];

  static const displayLarge = TextStyle(
    fontFamily: _family,
    fontSize: 34,
    height: 1.15,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );

  /// For the one number that matters on a screen: today's earnings, the balance.
  static const numericHero = TextStyle(
    fontFamily: _family,
    fontSize: 34,
    height: 1.1,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    fontFeatures: _tabular,
  );

  static const headlineLarge = TextStyle(
    fontFamily: _family,
    fontSize: 26,
    height: 1.2,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
  );

  static const headlineMedium = TextStyle(
    fontFamily: _family,
    fontSize: 22,
    height: 1.25,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
  );

  static const titleLarge = TextStyle(
    fontFamily: _family,
    fontSize: 19,
    height: 1.3,
    fontWeight: FontWeight.w600,
  );

  static const titleMedium = TextStyle(
    fontFamily: _family,
    fontSize: 17,
    height: 1.35,
    fontWeight: FontWeight.w600,
  );

  static const bodyLarge = TextStyle(
    fontFamily: _family,
    fontSize: 16,
    height: 1.45,
    fontWeight: FontWeight.w400,
  );

  static const bodyMedium = TextStyle(
    fontFamily: _family,
    fontSize: 15,
    height: 1.45,
    fontWeight: FontWeight.w400,
  );

  /// The smallest content style. Nothing a worker must read goes below this.
  static const bodySmall = TextStyle(
    fontFamily: _family,
    fontSize: 14,
    height: 1.4,
    fontWeight: FontWeight.w400,
  );

  static const label = TextStyle(
    fontFamily: _family,
    fontSize: 14,
    height: 1.3,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );

  /// Single-token badges only ("NEW", "PAID"). Never a sentence.
  static const badge = TextStyle(
    fontFamily: _family,
    fontSize: 12,
    height: 1.2,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.6,
  );

  static const button = TextStyle(
    fontFamily: _family,
    fontSize: 17,
    height: 1.2,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );

  static const amount = TextStyle(
    fontFamily: _family,
    fontSize: 17,
    height: 1.25,
    fontWeight: FontWeight.w700,
    fontFeatures: _tabular,
  );

  static const amountLarge = TextStyle(
    fontFamily: _family,
    fontSize: 22,
    height: 1.2,
    fontWeight: FontWeight.w700,
    fontFeatures: _tabular,
  );

  static TextTheme textTheme(Color ink, Color inkSecondary) => TextTheme(
        displayLarge: displayLarge.copyWith(color: ink),
        headlineLarge: headlineLarge.copyWith(color: ink),
        headlineMedium: headlineMedium.copyWith(color: ink),
        titleLarge: titleLarge.copyWith(color: ink),
        titleMedium: titleMedium.copyWith(color: ink),
        bodyLarge: bodyLarge.copyWith(color: ink),
        bodyMedium: bodyMedium.copyWith(color: ink),
        bodySmall: bodySmall.copyWith(color: inkSecondary),
        labelLarge: label.copyWith(color: ink),
        labelMedium: label.copyWith(color: inkSecondary),
        labelSmall: badge.copyWith(color: inkSecondary),
      );
}

/// Convenience accessors so widgets read `context.text.titleLarge` instead of
/// reaching for Theme.of every time.
extension AppTextThemeX on BuildContext {
  TextTheme get text => Theme.of(this).textTheme;
  ColorScheme get colors => Theme.of(this).colorScheme;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  /// Ink that is correct in both themes, for the many places that need a
  /// primary text colour outside a TextTheme entry.
  Color get ink => isDark ? AppColors.darkInk : AppColors.ink;
  Color get inkSecondary => isDark ? AppColors.darkInkSecondary : AppColors.inkSecondary;
  Color get inkTertiary => isDark ? AppColors.darkInkTertiary : AppColors.inkTertiary;
  Color get border => isDark ? AppColors.darkBorder : AppColors.border;
  Color get surface => isDark ? AppColors.darkSurface : AppColors.surface;
  Color get surfaceMuted => isDark ? AppColors.darkSurfaceMuted : AppColors.surfaceMuted;
}
