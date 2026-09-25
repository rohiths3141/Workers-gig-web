import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/localization/l10n.dart';
import '../../domain/entities/enums.dart';

/// A card. Hairline border on a tinted ground rather than a shadow — shadows
/// cost a render pass and disappear in sunlight.
class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.borderColor,
    this.backgroundColor,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets padding;
  final Color? borderColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final decorated = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? context.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: borderColor ?? context.border),
      ),
      child: child,
    );

    if (onTap == null) return decorated;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: decorated,
      ),
    );
  }
}

/// A status pill. Always carries a word, never colour alone — colour-blind
/// workers and bright sunlight both defeat a colour-only signal.
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    required this.label,
    required this.color,
    this.icon,
    this.backgroundColor,
    super.key,
  });

  // Badge words are upper-cased for display. That changes English and leaves
  // the Indian scripts, which have no case, exactly as written.

  factory StatusBadge.forBooking(BookingStatus status) {
    final color = switch (status) {
      BookingStatus.requested || BookingStatus.accepted => AppColors.info,
      BookingStatus.confirmed ||
      BookingStatus.traveling ||
      BookingStatus.arrived =>
        AppColors.primary,
      BookingStatus.inProgress ||
      BookingStatus.awaitingApproval ||
      BookingStatus.paymentPending =>
        AppColors.warning,
      BookingStatus.completed || BookingStatus.paid => AppColors.success,
      BookingStatus.cancelled || BookingStatus.disputed => AppColors.danger,
      BookingStatus.closed || BookingStatus.expired => AppColors.inkTertiary,
    };
    return StatusBadge(
      label: bookingStatusLabel(AppStrings.current, status).toUpperCase(),
      color: color,
    );
  }

  factory StatusBadge.forGig(GigStatus status) {
    final l10n = AppStrings.current;
    final (label, color, icon) = switch (status) {
      GigStatus.draft => (l10n.badgeDraft, AppColors.inkTertiary, Icons.edit_outlined),
      GigStatus.pendingReview =>
        (l10n.badgeInReview, AppColors.warning, Icons.hourglass_empty_rounded),
      GigStatus.active => (l10n.badgeLive, AppColors.available, Icons.check_circle_outline),
      GigStatus.paused => (l10n.badgePaused, AppColors.inkTertiary, Icons.pause_circle_outline),
      GigStatus.rejected => (l10n.badgeNotApproved, AppColors.danger, Icons.cancel_outlined),
      GigStatus.archived => (l10n.badgeRemoved, AppColors.inkTertiary, Icons.archive_outlined),
    };
    return StatusBadge(label: label.toUpperCase(), color: color, icon: icon);
  }

  factory StatusBadge.forVerification(VerificationStatus status) {
    final l10n = AppStrings.current;
    final (label, color, icon) = switch (status) {
      VerificationStatus.notSubmitted =>
        (l10n.badgeNotStarted, AppColors.inkTertiary, Icons.radio_button_unchecked),
      VerificationStatus.pending =>
        (l10n.badgeSubmitted, AppColors.info, Icons.schedule_rounded),
      VerificationStatus.underReview =>
        (l10n.badgeInReview, AppColors.info, Icons.visibility_outlined),
      VerificationStatus.moreInfoRequired =>
        (l10n.badgeActionNeeded, AppColors.warning, Icons.priority_high_rounded),
      VerificationStatus.approved =>
        (l10n.badgeVerified, AppColors.success, Icons.verified_rounded),
      VerificationStatus.rejected =>
        (l10n.badgeNotApproved, AppColors.danger, Icons.cancel_outlined),
      VerificationStatus.expired =>
        (l10n.badgeExpired, AppColors.warning, Icons.update_rounded),
      VerificationStatus.notApplicable =>
        (l10n.badgeNotRequired, AppColors.inkTertiary, Icons.remove_rounded),
    };
    return StatusBadge(label: label.toUpperCase(), color: color, icon: icon);
  }

  final String label;
  final Color color;
  final IconData? icon;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs + 2,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: AppSpacing.xs + 2),
          ],
          Flexible(
            child: Text(
              label,
              style: AppTypography.badge.copyWith(color: color),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}

/// A booking status in the worker's words, in the language on screen.
String bookingStatusLabel(AppLocalizations l10n, BookingStatus status) =>
    switch (status) {
      BookingStatus.requested => l10n.badgeNew,
      BookingStatus.accepted => l10n.badgeAccepted,
      BookingStatus.confirmed => l10n.badgeConfirmed,
      BookingStatus.traveling => l10n.badgeOnTheWay,
      BookingStatus.arrived => l10n.badgeArrived,
      BookingStatus.inProgress => l10n.badgeWorking,
      BookingStatus.awaitingApproval => l10n.badgeAwaitingCustomer,
      BookingStatus.completed => l10n.badgeDone,
      BookingStatus.paymentPending => l10n.badgePaymentDue,
      BookingStatus.paid => l10n.badgePaid,
      BookingStatus.closed => l10n.badgeClosed,
      BookingStatus.cancelled => l10n.badgeCancelled,
      BookingStatus.disputed => l10n.badgeDisputed,
      BookingStatus.expired => l10n.badgeExpired,
    };

/// A section heading with an optional trailing action.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.title,
    this.action,
    this.actionLabel,
    this.subtitle,
    super.key,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? action;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.titleLarge.copyWith(color: context.ink)),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    subtitle!,
                    style: AppTypography.bodySmall
                        .copyWith(color: context.inkSecondary),
                  ),
                ],
              ],
            ),
          ),
          if (action != null && actionLabel != null)
            TextButton(onPressed: action, child: Text(actionLabel!)),
        ],
      ),
    );
  }
}

