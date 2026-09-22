import 'enums.dart';

/// A support request raised by the worker.
class SupportTicket {
  const SupportTicket({
    required this.id,
    required this.ticketCode,
    required this.subject,
    required this.category,
    required this.status,
    required this.createdAt,
    required this.lastMessageAt,
    this.bookingCode,
    this.resolutionNote,
    this.unreadCount = 0,
  });

  final String id;
  final String ticketCode;
  final String subject;
  final SupportCategory category;
  final SupportStatus status;
  final String? bookingCode;
  final String? resolutionNote;
  final DateTime createdAt;
  final DateTime lastMessageAt;
  final int unreadCount;

  bool get needsReply => status.needsWorkerReply;
}

/// One message in a ticket thread.
///
/// Internal staff notes never reach here: the RLS policy filters them out
/// server-side rather than relying on the client to hide them.
class SupportMessage {
  const SupportMessage({
    required this.id,
    required this.ticketId,
    required this.body,
    required this.isFromWorker,
    required this.createdAt,
    this.attachmentMediaIds = const [],
  });

  final String id;
  final String ticketId;
  final String body;
  final bool isFromWorker;
  final DateTime createdAt;
  final List<String> attachmentMediaIds;
}

/// A notification, from `public.notifications`.
///
/// Only rows that actually exist are shown. The previous application rendered
/// four hardcoded entries; there is no equivalent here and no seed data.
class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.templateKey,
    required this.createdAt,
    this.payload = const {},
    this.readAt,
  });

  final String id;
  final String title;
  final String body;

  /// Drives the icon and the deep link, e.g. `job.offered`.
  final String templateKey;

  final Map<String, dynamic> payload;
  final DateTime createdAt;
  final DateTime? readAt;

  bool get isRead => readAt != null;

  /// Which part of the app this notification is about. Derived from the
  /// template key rather than parsed out of the body text.
  NotificationCategory get category {
    final key = templateKey.toLowerCase();
    if (key.startsWith('job') || key.startsWith('booking')) {
      return NotificationCategory.job;
    }
    if (key.startsWith('material')) return NotificationCategory.material;
    if (key.startsWith('payment') || key.startsWith('wallet')) {
      return NotificationCategory.payment;
    }
    if (key.startsWith('payout')) return NotificationCategory.payout;
    if (key.startsWith('verification') || key.startsWith('gig')) {
      return NotificationCategory.verification;
    }
    if (key.startsWith('support')) return NotificationCategory.support;
    return NotificationCategory.system;
  }

  /// Where tapping should go, when the payload names a target.
  String? get deepLinkTarget {
    final bookingId = payload['booking_id'];
    if (bookingId is String) return '/jobs/$bookingId';
    final ticketId = payload['ticket_id'];
    if (ticketId is String) return '/support/$ticketId';
    return switch (category) {
      NotificationCategory.payment ||
      NotificationCategory.payout =>
        '/wallet',
      NotificationCategory.verification => '/verification',
      _ => null,
    };
  }
}

enum NotificationCategory {
  job,
  material,
  payment,
  payout,
  verification,
  support,
  system,
}

/// A rating the worker received, or one they gave.
class Rating {
  const Rating({
    required this.id,
    required this.bookingId,
    required this.rating,
    required this.isFromCustomer,
    required this.createdAt,
    this.comment,
    this.serviceName,
  });

  final String id;
  final String bookingId;
  final int rating;
  final String? comment;
  final bool isFromCustomer;
  final String? serviceName;
  final DateTime createdAt;
}

/// The worker's reputation, as the server computes it.
class RatingSummary {
  const RatingSummary({
    required this.average,
    required this.count,
    required this.distribution,
  });

  /// Null when the worker has not been rated yet. Shown as "Not rated yet",
  /// never as 0.0 — which would read as terrible rather than absent.
  final double? average;

  final int count;

  /// Star value (1..5) to how many ratings.
  final Map<int, int> distribution;

  bool get hasRatings => count > 0 && average != null;
}
