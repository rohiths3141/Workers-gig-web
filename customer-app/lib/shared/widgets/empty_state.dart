import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../core/localization/l10n.dart';

/// A consistent "nothing to show" placeholder.
///
/// Used whenever a real backend query legitimately returns zero rows —
/// never as a substitute for real data. See product spec: an empty state
/// (e.g. "No professionals available nearby") is a correct, expected result.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 56, color: AppColors.slateGrey.withOpacity(0.6)),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.darkIndigo,
              ),
            ),
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: AppColors.slateGrey),
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 20),
              OutlinedButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}

/// A consistent "something went wrong" placeholder for failed queries.
class ErrorState extends StatelessWidget {
  const ErrorState({
    super.key,
    required this.message,
    this.onRetry,
  });

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 48, color: AppColors.statusError),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.statusError),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              Center(child: OutlinedButton(onPressed: onRetry, child: Text(context.l10n.commonRetry))),
            ],
          ],
        ),
      ),
    );
  }
}
