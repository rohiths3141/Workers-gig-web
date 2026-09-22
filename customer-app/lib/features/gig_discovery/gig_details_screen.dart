import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_colors.dart';

class GigDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> gigCard;

  const GigDetailsScreen({super.key, required this.gigCard});

  @override
  Widget build(BuildContext context) {
    final workerName = gigCard['workerName'] as String? ?? 'Unknown professional';
    final serviceTitle = gigCard['serviceTitle'] as String? ?? '';
    final priceLabel = gigCard['priceLabel'] as String? ?? '—';
    final rating = (gigCard['rating'] as num?)?.toDouble();
    final ratingCount = gigCard['ratingCount'] as int? ?? 0;
    final distanceLabel = gigCard['distanceLabel'] as String?;
    final isKycVerified = gigCard['isKycVerified'] as bool? ?? false;
    final isBackgroundVerified = gigCard['isBackgroundVerified'] as bool? ?? false;
    final workerPhotoUrl = gigCard['workerPhotoUrl'] as String?;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero image with floating back button.
                  Stack(
                    children: [
                      SizedBox(
                        height: 260,
                        width: double.infinity,
                        child: workerPhotoUrl != null
                            ? CachedNetworkImage(
                                imageUrl: workerPhotoUrl,
                                fit: BoxFit.cover,
                                errorWidget: (_, __, ___) => _heroPlaceholder(workerName),
                              )
                            : _heroPlaceholder(workerName),
                      ),
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: _CircleIconButton(
                            icon: Icons.arrow_back,
                            onTap: () => context.pop(),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          workerName,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: AppColors.star, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              rating == null
                                  ? 'New professional'
                                  : '$rating ($ratingCount reviews)',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: AppColors.ink,
                              ),
                            ),
                            if (distanceLabel != null) ...[
                              const SizedBox(width: 8),
                              Text(
                                '· $distanceLabel',
                                style: const TextStyle(fontSize: 13, color: AppColors.inkSecondary),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          serviceTitle,
                          style: const TextStyle(color: AppColors.inkSecondary, fontSize: 13),
                        ),
                        const SizedBox(height: 20),

                        // Pricing card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Pricing',
                                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.ink),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Service Rate', style: TextStyle(color: AppColors.inkSecondary)),
                                  Text(
                                    priceLabel,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'The final amount is confirmed by your professional and shown '
                                'on your booking once created.',
                                style: TextStyle(fontSize: 11, color: AppColors.inkTertiary),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Real verification badges only — no invented skill tags.
                        if (isKycVerified || isBackgroundVerified) ...[
                          const Text(
                            'Verification',
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.ink),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: [
                              if (isKycVerified) _verifiedChip('KYC Verified'),
                              if (isBackgroundVerified) _verifiedChip('Background Verified'),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Sticky bottom price + booking CTA
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Text(
                    priceLabel,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.ink),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => context.push('/book-service', extra: gigCard),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        minimumSize: const Size(0, 52),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text(
                        'Book Now →',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _heroPlaceholder(String workerName) {
    return Container(
      color: AppColors.primarySurface,
      child: Center(
        child: Text(
          workerName.isNotEmpty ? workerName[0].toUpperCase() : 'W',
          style: const TextStyle(fontSize: 64, fontWeight: FontWeight.w700, color: AppColors.primary),
        ),
      ),
    );
  }

  Widget _verifiedChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.successSurface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.success),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.ink, size: 20),
      ),
    );
  }
}
