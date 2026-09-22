/// Spacing, radius and sizing constants.
///
/// A 4pt grid. The touch-target floor is 48dp and is not negotiable: this app
/// is used one-handed, sometimes with a glove or a wet hand, often while the
/// worker is standing. Anything smaller is a bug, and `AppTouchTarget` in the
/// shared widgets enforces it.
abstract final class AppSpacing {
  static const xxs = 2.0;
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const xxl = 24.0;
  static const xxxl = 32.0;
  static const huge = 48.0;

  /// Side gutter. One value, applied once, so nothing ever sits against the
  /// edge of the screen.
  static const screenPadding = 16.0;

  /// Minimum interactive size. See the class comment.
  static const minTouchTarget = 48.0;

  /// The primary action on a screen is larger again — it is what the worker is
  /// reaching for without looking.
  static const primaryActionHeight = 56.0;
}

abstract final class AppRadius {
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const pill = 999.0;
}

abstract final class AppElevation {
  /// Cards sit on a tinted background with a hairline border rather than a
  /// shadow. Shadows cost a render pass and vanish in sunlight anyway.
  static const none = 0.0;
  static const raised = 2.0;
  static const overlay = 8.0;
}
