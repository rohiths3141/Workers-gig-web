/// A real, server-queued notification row (public.notifications).
class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.templateKey,
    required this.payload,
    required this.queuedAt,
    this.readAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) => AppNotification(
        id: json['id'] as String,
        title: json['title'] as String,
        body: json['body'] as String,
        templateKey: json['template_key'] as String? ?? '',
        payload: (json['payload'] as Map?)?.cast<String, dynamic>() ?? const {},
        queuedAt: DateTime.parse(json['queued_at'] as String),
        readAt: json['read_at'] != null ? DateTime.parse(json['read_at'] as String) : null,
      );

  final String id;
  final String title;
  final String body;
  final String templateKey;
  final Map<String, dynamic> payload;
  final DateTime queuedAt;
  final DateTime? readAt;

  bool get isUnread => readAt == null;
}
