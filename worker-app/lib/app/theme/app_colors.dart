import 'package:flutter/material.dart';

/// The palette.
///
/// Chosen for the conditions this app is actually used in: outdoors, in bright
/// sunlight, on a cheap screen, by someone who is standing up and holding tools.
/// That rules out low-contrast greys and thin tinted text, which is why the
/// scale below bottoms out at a genuinely dark ink rather than a soft charcoal.
///
/// The primary is the same vivid blue as the customer app (#2F63E8) — the two
/// apps are one product family and share a single brand accent by design.
/// Every other status colour below (earnings, available, danger, warning) is
/// unchanged and still carries its own distinct meaning.
abstract final class AppColors {
  // Brand — matches the customer app's AppColors.primary exactly.
  static const primary = Color(0xFF2F63E8);
  static const primaryDark = Color(0xFF2453C7);
  static const primaryLight = Color(0xFF5B85EE);
  static const primarySurface = Color(0xFFEAF0FD);

  /// Reserved for money. Earnings are the reason the worker opens the app, so
  /// they get a colour nothing else is allowed to use.
  static const earnings = Color(0xFF1F7A3D);
  static const earningsSurface = Color(0xFFE8F4EB);

  // Status. Each one is paired with an icon and a word in the UI — colour is
  // never the only carrier of meaning.
  static const success = Color(0xFF1F7A3D);
  static const successSurface = Color(0xFFE8F4EB);
  static const warning = Color(0xFF9A6100);
  static const warningSurface = Color(0xFFFDF3E0);
  static const danger = Color(0xFFB3261E);
  static const dangerSurface = Color(0xFFFCEAE8);
  static const info = Color(0xFF0B5FA5);
  static const infoSurface = Color(0xFFE7F1FA);

  /// Availability. Deliberately not the same green as earnings: "I am available"
  /// and "I was paid" must never be confusable at a glance.
  static const available = Color(0xFF0F8A5F);
  static const offline = Color(0xFF6B7280);
  static const busy = Color(0xFF9A6100);

  // Neutrals
  static const ink = Color(0xFF12181A);
  static const inkSecondary = Color(0xFF4A5559);
  static const inkTertiary = Color(0xFF6E7A7E);
  static const border = Color(0xFFD9E0E2);
  static const borderStrong = Color(0xFFB6C2C5);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceMuted = Color(0xFFF4F7F7);
  static const background = Color(0xFFF7F9F9);
  static const scrim = Color(0x66000000);

  // Dark theme
  static const darkBackground = Color(0xFF0D1214);
  static const darkSurface = Color(0xFF151D20);
  static const darkSurfaceMuted = Color(0xFF1D272A);
  static const darkBorder = Color(0xFF2C383C);
  static const darkInk = Color(0xFFF2F5F5);
  static const darkInkSecondary = Color(0xFFB3BFC2);
  static const darkInkTertiary = Color(0xFF849397);
}
