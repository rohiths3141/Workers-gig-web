import 'enums.dart';

/// Mirrors public.customers — only customer-side fields.
class Customer {
  const Customer({
    required this.id,
    required this.firebaseUid,
    required this.fullName,
    required this.phone,
    required this.status,
    this.email,
    this.profilePhotoUrl,
    this.city,
    this.createdAt,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json['id'] as String,
        firebaseUid: json['firebase_uid'] as String,
        fullName: json['full_name'] as String,
        phone: json['phone'] as String,
        email: json['email'] as String?,
        status: CustomerStatus.parse(json['status'] as String?),
        profilePhotoUrl: json['profile_photo_url'] as String?,
        city: json['city'] as String?,
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'] as String)
            : null,
      );

  final String id;
  final String firebaseUid;
  final String fullName;
  final String phone;
  final String? email;
  final CustomerStatus status;
  final String? profilePhotoUrl;
  final String? city;
  final DateTime? createdAt;

  String get initials {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
  }

  Customer copyWith({
    String? fullName,
    String? email,
    String? profilePhotoUrl,
    String? city,
  }) =>
      Customer(
        id: id,
        firebaseUid: firebaseUid,
        fullName: fullName ?? this.fullName,
        phone: phone,
        email: email ?? this.email,
        status: status,
        profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
        city: city ?? this.city,
        createdAt: createdAt,
      );
}
