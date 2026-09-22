import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../core/errors/app_failure.dart';
import '../../core/errors/failure_mapper.dart';
import '../../core/errors/result.dart';
import '../../core/logging/app_logger.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/media.dart';
import '../../domain/repositories/repositories.dart';
import '../mappers/mappers.dart';

/// Upload and retrieval of files.
///
/// Files live in a private Supabase Storage bucket with no client-facing
/// policies, deliberately so: a storage policy cannot know who is a party to a
/// booking or which administrator holds `workers.documents.read`. So nothing
/// here writes to Storage directly. Every upload is:
///
///   1. validated against the same limits the server enforces
///   2. compressed, so a 12MP photo does not cost the worker 8MB of data
///   3. authorized by the trusted web tier, which builds the storage path
///      itself and creates the media_assets row PENDING
///   4. PUT to a short-lived signed URL
///   5. confirmed, at which point the server checks the object really exists
///      and marks the row COMPLETED
///
/// The client never chooses a path, and a row is never COMPLETED because the
/// client said so. That is what makes it impossible to register a file against
/// another worker's KYC folder, and what makes "evidence uploaded" mean the
/// bytes are actually there.
final class SupabaseMediaRepository implements MediaRepository {
  SupabaseMediaRepository({
    required SupabaseClient db,
    required String apiBaseUrl,
    required Future<String?> Function() idTokenProvider,
    http.Client? httpClient,
  })  : _db = db,
        _apiBaseUrl = apiBaseUrl,
        _idToken = idTokenProvider,
        _http = httpClient ?? http.Client();

  static const _log = AppLogger('MediaRepository');
  static const _uuid = Uuid();

  final SupabaseClient _db;
  final String _apiBaseUrl;
  final Future<String?> Function() _idToken;
  final http.Client _http;

  /// In-flight and recently failed uploads, so a retry has something to resume.
  final Map<String, _PendingUpload> _tasks = {};

  @override
  Stream<UploadTask> upload({
    required File file,
    required MediaPurpose purpose,
    String? bookingId,
    String? materialId,
    String? gigId,
    String? ticketId,
    DateTime? capturedAt,
  }) async* {
    final localId = _uuid.v4();
    final fileName = p.basename(file.path);
    final mimeType = _mimeTypeFor(fileName);

    // Everything that decides where the server files this asset, kept together
    // so a retry can present the same request rather than a narrower one.
    final target = _UploadTarget(
      bookingId: bookingId,
      materialId: materialId,
      gigId: gigId,
      ticketId: ticketId,
      capturedAt: capturedAt,
    );

    var task = UploadTask(
      localId: localId,
      purpose: purpose,
      fileName: fileName,
      totalBytes: await file.length(),
      state: UploadState.queued,
      bookingId: bookingId,
    );
    yield task;

    try {
      // --- 1. Validate before spending the worker's data ------------------
      final constraints = MediaConstraints.forPurpose(purpose);
      final rejection =
          constraints.rejectionReason(mimeType, task.totalBytes);
      if (rejection != null) {
        yield task = task.copyWith(
          state: UploadState.failed,
          failure: rejection,
        );
        return;
      }

      // --- 2. Compress ---------------------------------------------------
      var payload = file;
      if (mimeType.startsWith('image/')) {
        yield task = task.copyWith(state: UploadState.compressing);
        payload = await _compressImage(file) ?? file;
        task = task.copyWith(bytesTransferred: 0);
      }

      final bytes = await payload.length();
      task = UploadTask(
        localId: localId,
        purpose: purpose,
        fileName: fileName,
        totalBytes: bytes,
        state: UploadState.authorizing,
        bookingId: bookingId,
      );
      yield task;

      // --- 3. Ask the server to authorize and allocate a path -------------
      final authorization = await _authorize(
        purpose: purpose,
        fileName: fileName,
        mimeType: mimeType,
        sizeBytes: bytes,
        bookingId: bookingId,
        materialId: materialId,
        gigId: gigId,
        ticketId: ticketId,
        capturedAt: capturedAt,
      );

      _tasks[localId] = _PendingUpload(
        // The *original* file, not the compressed payload: a retry re-runs the
        // whole pipeline, and handing it an already-compressed file would
        // compress it a second time.
        file: file,
        mimeType: mimeType,
        mediaAssetId: authorization.mediaAssetId,
        uploadUrl: authorization.uploadUrl,
        task: task,
        target: target,
      );

      yield task = task.copyWith(
        state: UploadState.uploading,
        mediaAssetId: authorization.mediaAssetId,
      );

      // --- 4. Send the bytes ---------------------------------------------
      yield* _sendBytes(
        localId: localId,
        file: payload,
        mimeType: mimeType,
        uploadUrl: authorization.uploadUrl,
        task: task,
      );

      // --- 5. Confirm -----------------------------------------------------
      task = _tasks[localId]?.task ?? task;
      if (task.state != UploadState.uploading) return;

      yield task = task.copyWith(state: UploadState.confirming);
      await _confirm(authorization.mediaAssetId);

      _tasks.remove(localId);
      yield task = task.copyWith(
        state: UploadState.completed,
        bytesTransferred: bytes,
      );
    } catch (error, stack) {
      final failure = FailureMapper.from(error, stack);
      _log.error('Upload failed',
          error: error, stackTrace: stack, context: {'purpose': purpose.wire});

      final failed = task.copyWith(
        state: UploadState.failed,
        failure: failure.message,
      );
      _tasks[localId] = _tasks[localId]?.copyWith(task: failed) ??
          _PendingUpload(
            file: file,
            mimeType: mimeType,
            mediaAssetId: null,
            uploadUrl: null,
            task: failed,
            target: target,
          );
      yield failed;
    }
  }

