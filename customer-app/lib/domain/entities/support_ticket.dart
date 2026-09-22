import 'enums.dart';

class SupportTicket {
  const SupportTicket({
    required this.id,
    required this.ticketCode,
    required this.subject,
    required this.category,
    required this.status,
    required this.createdAt,
    this.bookingId,
  });

  factory SupportTicket.fromJson(Map<String, dynamic> json) => SupportTicket(
        id: json['id'] as String,
        ticketCode: json['ticket_code'] as String,
        subject: json['subject'] as String,
        category: SupportCategory.parse(json['category'] as String?),
        status: SupportStatus.parse(json['status'] as String?),
        createdAt: DateTime.parse(json['created_at'] as String),
        bookingId: json['booking_id'] as String?,
      );

  final String id;
  final String ticketCode;
  final String subject;
  final SupportCategory category;
  final SupportStatus status;
  final DateTime createdAt;
  final String? bookingId;
}

class SupportMessage {
  const SupportMessage({
    required this.id,
    required this.ticketId,
    required this.authorType,
    required this.body,
    required this.createdAt,
  });

  factory SupportMessage.fromJson(Map<String, dynamic> json) => SupportMessage(
        id: json['id'] as String,
        ticketId: json['ticket_id'] as String,
        authorType: json['author_type'] as String,
        body: json['body'] as String,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  final String id;
  final String ticketId;
  final String authorType;
  final String body;
  final DateTime createdAt;

  bool get isFromCustomer => authorType == 'CUSTOMER';
}
