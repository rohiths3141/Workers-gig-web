import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers/providers.dart';
import '../../app/theme/app_colors.dart';
import '../../shared/widgets/empty_state.dart';

/// Shows common problems for a service category as a quick-pick starting
/// point for the service request form. No pricing is shown here — price is
/// set per gig by each worker and only known once discovery returns results.
class ServiceCategoryScreen extends ConsumerWidget {
  final String serviceId;
  final String serviceName;

  const ServiceCategoryScreen({
    super.key,
    required this.serviceId,
    required this.serviceName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = serviceName.isEmpty ? 'Service Details' : serviceName;
    final problemsAsync = ref.watch(serviceProblemsProvider(serviceId));

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.ink),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Book verified, background-checked local experts with upfront pricing & service guarantee.',
                      style: TextStyle(color: AppColors.inkSecondary, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'What do you need help with?',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.ink,
                    ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: problemsAsync.when(
                  data: (problems) {
                    return ListView(
                      children: [
                        ...problems.map((problem) => Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(color: AppColors.border),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(12),
                                title: Text(problem.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                subtitle: problem.description != null
                                    ? Text(problem.description!, style: const TextStyle(fontSize: 12, color: AppColors.inkSecondary))
                                    : null,
                                trailing: const Icon(Icons.chevron_right, color: AppColors.primary),
                                onTap: () => context.push(
                                  '/service-request/$serviceId?name=${Uri.encodeComponent(title)}',
                                  extra: {'presetDescription': problem.title},
                                ),
                              ),
                            )),
                        Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: AppColors.primary),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            leading: const Icon(Icons.edit_note, color: AppColors.primary),
                            title: const Text('Describe something else', style: TextStyle(fontWeight: FontWeight.bold)),
                            trailing: const Icon(Icons.chevron_right, color: AppColors.primary),
                            onTap: () => context.push('/service-request/$serviceId?name=${Uri.encodeComponent(title)}'),
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, _) => ErrorState(
                    message: 'Could not load this service.',
                    onRetry: () => ref.invalidate(serviceProblemsProvider(serviceId)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
