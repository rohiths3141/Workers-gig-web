import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_colors.dart';

/// Shown once a booking's review has actually been submitted and accepted
/// by the backend — never shown speculatively.
class ServiceCompletedScreen extends StatelessWidget {
  const ServiceCompletedScreen({
    super.key,
    required this.serviceName,
    this.workerName,
    this.amountLabel,
  });

  final String serviceName;
  final String? workerName;
  final String? amountLabel;

  @override
  Widget build(BuildContext context) {
    final summaryParts = [
      if (workerName != null) workerName!,
      serviceName,
      if (amountLabel != null) amountLabel!,
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(color: AppColors.successSurface, shape: BoxShape.circle),
                child: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 64),
              ),
              const SizedBox(height: 24),
              const Text(
                'Service Completed!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.ink),
              ),
              const SizedBox(height: 8),
              const Text(
                'Thanks for using our services.',
                style: TextStyle(color: AppColors.inkSecondary, fontSize: 13),
              ),
              const SizedBox(height: 8),
              if (summaryParts.isNotEmpty)
                Text(
                  summaryParts.join(' · '),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.inkSecondary, fontSize: 13, fontWeight: FontWeight.w600),
                ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => context.go('/bookings'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text(
                    'View Bookings',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () => context.go('/home'),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text(
                    'Back to Home',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
