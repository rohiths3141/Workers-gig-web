@TestOn('vm')
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// What an RPC sends against what the app reads.
///
/// Several functions answer with `jsonb_build_object(...)` rather than a table,
/// so the payload is a hand-written key list in SQL and another hand-written
/// key list in Dart. Nothing makes them agree. A key the mapper reads and the
/// function never sends is not a crash — the mapper reads it as nullable and
/// carries on — it is a field that is quietly always null, on a screen where
/// somebody expected content.
///
/// The SQL side is extracted from the migrations by
/// `web/supabase/scripts/generate-db-contract.mjs`; the Dart side is read out
/// of the mapper itself, so neither can drift without this noticing.
void main() {
  final fixture = jsonDecode(
    File('test/fixtures/db_enums.json').readAsStringSync(),
  ) as Map<String, dynamic>;

  final rpcKeys = (fixture['rpcPayloadKeys'] as Map).cast<String, dynamic>();

  List<String> keysSentBy(String rpc) {
    final keys = rpcKeys[rpc];
    if (keys == null) {
      throw StateError(
        'No payload recorded for public.$rpc. Regenerate the fixture with '
        '`node web/supabase/scripts/generate-db-contract.mjs`.',
      );
    }
    return (keys as List).cast<String>();
  }

  /// Every `json['some_key']` a mapper reads.
  ///
  /// Throws rather than `expect`s: this runs while the groups are being
  /// declared, where there is no test for a failure to belong to.
  List<String> keysReadBy(String dartFile) {
    final source = File(dartFile).readAsStringSync();
    final matches = RegExp(r"""json\['([a-z0-9_]+)'\]""").allMatches(source);
    final keys = matches.map((m) => m.group(1)!).toSet().toList()..sort();
    if (keys.isEmpty) {
      throw StateError('No json[...] reads found in $dartFile — has the mapper '
          'been rewritten?');
    }
    return keys;
  }

  /// Keys the app reads that the function does not send, with the reason each
  /// is tolerated. An entry here is a known gap, not an excuse: when the
  /// function starts sending one, the test fails so the entry gets deleted.
  const knownGaps = <String, Map<String, String>>{
    'customer_find_gigs': {
      'worker_photo_url':
          'The photo lives in Firebase Storage and needs a signed URL from the '
              'web tier, which a Postgres function cannot mint. Every gig card '
              'therefore falls back to initials. Wiring this up needs the '
              'customer app to gain the media pipeline the worker app has.',
    },
  };

  void contractHolds(String rpc, String dartFile) {
    group('$rpc -> $dartFile', () {
      final sent = keysSentBy(rpc);
      final read = keysReadBy(dartFile);
      final gaps = knownGaps[rpc] ?? const {};

      test('the mapper reads nothing the function does not send', () {
        final unexpected =
            read.where((k) => !sent.contains(k) && !gaps.containsKey(k)).toList();

        expect(
          unexpected,
          isEmpty,
          reason: 'public.$rpc never sends $unexpected, so these are always '
              'null in the app. Either add them to the function or stop '
              'reading them.',
        );
      });

      test('every known gap is still a gap', () {
        // When the function starts sending one of these, the exception above
        // is stale and should be removed rather than left to rot.
        final closed = gaps.keys.where(sent.contains).toList();
        expect(
          closed,
          isEmpty,
          reason: 'public.$rpc now sends $closed. Delete those entries from '
              'knownGaps.',
        );
      });

      test('the gap list does not cover keys the mapper stopped reading', () {
        final unused = gaps.keys.where((k) => !read.contains(k)).toList();
        expect(unused, isEmpty,
            reason: '$dartFile no longer reads $unused — remove them from '
                'knownGaps.');
      });
    });
  }

  contractHolds('customer_find_gigs', 'lib/domain/entities/gig_card.dart');
}
