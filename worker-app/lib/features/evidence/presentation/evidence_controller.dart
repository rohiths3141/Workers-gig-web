import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../app/providers/providers.dart';
import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../../../domain/entities/enums.dart';
import '../../../domain/entities/media.dart';
import '../../../core/localization/app_locale.dart';

/// Capture and upload of job evidence.
///
/// Real camera and gallery capture, uploaded to Supabase Storage through the
/// server-authorized pipeline. The previous application asked the worker to
/// paste a URL into a text box, which meant "evidence" could be anything or
/// nothing; here the bytes go up and the server confirms they landed before the
/// asset counts.
class EvidenceController extends AutoDisposeFamilyAsyncNotifier<
    List<UploadTask>, EvidenceTarget> {
  late final ImagePicker _picker = ImagePicker();

  @override
  Future<List<UploadTask>> build(EvidenceTarget arg) async => const [];

  /// Takes a photo with the camera.
  ///
  /// `preferredCameraDevice` is the rear camera and image quality is capped
  /// before the file even reaches disk, which matters on a phone with little
  /// free space.
  Future<Result<void>> capturePhoto() async {
    final file = await _pick(ImageSource.camera);
    return file == null ? const Ok(null) : _upload(file);
  }

  Future<Result<void>> pickFromGallery() async {
    final file = await _pick(ImageSource.gallery);
    return file == null ? const Ok(null) : _upload(file);
  }

  /// Records a short video. Capped at two minutes: longer clips are large,
  /// slow to upload on mobile data, and rarely tell an assessor more.
  Future<Result<void>> captureVideo() async {
    try {
      final picked = await _picker.pickVideo(
        source: ImageSource.camera,
        maxDuration: const Duration(minutes: 2),
      );
      if (picked == null) return const Ok(null);
      return _upload(File(picked.path));
    } catch (error) {
      return Err(UploadFailure(
        message: AppStrings.current.cameraOpenFailed,
        debugDetail: error.toString(),
      ));
    }
  }

  Future<File?> _pick(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        imageQuality: 88,
        maxWidth: 2400,
        preferredCameraDevice: CameraDevice.rear,
      );
      return picked == null ? null : File(picked.path);
    } catch (_) {
      return null;
    }
  }

  Future<Result<void>> _upload(File file) async {
    final media = ref.read(mediaRepositoryProvider);
    final tasks = [...(state.valueOrNull ?? const <UploadTask>[])];

    AppFailure? failure;

    await for (final task in media.upload(
      file: file,
      purpose: arg.purpose,
      bookingId: arg.bookingId,
      materialId: arg.materialId,
      capturedAt: DateTime.now(),
    )) {
      final index = tasks.indexWhere((t) => t.localId == task.localId);
      if (index >= 0) {
        tasks[index] = task;
      } else {
        tasks.add(task);
      }

      // Progress is published as it arrives so the worker sees real movement.
      state = AsyncData(List.unmodifiable(tasks));

      if (task.state == UploadState.failed) {
        failure = UploadFailure(
          message: task.failure ?? AppStrings.current.uploadDidNotFinish,
          isResumable: true,
        );
      }
    }

    // The asset list is only re-read on success: a failed upload created
    // nothing to show.
    if (failure == null) ref.invalidate(evidenceAssetsProvider(arg));

    return failure == null ? const Ok(null) : Err(failure);
  }

  Future<Result<void>> retry(String localId) async {
    final result = await ref.read(mediaRepositoryProvider).retry(localId);
    ref.invalidate(evidenceAssetsProvider(arg));
    return result.map((_) {});
  }

  Future<void> cancel(String localId) async {
    await ref.read(mediaRepositoryProvider).cancel(localId);
    final tasks = [...(state.valueOrNull ?? const <UploadTask>[])]
      ..removeWhere((t) => t.localId == localId);
    state = AsyncData(List.unmodifiable(tasks));
  }
}

/// What the evidence is attached to.
class EvidenceTarget {
  const EvidenceTarget({
    required this.purpose,
    this.bookingId,
    this.materialId,
  });

  final MediaPurpose purpose;
  final String? bookingId;
  final String? materialId;

  @override
  bool operator ==(Object other) =>
      other is EvidenceTarget &&
      other.purpose == purpose &&
      other.bookingId == bookingId &&
      other.materialId == materialId;

  @override
  int get hashCode => Object.hash(purpose, bookingId, materialId);
}

final evidenceControllerProvider = AsyncNotifierProvider.autoDispose
    .family<EvidenceController, List<UploadTask>, EvidenceTarget>(
        EvidenceController.new);

/// Assets already uploaded for this target.
final evidenceAssetsProvider = FutureProvider.autoDispose
    .family<List<MediaAsset>, EvidenceTarget>((ref, target) async {
  final result = await ref.watch(mediaRepositoryProvider).getAssets(
        bookingId: target.bookingId,
        purpose: target.purpose,
      );

  return result.fold(
    // Only completed uploads count as evidence. A pending row is not proof of
    // anything, and the server takes the same view.
    (assets) => assets.where((a) => a.isUsable).toList(growable: false),
    (failure) => throw failure,
  );
});
