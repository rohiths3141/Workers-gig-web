import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers/providers.dart';
import '../../app/providers/session_controller.dart';
import '../../app/theme/app_colors.dart';
import '../../core/errors/result.dart';
import '../../domain/entities/customer_address.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/service_category.dart';
import '../../shared/widgets/ask_assistant_button.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/service_icon.dart';
import '../../core/localization/l10n.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionState = ref.watch(sessionProvider).value;
    final customer = sessionState is SessionReady ? sessionState.customer : null;
    final categoriesAsync = ref.watch(serviceCategoriesProvider);
    final activeBookingsAsync = ref.watch(activeBookingsProvider);
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: AskAssistantButton(
        onTap: () => context.push('/assistant'),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                // Bottom inset clears the assistant's floating button, which
                // otherwise sits on top of the last request card.
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 88),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                customer != null
                                    ? l10n.homeGreetingNamed(customer.fullName)
                                    : l10n.homeGreeting,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.ink,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                l10n.homeWhatService,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.inkSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _NotificationButton(onTap: () => context.push('/notifications')),
                      ],
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: customer == null
                          ? null
                          : () => _changeSearchLocation(context, ref, customer.id),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.location_on, color: AppColors.primary, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            customer?.city ?? l10n.homeSetLocation,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.ink,
                            ),
                          ),
                          const Icon(Icons.keyboard_arrow_down, color: AppColors.inkSecondary, size: 18),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _SearchBar(onTap: () => context.push('/explore')),

                    activeBookingsAsync.when(
                      data: (bookings) {
                        if (bookings.isEmpty) return const SizedBox.shrink();
                        final booking = bookings.first;
                        // Live tracking only while someone is actually on the
                        // move. A job waiting on the customer opens the booking,
                        // where the approve button is.
                        const trackable = {
                          BookingStatus.traveling,
                          BookingStatus.arrived,
                          BookingStatus.inProgress,
                        };
                        final isAwaitingApproval =
                            booking.status == BookingStatus.awaitingApproval;
                        return Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: _ActiveBookingBanner(
                            code: booking.bookingCode,
                            status: isAwaitingApproval
                                ? l10n.homeWorkFinishedApprove
                                : booking.status.displayName,
                            onTap: () => context.push(
                              trackable.contains(booking.status)
                                  ? '/bookings/${booking.id}/active'
                                  : '/bookings/${booking.id}',
                            ),
                          ),
                        );
                      },
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),

                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.homeCategories,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.go('/explore'),
                          child: Text(l10n.commonSeeAll),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    categoriesAsync.when(
                      data: (categories) => _buildCategoryGrid(context, categories),
                      loading: () => const Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      error: (err, _) => Text(l10n.homeCategoriesLoadFailed('$err')),
                    ),

                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: _ActionCard(
                            icon: Icons.search_rounded,
                            title: l10n.homeFindWorker,
                            subtitle: l10n.homeFindWorkerSubtitle,
                            onTap: () => context.go('/explore'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ActionCard(
                            icon: Icons.post_add_rounded,
                            title: l10n.homePostRequest,
                            subtitle: l10n.homePostRequestSubtitle,
                            onTap: () => context.push('/post-request'),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    _ServiceRequestsSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryGrid(BuildContext context, List<ServiceCategory> categories) {
    final l10n = context.l10n;
    if (categories.isEmpty) {
      return EmptyState(
        icon: Icons.category_outlined,
        title: l10n.homeNoServices,
        message: l10n.commonCheckBackLater,
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
        // Room for a two-line label: "Other Home Services" and "Appliance
        // Repair" were being cut to "Other Hom…" and "Appliance R…".
        childAspectRatio: 0.66,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        final color = serviceAccentAt(index);
        return GestureDetector(
          onTap: () {
            context.push(
              '/services/${cat.id}?name=${Uri.encodeComponent(cat.name)}',
            );
          },
          child: Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(serviceIconFor(cat.slug), color: color, size: 24),
              ),
              const SizedBox(height: 6),
              Text(
                localizedServiceName(l10n, cat.name, slug: cat.slug),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  height: 1.25,
                  fontWeight: FontWeight.w500,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}

/// Changes where the customer is searching from — not their permanent Home
/// address. Picking a saved address here only borrows its coordinates for
/// this session; it never touches that address's own default flag.
Future<void> _changeSearchLocation(
  BuildContext context,
  WidgetRef ref,
  String customerId,
) async {
  final addressesResult = await ref.read(addressRepositoryProvider).getAddresses();
  final addresses = addressesResult.fold((a) => a, (_) => <CustomerAddress>[]);
  if (!context.mounted) return;

  final l10n = context.l10n;
  final choice = await showModalBottomSheet<String>(
    context: context,
    builder: (sheetContext) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(l10n.homeSearchNear, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          ListTile(
            leading: const Icon(Icons.my_location_rounded, color: AppColors.primary),
            title: Text(l10n.commonUseCurrentLocation),
            onTap: () => Navigator.of(sheetContext).pop('__current__'),
          ),
          for (final addr in addresses)
            ListTile(
              leading: Icon(
                addr.label == 'Home'
                    ? Icons.home_outlined
                    : addr.label == 'Work'
                        ? Icons.work_outline_rounded
                        : Icons.place_outlined,
              ),
              title: Text(localizedAddressLabel(l10n, addr.label)),
              subtitle: Text(addr.addressLine, maxLines: 1, overflow: TextOverflow.ellipsis),
              onTap: addr.hasCoords ? () => Navigator.of(sheetContext).pop(addr.id) : null,
            ),
          ListTile(
            leading: const Icon(Icons.map_outlined),
            title: Text(l10n.commonChooseOnMap),
            onTap: () => Navigator.of(sheetContext).pop('__map__'),
          ),
        ],
      ),
    ),
  );

  if (choice == null || !context.mounted) return;

  if (choice == '__current__') {
    await _useCurrentLocation(context, ref);
  } else if (choice == '__map__') {
    final picked = await context.push<Map<String, dynamic>>('/location-picker');
    if (picked == null || !context.mounted) return;
    await ref.read(customerRepositoryProvider).updateLocation(
          latitude: (picked['latitude'] as num).toDouble(),
          longitude: (picked['longitude'] as num).toDouble(),
          city: picked['city'] as String?,
          state: picked['state'] as String?,
          pincode: picked['pincode'] as String?,
        );
    ref.invalidate(sessionProvider);
  } else {
    final addr = addresses.firstWhere((a) => a.id == choice);
    await ref.read(customerRepositoryProvider).updateLocation(
          latitude: addr.latitude!,
          longitude: addr.longitude!,
          city: addr.city,
          state: addr.state,
          pincode: addr.pincode,
        );
    ref.invalidate(sessionProvider);
  }
}

Future<void> _useCurrentLocation(BuildContext context, WidgetRef ref) async {
  if (!await Geolocator.isLocationServiceEnabled()) return;
  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }
  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    return;
  }

  final position = await Geolocator.getCurrentPosition();
  await ref.read(customerRepositoryProvider).updateLocation(
        latitude: position.latitude,
        longitude: position.longitude,
      );
  ref.invalidate(sessionProvider);
}

class _NotificationButton extends StatelessWidget {
  const _NotificationButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.surfaceMuted,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.notifications_none_rounded, color: AppColors.ink, size: 20),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: AppColors.inkTertiary, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    context.l10n.homeSearchHint,
                    style: const TextStyle(color: AppColors.inkTertiary, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.tune_rounded, color: AppColors.ink, size: 20),
          ),
        ],
      ),
    );
  }
}

class _ActiveBookingBanner extends StatelessWidget {
  const _ActiveBookingBanner({
    required this.code,
    required this.status,
    required this.onTap,
  });

  final String code;
  final String status;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(Icons.delivery_dining, color: Colors.white, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.homeActiveBooking(code),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    status,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14),
          ],
        ),
      ),
    );
  }
}

/// Action card for the dual-CTA row on the home screen.
class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.primary, size: 24),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.ink,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(color: AppColors.inkSecondary, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shows the customer's active service requests on the home screen.
class _ServiceRequestsSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(myServiceRequestsStreamProvider);
    final l10n = context.l10n;

    return requestsAsync.when(
      data: (requests) {
        final active = requests
            .where((r) => r.status.isActive)
            .take(3)
            .toList();

        if (active.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.homeActiveRequests,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                TextButton(
                  onPressed: () => context.push('/my-requests'),
                  child: Text(l10n.commonViewAll),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...active.map((r) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GestureDetector(
                    onTap: () => context.push('/my-requests/${r.id}'),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.primarySurface,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                '${r.offerCount}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  r.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.ink,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '${r.status.customerLabel} · ${r.offerCountLabel}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.inkSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: AppColors.inkSecondary),
                        ],
                      ),
                    ),
                  ),
                )),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
