import 'enums.dart';

/// A file held in Supabase Storage, recorded in the media_assets table.
///
/// The app never holds a storage path it made up. A path arrives from the
/// server, which builds it from the purpose rule and the owning resource id,
/// and `enforce_media_asset_integrity()` rejects anything else.
class MediaAsset {
  const MediaAsset({
    required this.id,
    required this.purpose,
    required this.uploadStatus,
    required this.mimeType,
    required this.fileSizeBytes,
    required this.originalFileName,
    required this.createdAt,
    this.bookingId,
    this.workerId,
    this.materialId,
    this.capturedAt,
    this.width,
    this.height,
    this.durationSeconds,
  });

  final String id;
  final MediaPurpose purpose;
  final MediaUploadStatus uploadStatus;
  final String mimeType;
  final int fileSizeBytes;
  final String originalFileName;
  final String? bookingId;
  final String? workerId;
  final String? materialId;
  final DateTime? capturedAt;
  final DateTime createdAt;
  final int? width;
  final int? height;
  final double? durationSeconds;

  bool get isImage => mimeType.startsWith('image/');
  bool get isVideo => mimeType.startsWith('video/');

  /// Only a completed upload counts. A pending row is not evidence.
  bool get isUsable => uploadStatus.isUsable;
}

/// An upload in flight.
///
/// Progress is real: it comes from bytes actually acknowledged by Firebase
/// Storage, not from a timer. A worker on a weak connection watching a fake
/// progress bar reach 100% and then fail is worse than seeing it stall.
class UploadTask {
  const UploadTask({
    required this.localId,
    required this.purpose,
    required this.fileName,
    required this.totalBytes,
    required this.state,
    this.mediaAssetId,
    this.bytesTransferred = 0,
    this.failure,
    this.bookingId,
  });

  /// Client-side id, stable across retries and app restarts.
  final String localId;

  final MediaPurpose purpose;
  final String fileName;
  final int totalBytes;
  final int bytesTransferred;
  final UploadState state;

  /// Assigned once the server has authorized the upload.
  final String? mediaAssetId;

  final String? bookingId;
  final String? failure;

  double get progress =>
      totalBytes == 0 ? 0 : (bytesTransferred / totalBytes).clamp(0.0, 1.0);

  bool get isTerminal =>
      state == UploadState.completed || state == UploadState.cancelled;

  bool get canRetry =>
      state == UploadState.failed || state == UploadState.cancelled;

  UploadTask copyWith({
    UploadState? state,
    int? bytesTransferred,
    String? mediaAssetId,
    String? failure,
  }) =>
      UploadTask(
        localId: localId,
        purpose: purpose,
        fileName: fileName,
        totalBytes: totalBytes,
        state: state ?? this.state,
        bytesTransferred: bytesTransferred ?? this.bytesTransferred,
        mediaAssetId: mediaAssetId ?? this.mediaAssetId,
        bookingId: bookingId,
        failure: failure ?? this.failure,
      );
}

enum UploadState {
  /// Picked and validated, not yet sent.
  queued,

  /// Shrinking before sending, so a 12MP photo does not cost the worker 8MB of
  /// their data plan.
  compressing,

  /// Asking the server to authorize and allocate a storage path.
  authorizing,

  uploading,

  /// Bytes are up; telling the server to mark the asset COMPLETED.
  confirming,

  completed,
  failed,
  cancelled,
}

/// What may be uploaded for a given purpose.
///
/// These mirror `public.media_purpose_rules` exactly. Checking on the client is
/// a courtesy — it saves a worker on a slow connection from spending three
/// minutes uploading a file the server will refuse — and the server checks
/// again regardless.
class MediaConstraints {
  const MediaConstraints({
    required this.allowedMimeTypes,
    required this.maxSizeBytes,
  });

  final List<String> allowedMimeTypes;
  final int maxSizeBytes;