  /// Streams progress from real bytes acknowledged by the server.
  ///
  /// Not a timer. A worker on a weak connection watching a fake bar reach 100%
  /// and then fail is worse than watching a real one stall.
  Stream<UploadTask> _sendBytes({
    required String localId,
    required File file,
    required String mimeType,
    required String uploadUrl,
    required UploadTask task,
  }) async* {
    final total = await file.length();
    var sent = 0;
    var current = task;

    final request = http.StreamedRequest('PUT', Uri.parse(uploadUrl))
      ..headers['content-type'] = mimeType
      ..contentLength = total;

    final controller = StreamController<UploadTask>();

    unawaited(() async {
      try {
        // send() must start before the body is written: the sink's close()
        // only completes once send() is consuming the stream, so awaiting it
        // first deadlocks and the bytes never leave the phone.
        final responseFuture = _http.send(request);

        await for (final chunk in file.openRead()) {
          if (_tasks[localId]?.isCancelled ?? false) {
            responseFuture.ignore();
            unawaited(request.sink.close());
            controller.add(current = current.copyWith(
              state: UploadState.cancelled,
            ));
            await controller.close();
            return;
          }
          request.sink.add(chunk);
          sent += chunk.length;
          controller.add(current = current.copyWith(bytesTransferred: sent));
        }
        unawaited(request.sink.close());

        final response = await responseFuture;
        if (response.statusCode >= 400) {
          final body = await response.stream.bytesToString();
          throw UploadFailure(
            message: 'The upload did not complete. Try again.',
            debugDetail: 'HTTP ${response.statusCode}: $body',
            isResumable: true,
          );
        }

        controller.add(current = current.copyWith(
          state: UploadState.uploading,
          bytesTransferred: total,
        ));
        await controller.close();
      } catch (error, stack) {
        controller.addError(FailureMapper.from(error, stack), stack);
        await controller.close();
      }
    }());

    await for (final update in controller.stream) {
      _tasks[localId] = _tasks[localId]!.copyWith(task: update);
      yield update;
    }
  }

  Future<_UploadAuthorization> _authorize({
    required MediaPurpose purpose,
    required String fileName,
    required String mimeType,
    required int sizeBytes,
    String? bookingId,
    String? materialId,
    String? gigId,
    String? ticketId,
    DateTime? capturedAt,
  }) async {
    final response = await _post('/worker/media/upload-url', {
      'purpose': purpose.wire,
      // The server uses this only for the stored display name. The storage
      // path is built server-side from the purpose rule and the owning
      // resource id; a name from here can never influence where the file lands.
      'fileName': fileName,
      'mimeType': mimeType,
      'sizeBytes': sizeBytes,
      if (bookingId != null) 'bookingId': bookingId,
      if (materialId != null) 'materialId': materialId,
      if (gigId != null) 'gigId': gigId,
      if (ticketId != null) 'ticketId': ticketId,
      if (capturedAt != null) 'capturedAt': capturedAt.toUtc().toIso8601String(),
    });

    final mediaAssetId = response['mediaAssetId'];
    final uploadUrl = response['uploadUrl'];

    if (mediaAssetId is! String || uploadUrl is! String) {
      throw const ServerFailure(
        debugDetail: 'upload-url response missing mediaAssetId or uploadUrl',
      );
    }

    return _UploadAuthorization(
      mediaAssetId: mediaAssetId,
      uploadUrl: uploadUrl,
    );
  }

  Future<void> _confirm(String mediaAssetId) async {
    // The server verifies the object exists in Storage and that its size
    // matches what was authorized before marking the row COMPLETED. Until then
    // the asset does not count as evidence anywhere.
    await _post('/worker/media/$mediaAssetId/complete', const {});
  }

