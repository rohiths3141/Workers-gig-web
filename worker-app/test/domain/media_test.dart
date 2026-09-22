import 'package:flutter_test/flutter_test.dart';
import 'package:wervexa_worker/domain/entities/enums.dart';
import 'package:wervexa_worker/domain/entities/media.dart';

/// These limits mirror `public.media_purpose_rules` exactly. Checking on the
/// client saves a worker on a slow connection three minutes of uploading a file
/// the server will refuse; the server checks again regardless.
void main() {
  group('Constraints match the database rules', () {
    test('a KYC document allows images and PDF up to 15MB', () {
      final rules =
          MediaConstraints.forPurpose(MediaPurpose.workerKycDocument);

      expect(rules.maxSizeBytes, 15728640);
      expect(rules.allowsMimeType('image/jpeg'), isTrue);
      expect(rules.allowsMimeType('application/pdf'), isTrue);
      expect(rules.allowsMimeType('video/mp4'), isFalse);
    });

    test('job evidence allows video up to 100MB', () {
      final rules =
          MediaConstraints.forPurpose(MediaPurpose.bookingAfterWork);

      expect(rules.maxSizeBytes, 104857600);
      expect(rules.allowsMimeType('video/mp4'), isTrue);
      expect(rules.allowsMimeType('video/quicktime'), isTrue);
    });

    test('a profile photo is images only, up to 5MB', () {
      final rules =
          MediaConstraints.forPurpose(MediaPurpose.workerProfilePhoto);

      expect(rules.maxSizeBytes, 5242880);
      expect(rules.allowsMimeType('application/pdf'), isFalse);
    });

    test('every purpose a worker can use has a rule', () {
      for (final purpose in MediaPurpose.values) {
        final rules = MediaConstraints.forPurpose(purpose);
        expect(rules.allowedMimeTypes, isNotEmpty, reason: '$purpose');
        expect(rules.maxSizeBytes, greaterThan(0), reason: '$purpose');
      }
    });
  });

  group('Rejection messages are written for the worker', () {
    final rules = MediaConstraints.forPurpose(MediaPurpose.bookingAfterWork);

    test('accepts a valid file', () {
      expect(rules.rejectionReason('image/jpeg', 2048000), isNull);
    });

    test('names the accepted types when the type is wrong', () {
      final reason = rules.rejectionReason('application/zip', 1000);
      expect(reason, isNotNull);
      expect(reason, contains('not accepted'));
      expect(reason, contains('JPEG'));
      // No MIME strings and no error codes.
      expect(reason, isNot(contains('application/zip')));
    });

    test('names the limit in megabytes when the file is too large', () {
      final reason = rules.rejectionReason('image/jpeg', 200000000);
      expect(reason, contains('100MB'));
      expect(reason, isNot(contains('104857600')));
    });

    test('rejects an empty file', () {
      expect(rules.rejectionReason('image/jpeg', 0), contains('empty'));
    });
  });

  group('Only a completed upload counts as evidence', () {
    test('a pending upload is not usable', () {
      expect(MediaUploadStatus.pending.isUsable, isFalse);
      expect(MediaUploadStatus.uploading.isUsable, isFalse);
      expect(MediaUploadStatus.failed.isUsable, isFalse);
      // A quarantined file is emphatically not evidence.
      expect(MediaUploadStatus.quarantined.isUsable, isFalse);
    });

    test('a completed upload is', () {
      expect(MediaUploadStatus.completed.isUsable, isTrue);
    });
  });

  group('Upload progress', () {
    UploadTask task({
      int sent = 0,
      int total = 1000,
      UploadState state = UploadState.uploading,
    }) =>
        UploadTask(
          localId: 'u1',
          purpose: MediaPurpose.bookingAfterWork,
          fileName: 'after.jpg',
          totalBytes: total,
          bytesTransferred: sent,
          state: state,
        );

    test('reports real progress from bytes sent', () {
      expect(task(sent: 250).progress, 0.25);
      expect(task(sent: 1000).progress, 1.0);
    });

    test('never exceeds 1 or divides by zero', () {
      expect(task(sent: 2000).progress, 1.0);
      expect(task(total: 0).progress, 0.0);
    });

    test('a failed upload offers a retry', () {
      expect(task(state: UploadState.failed).canRetry, isTrue);
      expect(task(state: UploadState.uploading).canRetry, isFalse);
    });

    test('terminal states stop the progress UI', () {
      expect(task(state: UploadState.completed).isTerminal, isTrue);
      expect(task(state: UploadState.cancelled).isTerminal, isTrue);
      expect(task(state: UploadState.uploading).isTerminal, isFalse);
    });
  });
}
