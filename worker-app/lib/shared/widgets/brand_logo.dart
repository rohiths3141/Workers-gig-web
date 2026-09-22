import 'package:flutter/material.dart';

/// Which rendering of the brand a surface needs.
enum BrandTone {
  /// Full colour. Only legible on white and the light greys.
  colour,

  /// Solid white, for the primary blue and every dark surface.
  light,

  /// Colour in the light theme, white in the dark one. The default, because
  /// the navy in the wordmark is all but invisible on the dark background
  /// and the app follows the system setting.
  adaptive,
}

/// The Wervexa brand artwork.
///
/// Two lockups, because they are read at different distances. [BrandLogo] is
/// the mark above the wordmark and needs room to be read; [BrandLogo.mark] is
/// the W on its own, for anywhere the name is already on screen or the space
/// is too small to set type in.
///
/// Both ship on a transparent ground, so neither paints a white card onto a
/// coloured surface.
class BrandLogo extends StatelessWidget {
  const BrandLogo({this.width = 180, this.tone = BrandTone.adaptive, super.key})
      : _markOnly = false;

  /// The W on its own, without the wordmark.
  const BrandLogo.mark({
    this.width = 72,
    this.tone = BrandTone.adaptive,
    super.key,
  }) : _markOnly = true;

  /// Width in logical pixels. Height follows the artwork's own ratio.
  final double width;
  final BrandTone tone;
  final bool _markOnly;

  @override
  Widget build(BuildContext context) {
    final onDark = switch (tone) {
      BrandTone.colour => false,
      BrandTone.light => true,
      BrandTone.adaptive => Theme.of(context).brightness == Brightness.dark,
    };

    final name = switch ((_markOnly, onDark)) {
      (true, false) => 'wervexa_mark',
      (true, true) => 'wervexa_mark_light',
      (false, false) => 'wervexa_logo',
      (false, true) => 'wervexa_logo_light',
    };

    return Image.asset(
      'assets/images/$name.png',
      width: width,
      // The artwork is shipped well above its largest on-screen size, so this
      // is always a downscale and the filter quality is what keeps the curves
      // on the W clean.
      filterQuality: FilterQuality.medium,
      // Decorative: the screens that use this already say the name in text.
      excludeFromSemantics: true,
    );
  }
}
