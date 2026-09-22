import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../shared/widgets/brand_logo.dart';

/// Shown while the session resolves.
///
/// Deliberately does nothing but wait. The old application decided where to
/// send the worker from a locally stored flag; here the answer comes from
/// Firebase and the server, and this screen is what that costs.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // The mark alone, not the full lockup: the wordmark would set the
            // name twice over, once in the artwork and again in the line
            // underneath that says which of the two apps this is.
            const BrandLogo.mark(width: 96, tone: BrandTone.light),
            const SizedBox(height: AppSpacing.xl),
            // The name needs 327dp on one line, which is wider than a 320dp
            // screen and wider still once the worker has scaled their font up.
            // Scaling it down beats wrapping: "Wervexa Captain" reads as one
            // thing, and the mark above it is what carries at a glance anyway.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Wervexa Captain',
                  style: AppTypography.headlineMedium
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxxl),
            const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
