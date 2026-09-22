import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

abstract final class AppTypography {
  static TextTheme get _base => GoogleFonts.outfitTextTheme();

  static TextTheme get light => _base.copyWith(
        displayLarge: _base.displayLarge?.copyWith(color: AppColors.ink),
        displayMedium: _base.displayMedium?.copyWith(color: AppColors.ink),
        displaySmall: _base.displaySmall?.copyWith(color: AppColors.ink),
        headlineLarge: _base.headlineLarge?.copyWith(
            color: AppColors.ink, fontWeight: FontWeight.w700),
        headlineMedium: _base.headlineMedium?.copyWith(
            color: AppColors.ink, fontWeight: FontWeight.w700),
        headlineSmall: _base.headlineSmall?.copyWith(
            color: AppColors.ink, fontWeight: FontWeight.w600),
        titleLarge: _base.titleLarge?.copyWith(
            color: AppColors.ink, fontWeight: FontWeight.w600),
        titleMedium: _base.titleMedium?.copyWith(
            color: AppColors.ink, fontWeight: FontWeight.w500),
        titleSmall: _base.titleSmall?.copyWith(
            color: AppColors.inkSecondary, fontWeight: FontWeight.w500),
        bodyLarge:
            _base.bodyLarge?.copyWith(color: AppColors.ink, height: 1.5),
        bodyMedium:
            _base.bodyMedium?.copyWith(color: AppColors.inkSecondary, height: 1.5),
        bodySmall:
            _base.bodySmall?.copyWith(color: AppColors.inkTertiary, height: 1.4),
        labelLarge: _base.labelLarge?.copyWith(
            color: AppColors.ink, fontWeight: FontWeight.w600),
        labelMedium: _base.labelMedium?.copyWith(
            color: AppColors.inkSecondary, fontWeight: FontWeight.w500),
        labelSmall: _base.labelSmall?.copyWith(
            color: AppColors.inkTertiary,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5),
      );

  static TextTheme get dark => _base.copyWith(
        displayLarge: _base.displayLarge?.copyWith(color: AppColors.darkInk),
        displayMedium: _base.displayMedium?.copyWith(color: AppColors.darkInk),
        displaySmall: _base.displaySmall?.copyWith(color: AppColors.darkInk),
        headlineLarge: _base.headlineLarge?.copyWith(
            color: AppColors.darkInk, fontWeight: FontWeight.w700),
        headlineMedium: _base.headlineMedium?.copyWith(
            color: AppColors.darkInk, fontWeight: FontWeight.w700),
        headlineSmall: _base.headlineSmall?.copyWith(
            color: AppColors.darkInk, fontWeight: FontWeight.w600),
        titleLarge: _base.titleLarge?.copyWith(
            color: AppColors.darkInk, fontWeight: FontWeight.w600),
        titleMedium: _base.titleMedium?.copyWith(
            color: AppColors.darkInk, fontWeight: FontWeight.w500),
        titleSmall: _base.titleSmall?.copyWith(
            color: AppColors.darkInkSecondary, fontWeight: FontWeight.w500),
        bodyLarge:
            _base.bodyLarge?.copyWith(color: AppColors.darkInk, height: 1.5),
        bodyMedium: _base.bodyMedium?.copyWith(
            color: AppColors.darkInkSecondary, height: 1.5),
        bodySmall: _base.bodySmall?.copyWith(
            color: AppColors.darkInkTertiary, height: 1.4),
        labelLarge: _base.labelLarge?.copyWith(
            color: AppColors.darkInk, fontWeight: FontWeight.w600),
        labelMedium: _base.labelMedium?.copyWith(
            color: AppColors.darkInkSecondary, fontWeight: FontWeight.w500),
      );
}