  Future<Map<String, dynamic>> _post(String path, Map<String, Object?> body) async {
    final token = await _idToken();
    if (token == null || token.isEmpty) {
      throw const AuthFailure(
        message: 'Please sign in to continue.',
        requiresReauthentication: true,
      );
    }

    final response = await _http
        .post(
          Uri.parse('$_apiBaseUrl$path'),
          headers: {
            'authorization': 'Bearer $token',
            'content-type': 'application/json',
          },
          body: _encode(body),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode >= 400) {
      throw _failureForStatus(response.statusCode, response.body);
    }

    if (response.body.isEmpty) return const {};
    final decoded = _decode(response.body);
    // The web tier wraps successful payloads in { data: ... }.
    final data = decoded['data'];
    return data is Map<String, dynamic> ? data : decoded;
  }

  AppFailure _failureForStatus(int status, String body) {
    String? serverMessage;
    try {
      final decoded = _decode(body);
      final error = decoded['error'];
      if (error is Map && error['message'] is String) {
        serverMessage = error['message'] as String;
      } else if (decoded['message'] is String) {
        serverMessage = decoded['message'] as String;
      }
    } catch (_) {
      // A non-JSON error body tells the worker nothing useful anyway.
    }

    return switch (status) {
      401 || 403 => AuthFailure(
          message: serverMessage ?? 'Please sign in to continue.',
          requiresReauthentication: status == 401,
        ),
      404 => NotFoundFailure(message: serverMessage ?? 'That is no longer available.'),
      413 => const ValidationFailure(message: 'That file is too large.'),
      415 => const ValidationFailure(message: 'That file type is not accepted.'),
      422 => ValidationFailure(message: serverMessage ?? 'That file was refused.'),
      429 => const ValidationFailure(
          message: 'Too many uploads at once. Wait a moment and try again.'),
      _ => UploadFailure(
          message: serverMessage ?? 'The upload did not complete. Try again.',
          debugDetail: 'HTTP $status',
          isResumable: true,
        ),
    };
  }

  @override
  Future<Result<UploadTask>> retry(String localId) async {
    final pending = _tasks[localId];
    if (pending == null) {
      return const Err(NotFoundFailure(
        message: 'That upload is no longer available. Choose the file again.',
      ));
    }

    // Re-running the whole pipeline is deliberate: the previous signed URL may
    // have expired, and the server may have moved on. Resuming against a stale
    // authorization would fail in a way that is harder to explain.
    //
    // The whole target goes back with it. Only purpose and bookingId used to,
    // so retrying a material receipt, a gig photo or a ticket attachment asked
    // the server to authorize an asset with no owning resource — refused, or
    // filed against nothing. Retry has to ask for exactly what the first
    // attempt asked for.
    UploadTask? last;
    await for (final task in upload(
      file: pending.file,
      purpose: pending.task.purpose,
      bookingId: pending.target.bookingId,
      materialId: pending.target.materialId,
      gigId: pending.target.gigId,
      ticketId: pending.target.ticketId,
      capturedAt: pending.target.capturedAt,
    )) {
      last = task;
    }

    return last == null
        ? const Err(UploadFailure(message: 'The upload did not start.'))
        : Ok(last);
  }

  @override
  Future<Result<void>> cancel(String localId) async {
    final pending = _tasks[localId];
    if (pending == null) return const Ok(null);
    _tasks[localId] = pending.copyWith(isCancelled: true);
    return const Ok(null);
  }

  @override
  Future<Result<String>> signedUrl(String mediaId) async {
    try {
      // By id, never by path. The server reads the path from media_assets after
      // checking can_read_media(), so a caller cannot ask for an arbitrary
      // object, and the URL it returns expires in minutes.
      final response = await _post('/worker/media/$mediaId/url', const {});
      final url = response['url'];
      if (url is! String) {
        throw const ServerFailure(debugDetail: 'No url in response');
      }
      return Ok(url);
    } catch (error, stack) {
      return Err(FailureMapper.from(error, stack));
    }
  }

  @override
  Future<Result<List<MediaAsset>>> getAssets({
    String? bookingId,
    String? workerId,
    MediaPurpose? purpose,
  }) async {
    try {
      var query = _db.from('media_assets').select('''
            id, purpose, upload_status, mime_type, file_size_bytes,
            original_file_name, booking_id, worker_id, material_id,
            captured_at, created_at, width, height, duration_seconds
          ''').isFilter('deleted_at', null);

      if (bookingId != null) query = query.eq('booking_id', bookingId);
      if (workerId != null) query = query.eq('worker_id', workerId);
      if (purpose != null) query = query.eq('purpose', purpose.wire);

      final rows = await query.order('created_at', ascending: false);

      return Ok(rows
          .map((r) => MediaMapper.fromRow(Map<String, dynamic>.from(r)))
          .toList(growable: false));
    } catch (error, stack) {
      return Err(FailureMapper.from(error, stack));
    }
  }

