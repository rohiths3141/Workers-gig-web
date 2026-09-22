import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers/providers.dart';
import '../../app/theme/app_colors.dart';
import '../../domain/entities/enums.dart';

class MaterialsScreen extends ConsumerWidget {
  final String bookingId;

  const MaterialsScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final materialsAsync = ref.watch(bookingMaterialsProvider(bookingId));
    final materialRepo = ref.watch(materialRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Material / Parts Requests'),
      ),
      body: SafeArea(
        child: materialsAsync.when(
          data: (materials) {
            if (materials.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.build_circle_outlined, size: 48, color: AppColors.inkSecondary),
                    SizedBox(height: 12),
                    Text(
                      'No material requests submitted for this booking',
                      style: TextStyle(color: AppColors.inkSecondary),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: materials.length,
              itemBuilder: (context, index) {
                final mat = materials[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              mat.name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              mat.costLabel,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        if (mat.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(mat.description, style: const TextStyle(fontSize: 13, color: AppColors.inkSecondary)),
                        ],
                        const SizedBox(height: 8),
                        Text(
                          '${mat.quantityLabel}'
                          '${mat.isEstimate ? ' · estimated' : ' · actual'}',
                          style: const TextStyle(fontSize: 12, color: AppColors.ink),
                        ),
                        const Divider(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getStatusColor(mat.status).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                mat.status.name.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: _getStatusColor(mat.status),
                                ),
                              ),
                            ),
                            if (mat.status == MaterialStatus.requested)
                              Row(
                                children: [
                                  OutlinedButton(
                                    onPressed: () async {
                                      await materialRepo.rejectMaterial(mat.id);
                                      ref.invalidate(bookingMaterialsProvider(bookingId));
                                    },
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppColors.statusError,
                                      // Themed buttons ask for infinite
                                      // minimum width, which a Row cannot
                                      // give.
                                      minimumSize: const Size(0, 44),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                    ),
                                    child: const Text('Reject'),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: () async {
                                      await materialRepo.approveMaterial(mat.id);
                                      ref.invalidate(bookingMaterialsProvider(bookingId));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.statusSuccess,
                                      foregroundColor: Colors.white,
                                      minimumSize: const Size(0, 44),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                    ),
                                    child: const Text('Approve'),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }

  Color _getStatusColor(MaterialStatus status) {
    switch (status) {
      case MaterialStatus.requested:
      case MaterialStatus.customerReview:
        return AppColors.statusPending;
      case MaterialStatus.approved:
      case MaterialStatus.purchased:
      case MaterialStatus.costRecorded:
      case MaterialStatus.billed:
        return AppColors.statusSuccess;
      case MaterialStatus.rejected:
      case MaterialStatus.cancelled:
        return AppColors.statusError;
    }
  }
}
