import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../domain/entities/media.dart';
import '../../../shared/widgets/common_widgets.dart';
import 'evidence_controller.dart';

/// Photo and video evidence for one stage of a job.
///
/// Shows what has actually been uploaded and what is still going up, with real
/// progress. An upload that fails says so and offers a retry rather than
/// quietly disappearing.
class EvidenceSection extends ConsumerWidget {
  const EvidenceSection({
    required this.target,
    required this.title,
    required this.explanation,
    this.allowVideo = false,
    this.isRequired = false,
    super.key,
  });

  final EvidenceTarget target;
  final String title;
  final String explanation;
  final bool allowVideo;
  final bool isRequired;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uploads = ref.watch(evidenceControllerProvider(target)).valueOrNull ??
        const <UploadTask>[];
    final assets = ref.watch(evidenceAssetsProvider(target));

    final inFlight = uploads.where((u) => !u.isTerminal).toList();
    final uploaded = assets.valueOrNull ?? const <MediaAsset>[];
    final hasAny = uploaded.isNotEmpty;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(title,
                    style:
                        AppTypography.titleMedium.copyWith(color: context.ink)),
              ),
              if (isRequired)
                StatusBadge(
                  label: hasAny ? 'DONE' : 'REQUIRED',
                  color: hasAny ? AppColors.success : AppColors.warning,
                  icon: hasAny
                      ? Icons.check_circle_outline
                      : Icons.priority_high_rounded,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(explanation,
              style:
                  AppTypography.bodySmall.copyWith(color: context.inkSecondary)),
          const SizedBox(height: AppSpacing.lg),

          if (uploaded.isNotEmpty) ...[
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final asset in uploaded)
                  _AssetThumbnail(asset: asset),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
          ],

          for (final upload in inFlight)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: _UploadProgress(
                task: upload,
                onCancel: () => ref
                    .read(evidenceControllerProvider(target).notifier)
                    .cancel(upload.localId),
              ),
            ),

          for (final upload in uploads.where((u) => u.state == UploadState.failed))
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: _UploadFailed(
                task: upload,
                onRetry: () => ref
                    .read(evidenceControllerProvider(target).notifier)
                    .retry(upload.localId),
                onDismiss: () => ref
                    .read(evidenceControllerProvider(target).notifier)
                    .cancel(upload.localId),
              ),
            ),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _capture(context, ref, _Source.camera),
                  icon: const Icon(Icons.photo_camera_outlined),
                  label: const Text('Camera'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _capture(context, ref, _Source.gallery),
                  icon: const Icon(Icons.photo_library_outlined),
                  label: const Text('Gallery'),
                ),
              ),
              if (allowVideo) ...[
                const SizedBox(width: AppSpacing.sm),
                OutlinedButton(
                  onPressed: () => _capture(context, ref, _Source.video),
                  // The outlined button theme asks for infinite minimum width,
                  // which a Row cannot give: square it off instead.
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(
                        AppSpacing.minTouchTarget, AppSpacing.minTouchTarget),
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md),
                  ),
                  child: const Icon(Icons.videocam_outlined),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _capture(
    BuildContext context,
    WidgetRef ref,
    _Source source,
  ) async {
    final controller = ref.read(evidenceControllerProvider(target).notifier);

    final result = await switch (source) {
      _Source.camera => controller.capturePhoto(),
      _Source.gallery => controller.pickFromGallery(),
      _Source.video => controller.captureVideo(),
    };

    if (!context.mounted) return;
    result.fold((_) {}, (failure) => showFailure(context, failure.message));
  }
}

enum _Source { camera, gallery, video }

class _AssetThumbnail extends StatelessWidget {
  const _AssetThumbnail({required this.asset});

  final MediaAsset asset;

  @override
  Widget build(BuildContext context) {
    // A signed URL would be needed to render the actual image, and each one is
    // a server round trip that expires in minutes. For a confirmation strip a
    // typed tile is enough, and it costs nothing on a slow connection.
    return Container(
      width: 76,
      height: 76,
      decoration: BoxDecoration(
        color: AppColors.successSurface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            asset.isVideo ? Icons.videocam_rounded : Icons.photo_rounded,
            color: AppColors.success,
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text('Saved',
              style: AppTypography.badge.copyWith(color: AppColors.success)),
        ],
      ),
    );
  }
}

class _UploadProgress extends StatelessWidget {
  const _UploadProgress({required this.task, required this.onCancel});

  final UploadTask task;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final label = switch (task.state) {
      UploadState.queued => 'Waiting',
      UploadState.compressing => 'Preparing',
      UploadState.authorizing => 'Starting upload',
      UploadState.uploading => '${(task.progress * 100).round()}%',
      UploadState.confirming => 'Finishing',
      _ => '',
    };

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  task.fileName,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodySmall.copyWith(color: context.ink),
                ),
              ),
              Text(label,
                  style: AppTypography.badge.copyWith(color: context.inkSecondary)),
              IconButton(
                onPressed: onCancel,
                icon: const Icon(Icons.close_rounded, size: 18),
                tooltip: 'Cancel upload',
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: LinearProgressIndicator(
              // Indeterminate until bytes are actually moving: a bar that
              // claims progress before the upload has started is a lie.
              value: task.state == UploadState.uploading ? task.progress : null,
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}

class _UploadFailed extends StatelessWidget {
  const _UploadFailed({
    required this.task,
    required this.onRetry,
    required this.onDismiss,
  });

  final UploadTask task;
  final VoidCallback onRetry;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.dangerSurface,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded,
              size: 20, color: AppColors.danger),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              task.failure ?? 'That upload did not finish.',
              style:
                  AppTypography.bodySmall.copyWith(color: AppColors.danger),
            ),
          ),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
          IconButton(
            onPressed: onDismiss,
            icon: const Icon(Icons.close_rounded, size: 18),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}