  @override
  Future<Result<void>> delete(String mediaId) async {
    try {
      // A soft delete performed server-side. Evidence attached to a booking is
      // not the worker's to destroy once a job is complete, and the server
      // decides whether this particular asset may go.
      await _post('/worker/media/$mediaId/delete', const {});
      return const Ok(null);
    } catch (error, stack) {
      return Err(FailureMapper.from(error, stack));
    }
  }

  @override
  Future<Result<List<UploadTask>>> getPendingUploads() async {
    final pending = _tasks.values
        .map((t) => t.task)
        .where((t) => !t.isTerminal)
        .toList(growable: false);
    return Ok(pending);
  }

  /// Shrinks a photo to something sendable over a weak mobile connection.
  ///
  /// 1600px on the long edge at quality 82 keeps a switchboard or a damaged
  /// wall clearly legible for an assessor while cutting a typical phone photo
  /// from several megabytes to a few hundred kilobytes.
  Future<File?> _compressImage(File source) async {
    try {
      final target = p.join(
        source.parent.path,
        'compressed_${p.basenameWithoutExtension(source.path)}.jpg',
      );

      final result = await FlutterImageCompress.compressAndGetFile(
        source.absolute.path,
        target,
        quality: 82,
        minWidth: 1600,
        minHeight: 1600,
        keepExif: false, // Strips GPS and device identifiers.
      );

      if (result == null) return null;

      final compressed = File(result.path);
      // Only use it if it actually helped.
      return await compressed.length() < await source.length() ? compressed : null;
    } catch (error) {
      // Compression is an optimisation. If it fails, send the original rather
      // than failing the upload.
      _log.warning('Image compression skipped');
      return null;
    }
  }

  static String _mimeTypeFor(String fileName) {
    final extension = p.extension(fileName).toLowerCase();
    return switch (extension) {
      '.jpg' || '.jpeg' => 'image/jpeg',
      '.png' => 'image/png',
      '.webp' => 'image/webp',
      '.heic' || '.heif' => 'image/heic',
      '.mp4' => 'video/mp4',
      '.mov' => 'video/quicktime',
      '.pdf' => 'application/pdf',
      '.txt' => 'text/plain',
      _ => 'application/octet-stream',
    };
  }

  static String _encode(Map<String, Object?> body) =>
      const JsonCodecShim().encode(body);

  static Map<String, dynamic> _decode(String body) =>
      const JsonCodecShim().decode(body);
}

/// Thin wrapper so the JSON dependency is named in one place.
class JsonCodecShim {
  const JsonCodecShim();

  String encode(Object? value) => jsonEncode(value);

  Map<String, dynamic> decode(String source) {
    final decoded = jsonDecode(source);
    if (decoded is Map<String, dynamic>) return decoded;
    if (decoded is Map) return Map<String, dynamic>.from(decoded);
    throw const FormatException('Expected a JSON object');
  }
}

class _UploadAuthorization {
  const _UploadAuthorization({required this.mediaAssetId, required this.uploadUrl});
  final String mediaAssetId;
  final String uploadUrl;
}

/// What an upload is attached to.
///
/// The server builds the storage path from the purpose rule and the owning
/// resource id, so these are what decide where the asset lands — and therefore
/// what a retry has to be able to repeat.
class _UploadTarget {
  const _UploadTarget({
    this.bookingId,
    this.materialId,
    this.gigId,
    this.ticketId,
    this.capturedAt,
  });

  final String? bookingId;
  final String? materialId;
  final String? gigId;
  final String? ticketId;
  final DateTime? capturedAt;
}

class _PendingUpload {
  const _PendingUpload({
    required this.file,
    required this.mimeType,
    required this.mediaAssetId,
    required this.uploadUrl,
    required this.task,
    required this.target,
    this.isCancelled = false,
  });

  final File file;
  final String mimeType;
  final String? mediaAssetId;
  final String? uploadUrl;
  final UploadTask task;
  final _UploadTarget target;
  final bool isCancelled;

  _PendingUpload copyWith({UploadTask? task, bool? isCancelled}) => _PendingUpload(
        file: file,
        mimeType: mimeType,
        mediaAssetId: mediaAssetId,
        uploadUrl: uploadUrl,
        task: task ?? this.task,
        target: target,
        isCancelled: isCancelled ?? this.isCancelled,
      );
}
