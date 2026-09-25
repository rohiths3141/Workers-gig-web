import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/errors/app_failure.dart';
import '../../core/localization/l10n.dart';

/// Renders loading, error and data for an [AsyncValue].
///
/// This widget is the structural answer to the old application's dummy-data
/// fallback. There is no `fallback` parameter and no way to supply placeholder
/// content for the error case: a failure renders as a failure, with the
/// server's message and a retry where retrying makes sense. If a screen wants
/// to show something when data cannot be loaded, it has to say so out loud.
class AsyncValueView<T> extends StatelessWidget {
  const AsyncValueView({
    required this.value,
    required this.onData,
    required this.onRetry,
    this.loading,
    this.skipLoadingOnRefresh = true,
    super.key,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) onData;
  final VoidCallback onRetry;
  final Widget? loading;

  /// Keeps the previous data on screen during a refresh rather than flashing a
  /// spinner. A worker pulling to refresh should not lose their place.
  final bool skipLoadingOnRefresh;

  @override
  Widget build(BuildContext context) {
    if (value.isLoading && (!skipLoadingOnRefresh || !value.hasValue)) {
      return loading ?? const _CentredLoader();
    }

    if (value.hasError && !value.hasValue) {
      return FailureView(
        failure: value.error is AppFailure
            ? value.error! as AppFailure
            : const UnexpectedFailure(),
        onRetry: onRetry,
      );
    }

    final data = value.valueOrNull;
    if (data == null) return loading ?? const _CentredLoader();

    return onData(data);
  }
}

/// Coerces an error caught by Riverpod back into an [AppFailure].
///
/// Repositories only ever throw [AppFailure], but a provider body can raise
/// something else; anything unrecognised becomes a generic failure rather than
/// reaching the worker as a type name.
AppFailure asFailure(Object? error) =>
    error is AppFailure ? error : const UnexpectedFailure();

/// A failure, phrased for the worker, with a retry only where one would help.
class FailureView extends StatelessWidget {
  const FailureView({
    required this.failure,
    required this.onRetry,
    this.compact = false,
    super.key,
  });

  final AppFailure failure;
  final VoidCallback onRetry;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final icon = switch (failure) {
      NetworkFailure() || TimeoutFailure() => Icons.wifi_off_rounded,
      PermissionFailure() => Icons.lock_outline_rounded,
      NotFoundFailure() => Icons.search_off_rounded,
      ConflictFailure() => Icons.person_search_outlined,
      _ => Icons.error_outline_rounded,
    };

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: compact ? 32 : 48, color: context.inkTertiary),
        const SizedBox(height: AppSpacing.lg),
        Text(
          failure.message,
          textAlign: TextAlign.center,
          style: AppTypography.bodyLarge.copyWith(color: context.inkSecondary),
        ),
        // Eligibility refusals arrive with a list of things the worker can
        // actually do. Showing them turns a dead end into a task list.
        if (failure is PermissionFailure &&
            (failure as PermissionFailure).reasons.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          for (final reason in (failure as PermissionFailure).reasons)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.radio_button_unchecked,
                      size: 18, color: context.inkTertiary),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(reason.message, style: AppTypography.bodyMedium),
                  ),
                ],
              ),
            ),
        ],
        if (failure.isRetryable) ...[
          const SizedBox(height: AppSpacing.xl),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: Text(context.l10n.commonTryAgain),
          ),
        ],
      ],
    );

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: content,
        ),
      ),
    );
  }
}

/// An empty state.
///
/// Empty means the server returned nothing, and the copy says so plainly. It
/// never shows sample content to make a screen look populated.
class EmptyStateView extends StatelessWidget {
  const EmptyStateView({
    required this.icon,
    required this.title,
    required this.message,
    this.action,
    this.actionLabel,
    super.key,
  });

  final IconData icon;
  final String title;
  final String message;
  final VoidCallback? action;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: context.surfaceMuted,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 32, color: context.inkTertiary),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTypography.titleLarge.copyWith(color: context.ink),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                message,
                textAlign: TextAlign.center,
                style:
                    AppTypography.bodyMedium.copyWith(color: context.inkSecondary),
              ),
              if (action != null && actionLabel != null) ...[
                const SizedBox(height: AppSpacing.xl),
                FilledButton(onPressed: action, child: Text(actionLabel!)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _CentredLoader extends StatelessWidget {
  const _CentredLoader();

  @override
  Widget build(BuildContext context) => const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xxxl),
          child: CircularProgressIndicator(strokeWidth: 2.5),
        ),
      );
}

/// A placeholder shown while a list loads, shaped like the content that will
/// replace it so the layout does not jump.
class ListSkeleton extends StatelessWidget {
  const ListSkeleton({this.itemCount = 3, this.itemHeight = 96, super.key});

  final int itemCount;
  final double itemHeight;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      itemCount: itemCount,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (_, __) => Container(
        height: itemHeight,
        decoration: BoxDecoration(
          color: context.surfaceMuted,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),
    );
  }
}

/// A banner shown when the device has no connection.
///
/// Says which operations are unavailable rather than letting the worker
/// discover it by tapping something that silently does nothing.
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({this.message, super.key});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      color: AppColors.warningSurface,
      child: Row(
        children: [
          const Icon(Icons.cloud_off_rounded,
              size: 20, color: AppColors.warning),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message ?? context.l10n.offlineBanner,
              style: AppTypography.bodySmall.copyWith(color: AppColors.warning),
            ),
          ),
        ],
      ),
    );
  }
}
