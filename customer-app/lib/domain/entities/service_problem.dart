/// A common problem/task for a service category (public.service_problems),
/// shown to the customer as a quick-pick when describing what they need.
/// No price lives here — price is per-gig, set by each worker.
class ServiceProblem {
  const ServiceProblem({
    required this.id,
    required this.serviceId,
    required this.title,
    this.description,
  });

  factory ServiceProblem.fromJson(Map<String, dynamic> json) => ServiceProblem(
        id: json['id'] as String,
        serviceId: json['service_id'] as String,
        title: json['title'] as String,
        description: json['description'] as String?,
      );

  final String id;
  final String serviceId;
  final String title;
  final String? description;
}
