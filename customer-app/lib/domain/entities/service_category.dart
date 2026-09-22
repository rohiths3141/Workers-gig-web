/// A service category from the public.services table.
class ServiceCategory {
  const ServiceCategory({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.iconUrl,
    this.sortOrder = 0,
  });

  factory ServiceCategory.fromJson(Map<String, dynamic> json) =>
      ServiceCategory(
        id: json['id'] as String,
        name: json['name'] as String,
        slug: json['slug'] as String? ?? '',
        description: (json['short_description'] ?? json['description']) as String? ?? '',
        iconUrl: json['icon_key'] as String? ?? '',
        sortOrder: json['display_order'] as int? ?? 0,
      );

  final String id;
  final String name;
  final String slug;
  final String description;
  final String iconUrl;
  final int sortOrder;
}