/// A label and value on one line, for detail lists.
class DetailRow extends StatelessWidget {
  const DetailRow({
    required this.label,
    required this.value,
    this.icon,
    this.valueStyle,
    super.key,
  });

  final String label;
  final String value;
  final IconData? icon;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20, color: context.inkTertiary),
            const SizedBox(width: AppSpacing.md),
          ],
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: AppTypography.bodyMedium.copyWith(color: context.inkSecondary),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              value,
              style: valueStyle ??
                  AppTypography.bodyMedium.copyWith(
                    color: context.ink,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A worker's avatar, falling back to initials rather than a stock silhouette.
class WorkerAvatar extends StatelessWidget {
  const WorkerAvatar({
    required this.name,
    this.photoUrl,
    this.size = 44,
    super.key,
  });

  final String name;
  final String? photoUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    final initials = _initialsOf(name);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primarySurface,
        image: photoUrl == null
            ? null
            : DecorationImage(
                image: NetworkImage(photoUrl!),
                fit: BoxFit.cover,
              ),
      ),
      alignment: Alignment.center,
      child: photoUrl != null
          ? null
          : Text(
              initials,
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.primaryDark,
                fontSize: size * 0.36,
              ),
            ),
    );
  }

  static String _initialsOf(String name) {
    final parts =
        name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}

/// A progress bar with a label, for profile completion and similar.
class LabelledProgress extends StatelessWidget {
  const LabelledProgress({
    required this.label,
    required this.value,
    this.trailing,
    super.key,
  });

  final String label;
  final double value;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(label,
                  style: AppTypography.label.copyWith(color: context.inkSecondary)),
            ),
            Text(
              trailing ?? '${(value * 100).round()}%',
              style: AppTypography.label.copyWith(color: context.ink),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          child: LinearProgressIndicator(
            value: value.clamp(0.0, 1.0),
            minHeight: 8,
            backgroundColor: context.surfaceMuted,
          ),
        ),
      ],
    );
  }
}

/// A primary action that shows it is working.
///
/// A plain [FilledButton] with `onPressed: null` while busy goes grey, and a
/// white spinner on grey reads as a disabled button rather than a working
/// one. This keeps the filled colours while busy, so the spinner stays
/// legible, and still refuses taps.
class BusyFilledButton extends StatelessWidget {
  const BusyFilledButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.busy = false,
    this.busyLabel,
  });

  final String label;

  /// Null disables the button for real (nothing to submit yet).
  final VoidCallback? onPressed;
  final bool busy;

  /// Shown beside the spinner while busy. Omit for the spinner alone.
  final String? busyLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (!busy) {
      return FilledButton(onPressed: onPressed, child: Text(label));
    }

    return FilledButton(
      onPressed: null,
      style: FilledButton.styleFrom(
        disabledBackgroundColor: scheme.primary,
        disabledForegroundColor: scheme.onPrimary,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(scheme.onPrimary),
            ),
          ),
          if (busyLabel != null) ...[
            const SizedBox(width: AppSpacing.sm),
            Flexible(
              child: Text(
                busyLabel!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// A destructive or significant action, confirmed before it runs.
Future<bool> confirmAction(
  BuildContext context, {
  required String title,
  required String message,
  String? confirmLabel,
  String? cancelLabel,
  bool isDestructive = false,
}) async {
  final l10n = context.l10n;
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelLabel ?? l10n.commonCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: isDestructive
              ? FilledButton.styleFrom(backgroundColor: AppColors.danger)
              : null,
          child: Text(confirmLabel ?? l10n.commonConfirm),
        ),
      ],
    ),
  );
  return result ?? false;
}

/// A snack bar that floats clear of the content underneath.
///
/// The default fixed behaviour parks a full-width bar against the bottom of
/// the body, where it sat on top of the next onboarding step card and hid the
/// thing the worker had just been told to do. Floating with a margin keeps
/// the card readable and reads as the transient message it is.
SnackBar _floatingSnackBar(
  String message,
  Color background,
  Duration duration,
) {
  return SnackBar(
    content: Text(message),
    backgroundColor: background,
    duration: duration,
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.all(AppSpacing.md),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.sm),
    ),
  );
}

/// Shows a failure to the worker. Always the [AppFailure] message, which is
/// already plain language — never a raw error or a code.
void showFailure(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(_floatingSnackBar(
      message,
      AppColors.danger,
      const Duration(seconds: 5),
    ));
}

void showSuccess(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(_floatingSnackBar(
      message,
      AppColors.success,
      const Duration(seconds: 3),
    ));
}
