import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show SupabaseClient;
import 'package:wervexa_worker/domain/entities/enums.dart';
import 'package:wervexa_worker/domain/entities/media.dart';
import 'package:wervexa_worker/data/repositories/supabase_media_repository.dart';

/// Retrying an upload has to ask for the same thing the first attempt did.
///
/// The server builds the storage path itself, from the purpose rule and the id
/// of the resource the asset belongs to — a booking, a material, a gig, a
/// support ticket. That is what makes it impossible to file a photo against
/// somebody else's KYC folder, and it means the owning id is not decoration:
/// it is most of the request.
///
/// `retry()` used to re-run the pipeline with only `purpose` and `bookingId`.
/// A material receipt, a gig photo or a ticket attachment therefore came back
/// with no owning resource at all — refused by the server, or filed against
/// nothing — and the worker saw a retry that failed for a reason they could do
/// nothing about.
void main() {
  late Directory temp;
  late File photo;

  /// Every body posted to /worker/media/upload-url, in order.
  late List<Map<String, dynamic>> authorizations;
  late int uploadUrlFailuresRemaining;

  setUp(() async {
    temp = await Directory.systemTemp.createTemp('wervexa_media_test');
    photo = File('${temp.path}/receipt.jpg')
      // Small, and not a real JPEG: compression is skipped for anything it
      // cannot decode, which keeps this test off the platform channel.
      ..writeAsBytesSync(List<int>.filled(2048, 7));
    authorizations = [];
    uploadUrlFailuresRemaining = 0;
  });

  tearDown(() => temp.deleteSync(recursive: true));

  SupabaseMediaRepository repository() {
    final client = MockClient((request) async {
      final url = request.url.toString();

      if (url.endsWith('/worker/media/upload-url')) {
        authorizations
            .add(jsonDecode(request.body) as Map<String, dynamic>);

        if (uploadUrlFailuresRemaining > 0) {
          uploadUrlFailuresRemaining--;
          return http.Response(
            jsonEncode({'error': {'message': 'Storage is unavailable.'}}),
            503,
            request: request,
            headers: const {'content-type': 'application/json'},
          );
        }

        return http.Response(
          jsonEncode({
            'data': {
              'mediaAssetId': 'media-asset-1',
              'uploadUrl': 'https://storage.example.test/signed/media-asset-1',
            }
          }),
          200,
          request: request,
          headers: const {'content-type': 'application/json'},
        );
      }

      // The signed-URL PUT, then the confirm.
      return http.Response('{"data":{}}', 200,
          request: request,
          headers: const {'content-type': 'application/json'});
    });

    return SupabaseMediaRepository(
      db: SupabaseClient(
        'https://example.supabase.co',
        'publishable-key',
        httpClient: client,
        accessToken: () async => 'an-id-token',
      ),
      apiBaseUrl: 'https://example.test/api',
      idTokenProvider: () async => 'an-id-token',
      httpClient: client,
    );
  }

  Future<UploadTask> drain(Stream<UploadTask> tasks) async {
    UploadTask? last;
    await for (final task in tasks) {
      last = task;
    }
    return last!;
  }

  group('Retrying an upload', () {
    test('re-sends every id the first attempt carried', () async {
      final media = repository();
      // The first authorization fails, so there is something to retry.
      uploadUrlFailuresRemaining = 1;

      final captured = DateTime.utc(2026, 9, 20, 11, 30);
      final failed = await drain(media.upload(
        file: photo,
        purpose: MediaPurpose.bookingMaterialPhoto,
        bookingId: 'booking-1',
        materialId: 'material-1',
        capturedAt: captured,
      ));
      expect(failed.state, UploadState.failed);
      expect(authorizations, hasLength(1));

      await media.retry(failed.localId);

      expect(authorizations, hasLength(2));
      final retryBody = authorizations.last;
      expect(retryBody['purpose'], MediaPurpose.bookingMaterialPhoto.wire);
      expect(retryBody['bookingId'], 'booking-1');
      expect(retryBody['materialId'], 'material-1',
          reason: 'Without the material id the server has nothing to file '
              'the photo against');
      expect(retryBody['capturedAt'], captured.toIso8601String());
    });

    test('re-sends a gig id', () async {
      final media = repository();
      uploadUrlFailuresRemaining = 1;

      // What GigRepository.addPhoto() sends.
      final failed = await drain(media.upload(
        file: photo,
        purpose: MediaPurpose.workerProfilePhoto,
        gigId: 'gig-1',
      ));

      await media.retry(failed.localId);

      expect(authorizations.last['gigId'], 'gig-1');
    });

    test('re-sends a support ticket id', () async {
      final media = repository();
      uploadUrlFailuresRemaining = 1;

      final failed = await drain(media.upload(
        file: photo,
        purpose: MediaPurpose.supportAttachment,
        ticketId: 'ticket-1',
      ));

      await media.retry(failed.localId);

      expect(authorizations.last['ticketId'], 'ticket-1');
    });

    test('asks for exactly what the first attempt asked for', () async {
      final media = repository();
      uploadUrlFailuresRemaining = 1;

      final failed = await drain(media.upload(
        file: photo,
        purpose: MediaPurpose.bookingMaterialPhoto,
        bookingId: 'booking-1',
        materialId: 'material-1',
      ));

      await media.retry(failed.localId);

      expect(authorizations.last, equals(authorizations.first),
          reason: 'A retry is the same request, not a narrower one');
    });

    test('refuses a localId it never saw', () async {
      final result = await repository().retry('not-a-real-upload');
      expect(result.isErr, isTrue);
    });
  });
}
