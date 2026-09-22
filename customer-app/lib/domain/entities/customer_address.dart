/// A saved address belonging to the customer.
class CustomerAddress {
  const CustomerAddress({
    required this.id,
    required this.customerId,
    required this.label,
    required this.addressLine,
    required this.isDefault,
    required this.createdAt,
    this.city,
    this.state,
    this.pincode,
    this.latitude,
    this.longitude,
  });

  factory CustomerAddress.fromJson(Map<String, dynamic> json) =>
      CustomerAddress(
        id: json['id'] as String,
        customerId: json['customer_id'] as String,
        label: json['label'] as String? ?? 'Home',
        addressLine: json['address_line'] as String,
        city: json['city'] as String?,
        state: json['state'] as String?,
        pincode: json['pincode'] as String?,
        latitude: (json['latitude'] as num?)?.toDouble(),
        longitude: (json['longitude'] as num?)?.toDouble(),
        isDefault: json['is_default'] as bool? ?? false,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  final String id;
  final String customerId;
  final String label;
  final String addressLine;
  final String? city;
  final String? state;
  final String? pincode;
  final double? latitude;
  final double? longitude;
  final bool isDefault;
  final DateTime createdAt;

  bool get hasCoords => latitude != null && longitude != null;

  String get fullAddress => [addressLine, city, state, pincode]
      .where((s) => s != null && s.isNotEmpty)
      .join(', ');
}