  static const _image = ['image/jpeg', 'image/png', 'image/webp'];
  static const _imageAndVideo = [
    'image/jpeg',
    'image/png',
    'image/webp',
    'video/mp4',
    'video/quicktime',
  ];
  static const _document = [
    'image/jpeg',
    'image/png',
    'image/webp',
    'application/pdf',
  ];

  static const _fiveMb = 5242880;
  static const _tenMb = 10485760;
  static const _fifteenMb = 15728640;
  static const _hundredMb = 104857600;

  static MediaConstraints forPurpose(MediaPurpose purpose) => switch (purpose) {
        MediaPurpose.workerProfilePhoto =>
          const MediaConstraints(allowedMimeTypes: _image, maxSizeBytes: _fiveMb),
        MediaPurpose.workerKycDocument ||
        MediaPurpose.workerQualification ||
        MediaPurpose.workerRplCredential =>
          const MediaConstraints(
              allowedMimeTypes: _document, maxSizeBytes: _fifteenMb),
        MediaPurpose.workerInsuranceDocument => const MediaConstraints(
            allowedMimeTypes: ['image/jpeg', 'image/png', 'application/pdf'],
            maxSizeBytes: _fifteenMb),
        MediaPurpose.bookingBeforeWork ||
        MediaPurpose.bookingDuringWork ||
        MediaPurpose.bookingAfterWork =>
          const MediaConstraints(
              allowedMimeTypes: _imageAndVideo, maxSizeBytes: _hundredMb),
        MediaPurpose.bookingArrivalProof ||
        MediaPurpose.bookingMaterialPhoto =>
          const MediaConstraints(allowedMimeTypes: _image, maxSizeBytes: _tenMb),
        MediaPurpose.bookingReceipt =>
          const MediaConstraints(allowedMimeTypes: _document, maxSizeBytes: _tenMb),
        MediaPurpose.claimEvidence => const MediaConstraints(
            allowedMimeTypes: [
              'image/jpeg',
              'image/png',
              'image/webp',
              'video/mp4',
              'application/pdf',
            ],
            maxSizeBytes: _hundredMb),
        MediaPurpose.supportAttachment => const MediaConstraints(
            allowedMimeTypes: [..._document, 'text/plain'],
            maxSizeBytes: 20971520),
        // Purposes this app can receive but never uploads: a background check
        // filed by operations, a customer's own photo, a catalogue image, a
        // photo on a customer's request. They still need an answer, because
        // this is a total function over the enum and a screen that merely
        // displayed one would otherwise have nothing to ask.
        MediaPurpose.workerBackgroundCheck => const MediaConstraints(
            allowedMimeTypes: _document, maxSizeBytes: _fifteenMb),
        MediaPurpose.customerProfilePhoto ||
        MediaPurpose.serviceCatalogueImage =>
          const MediaConstraints(allowedMimeTypes: _image, maxSizeBytes: _fiveMb),
        MediaPurpose.serviceRequestPhoto =>
          const MediaConstraints(allowedMimeTypes: _image, maxSizeBytes: _tenMb),
      };

  bool allowsMimeType(String mimeType) =>
      allowedMimeTypes.contains(mimeType.toLowerCase());

  bool allowsSize(int bytes) => bytes > 0 && bytes <= maxSizeBytes;

  /// A refusal written for the worker, or null when the file is acceptable.
  String? rejectionReason(String mimeType, int bytes) {
    if (!allowsMimeType(mimeType)) {
      final kinds = allowedMimeTypes
          .map((m) => m.split('/').last.toUpperCase())
          .toSet()
          .join(', ');
      return 'That file type is not accepted here. Use $kinds.';
    }
    if (bytes <= 0) return 'That file is empty.';
    if (bytes > maxSizeBytes) {
      final mb = (maxSizeBytes / 1048576).round();
      return 'That file is too large. The limit is ${mb}MB.';
    }
    return null;
  }
}
