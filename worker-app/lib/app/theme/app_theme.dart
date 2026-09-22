import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// The app's Material theme.
///
/// Configured once here so no widget has to restate a radius, a border colour
/// or a minimum height, and so the 48dp touch-target floor is applied by the
/// framework rather than remembered by each author.
abstract final class AppTheme {
  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final ink = isDark ? AppColors.darkInk : AppColors.ink;
    final inkSecondary = isDark ? AppColors.darkInkSecondary : AppColors.inkSecondary;
    final surface = isDark ? AppColors.darkSurface : AppColors.surface;
    final background = isDark ? AppColors.darkBackground : AppColors.background;
    final border = isDark ? AppColors.darkBorder : AppColors.border;
    final primary = isDark ? AppColors.primaryLight : AppColors.primary;

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: Colors.white,
      primaryContainer: isDark ? AppColors.primaryDark : AppColors.primarySurface,
      onPrimaryContainer: isDark ? Colors.white : AppColors.primaryDark,
      secondary: AppColors.earnings,
      onSecondary: Colors.white,
      error: AppColors.danger,
      onError: Colors.white,
      errorContainer: isDark ? const Color(0xFF3B1512) : AppColors.dangerSurface,
      onErrorContainer: isDark ? const Color(0xFFFFB4AB) : AppColors.danger,
      surface: surface,
      onSurface: ink,
      onSurfaceVariant: inkSecondary,
      outline: border,
      outlineVariant: isDark ? AppColors.darkBorder : AppColors.borderStrong,
      scrim: AppColors.scrim,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      textTheme: AppTypography.textTheme(ink, inkSecondary),
      splashFactory: InkSparkle.splashFactory,

      appBarTheme: AppBarTheme(
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
        foregroundColor: ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.titleLarge.copyWith(color: ink),
        systemOverlayStyle:
            isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      ),

      cardTheme: CardThemeData(
        color: surface,
        surfaceTintColor: Colors.transparent,
        elevation: AppElevation.none,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: BorderSide(color: border),
        ),
      ),

      // The primary action is 56dp tall, full width, and unmistakably the thing
      // to press.
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(
            Size.fromHeight(AppSpacing.primaryActionHeight),
          ),
          textStyle: WidgetStatePropertyAll(AppTypography.button),
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          )),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return isDark ? AppColors.darkSurfaceMuted : AppColors.surfaceMuted;
            }
            return primary;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColors.inkTertiary;
            }
            return Colors.white;
          }),
          // A disabled fill barely differs from the page background, so
          // without an outline the button appears to vanish rather than
          // read as "not ready yet" — the border is what keeps its shape
          // visible in that state.
          side: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return BorderSide(color: border, width: 1);
            }
            return null;
          }),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(AppSpacing.minTouchTarget),
          foregroundColor: ink,
          textStyle: AppTypography.button,
          side: BorderSide(color: border, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(AppSpacing.minTouchTarget, AppSpacing.minTouchTarget),
          foregroundColor: primary,
          textStyle: AppTypography.button,
        ),
      ),

      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size(AppSpacing.minTouchTarget, AppSpacing.minTouchTarget),
          foregroundColor: ink,
        ),
      ),

      // Inputs are tall and high-contrast. A worker typing a material cost on a
      // dusty screen should not have to aim.
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? AppColors.darkSurfaceMuted : AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        hintStyle: AppTypography.bodyLarge.copyWith(color: AppColors.inkTertiary),
        labelStyle: AppTypography.label.copyWith(color: inkSecondary),
        floatingLabelStyle: AppTypography.label.copyWith(color: primary),
        errorStyle: AppTypography.bodySmall.copyWith(color: AppColors.danger),
        border: _inputBorder(border),
        enabledBorder: _inputBorder(border),
        focusedBorder: _inputBorder(primary, width: 2),
        errorBorder: _inputBorder(AppColors.danger),
        focusedErrorBorder: _inputBorder(AppColors.danger, width: 2),
        disabledBorder: _inputBorder(border.withValues(alpha: 0.5)),
      ),

      dividerTheme: DividerThemeData(color: border, thickness: 1, space: 1),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: AppColors.inkTertiary,
        selectedLabelStyle: AppTypography.badge.copyWith(letterSpacing: 0.2),
        unselectedLabelStyle: AppTypography.badge.copyWith(letterSpacing: 0.2),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      // The app shell uses the Material 3 NavigationBar, not
      // BottomNavigationBar — without this, its selected-tab indicator pill
      // falls back to colorScheme.secondaryContainer, which is derived from
      // the earnings green and renders a green pill behind the active tab.
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: isDark ? AppColors.primaryDark : AppColors.primarySurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return AppTypography.badge.copyWith(
            letterSpacing: 0.2,
            color: selected ? primary : AppColors.inkTertiary,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(color: selected ? primary : AppColors.inkTertiary);
        }),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: isDark ? AppColors.darkSurfaceMuted : AppColors.surfaceMuted,
        selectedColor: isDark ? AppColors.primaryDark : AppColors.primarySurface,
        labelStyle: AppTypography.label.copyWith(color: ink),
        side: BorderSide(color: border),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        titleTextStyle: AppTypography.titleLarge.copyWith(color: ink),
        contentTextStyle: AppTypography.bodyLarge.copyWith(color: inkSecondary),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? AppColors.darkSurfaceMuted : AppColors.ink,
        contentTextStyle: AppTypography.bodyMedium.copyWith(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primary,
        linearTrackColor: isDark ? AppColors.darkSurfaceMuted : AppColors.surfaceMuted,
      ),

      listTileTheme: ListTileThemeData(
        minVerticalPadding: AppSpacing.md,
        titleTextStyle: AppTypography.titleMedium.copyWith(color: ink),
        subtitleTextStyle: AppTypography.bodyMedium.copyWith(color: inkSecondary),
        iconColor: inkSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    );
  }

  static OutlineInputBorder _inputBorder(Color color, {double width = 1.5}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: BorderSide(color: color, width: width),
      );
}
