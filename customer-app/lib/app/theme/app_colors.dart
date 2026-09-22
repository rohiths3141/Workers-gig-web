import 'package:flutter/material.dart';

/// Customer app colour palette.
///
/// Matches the reference UI/UX: flat white surfaces, vivid blue used only
/// as an accent on interactive/selected elements — no gradients, no
/// colour-filled hero headers. See REFERENCE_UI_UX_ANALYSIS.md.
abstract final class AppColors {
  // Brand
  static const primary = Color(0xFF2F63E8);        // reference accent blue
  static const primaryDark = Color(0xFF2453C7);
  static const primaryLight = Color(0xFF5B85EE);
  static const primarySurface = Color(0xFFEAF0FD);

  static const secondary = Color(0xFF2F63E8);
  static const secondarySurface = Color(0xFFEAF0FD);

  // Status — intentionally identical to worker app for shared semantics
  static const success = Color(0xFF1F7A3D);
  static const successSurface = Color(0xFFE8F4EB);
  static const warning = Color(0xFF9A6100);
  static const warningSurface = Color(0xFFFDF3E0);
  static const danger = Color(0xFFB3261E);
  static const dangerSurface = Color(0xFFFCEAE8);
  static const info = Color(0xFF0B5FA5);
  static const infoSurface = Color(0xFFE7F1FA);

  // Neutrals
  static const ink = Color(0xFF1F2937);
  static const inkSecondary = Color(0xFF6B7280);
  static const inkTertiary = Color(0xFF9CA3AF);
  static const border = Color(0xFFE5E7EB);
  static const borderStrong = Color(0xFFC9CED8);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceMuted = Color(0xFFF2F4F7);
  static const background = Color(0xFFFFFFFF);
  static const scrim = Color(0x66000000);

  // Dark theme
  static const darkBackground = Color(0xFF0D1214);
  static const darkSurface = Color(0xFF151D20);
  static const darkSurfaceMuted = Color(0xFF1D272A);
  static const darkBorder = Color(0xFF2C383C);
  static const darkInk = Color(0xFFF2F5F5);
  static const darkInkSecondary = Color(0xFFB3BFC2);
  static const darkInkTertiary = Color(0xFF849397);

  // Star rating
  static const star = Color(0xFFF59E0B);

  // Semantic Aliases for Customer UI
  static const primaryViolet = primary;
  static const darkIndigo = ink;
  static const slateGrey = inkSecondary;
  static const borderLight = border;
  static const accentGold = star;
  static const successGreen = success;
  static const statusPending = warning;
  static const statusInProgress = info;
  static const statusSuccess = success;
  static const statusError = danger;
}
