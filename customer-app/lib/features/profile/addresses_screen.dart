import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers/providers.dart';
import '../../app/providers/session_controller.dart';
import '../../app/theme/app_colors.dart';
import '../../domain/entities/customer_address.dart';
import '../../domain/repositories/repositories.dart';
import '../../shared/widgets/empty_state.dart';

const _labelOptions = ['Home', 'Work', 'Other'];

class AddressesScreen extends ConsumerWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionState = ref.watch(sessionProvider).value;
    if (sessionState is! SessionReady) {
      return const Scaffold(
        appBar: null,
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final customerId = sessionState.customer.id;

    final addressesAsync = ref.watch(customerAddressesProvider(customerId));
    final addressRepo = ref.watch(addressRepositoryProvider);

    Future<void> refresh() async =>
        ref.invalidate(customerAddressesProvider(customerId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Service Addresses'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addOrEdit(
          context,
          addressRepo,
          isFirstAddress: (addressesAsync.valueOrNull ?? const []).isEmpty,
          onSaved: refresh,
        ),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_location_alt_outlined, color: Colors.white),
        label: const Text('Add New Address', style: TextStyle(color: Colors.white)),
      ),
      body: SafeArea(
        child: addressesAsync.when(
          data: (addresses) {
            if (addresses.isEmpty) {
              return const EmptyState(
                icon: Icons.location_off_outlined,
                title: 'You haven\'t saved any addresses yet',
                message: 'Add a service address to book faster next time.',
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                final addr = addresses[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: addr.isDefault
                          ? AppColors.primary
                          : AppColors.border,
                      width: addr.isDefault ? 1.5 : 1.0,
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(_iconFor(addr.label), color: AppColors.primary),
                    ),
                    title: Row(
                      children: [
                        Text(
                          addr.label,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        if (addr.isDefault) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'DEFAULT',
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          addr.addressLine,
                          style: const TextStyle(fontSize: 13, color: AppColors.ink),
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (action) async {
                        switch (action) {
                          case 'edit':
                            await _addOrEdit(context, addressRepo,
                                existing: addr, onSaved: refresh);
                          case 'default':
                            await addressRepo.upsertAddress(
                              addressId: addr.id,
                              label: addr.label,
                              addressLine: addr.addressLine,
                              city: addr.city,
                              state: addr.state,
                              pincode: addr.pincode,
                              latitude: addr.latitude,
                              longitude: addr.longitude,
                              isDefault: true,
                            );
                            await refresh();
                          case 'delete':
                            await addressRepo.deleteAddress(addr.id);
                            await refresh();
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'edit', child: Text('Edit')),
                        if (!addr.isDefault)
                          const PopupMenuItem(
                              value: 'default', child: Text('Set as default')),
                        const PopupMenuItem(value: 'delete', child: Text('Delete')),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => ErrorState(
            message: 'Could not load addresses.',
            onRetry: () => ref.invalidate(customerAddressesProvider(customerId)),
          ),
        ),
      ),
    );
  }

  static IconData _iconFor(String label) => switch (label) {
        'Home' => Icons.home_outlined,
        'Work' => Icons.work_outline_rounded,
        _ => Icons.place_outlined,
      };

  Future<void> _addOrEdit(
    BuildContext context,
    AddressRepository addressRepo, {
    CustomerAddress? existing,
    bool isFirstAddress = false,
    required Future<void> Function() onSaved,
  }) async {
    var label = existing?.label ?? 'Home';
    if (!_labelOptions.contains(label)) label = 'Other';

    final selectedLabel = await showModalBottomSheet<String>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Label this address', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            for (final option in _labelOptions)
              ListTile(
                leading: Icon(_iconFor(option)),
                title: Text(option),
                onTap: () => Navigator.of(sheetContext).pop(option),
              ),
          ],
        ),
      ),
    );

    if (selectedLabel == null || !context.mounted) return;

    final pickerResult = await context.push<Map<String, dynamic>>(
      '/location-picker',
      extra: existing == null
          ? null
          : {
              'latitude': existing.latitude,
              'longitude': existing.longitude,
              'addressLine': existing.addressLine,
              'city': existing.city,
              'state': existing.state,
              'pincode': existing.pincode,
            },
    );

    if (pickerResult == null || !context.mounted) return;

    await addressRepo.upsertAddress(
      addressId: existing?.id,
      label: selectedLabel,
      addressLine: pickerResult['addressLine'] as String,
      city: pickerResult['city'] as String?,
      state: pickerResult['state'] as String?,
      pincode: pickerResult['pincode'] as String?,
      latitude: (pickerResult['latitude'] as num?)?.toDouble(),
      longitude: (pickerResult['longitude'] as num?)?.toDouble(),
      isDefault: existing?.isDefault ?? isFirstAddress,
    );

    await onSaved();
  }
}
