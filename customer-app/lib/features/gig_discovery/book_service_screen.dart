import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/providers/providers.dart';
import '../../app/theme/app_colors.dart';
import '../../core/errors/result.dart';

/// "Book a Service" — the step between choosing a gig and paying.
///
/// Date/time here are the customer's *preferred* schedule, not a backend
/// availability grid — there is no `worker_availability` table/RPC in this
/// codebase to query real open slots against, and this app must never
/// invent one client-side (see product spec §18, §55). The chosen
/// date/time is sent as `scheduled_at` on the booking; the worker can
/// accept, propose a change, or the backend can reject it through the
/// normal booking-acceptance flow.
class BookServiceScreen extends ConsumerStatefulWidget {
  const BookServiceScreen({super.key, required this.gigCard});

  final Map<String, dynamic> gigCard;

  @override
  ConsumerState<BookServiceScreen> createState() => _BookServiceScreenState();
}

class _BookServiceScreenState extends ConsumerState<BookServiceScreen> {
  static const _timeSlots = ['9:00 AM', '11:00 AM', '1:00 PM', '3:00 PM', '5:00 PM'];

  /// A slot has to be far enough ahead for someone to actually travel to it.
  static const _leadTime = Duration(minutes: 30);

  late final List<DateTime> _dates;
  int _dateIndex = 0;
  int _timeIndex = 0;
  final _notesController = TextEditingController();
  bool _isBooking = false;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    _dates = List.generate(5, (i) => DateTime(today.year, today.month, today.day + i));

    // Booking at 9:00 AM on an evening when 9:00 AM has long gone was possible
    // because today and its first slot were simply the defaults. Start on the
    // first slot anyone could still turn up for.
    for (var d = 0; d < _dates.length; d++) {
      final slot = _firstBookableSlot(d);
      if (slot != null) {
        _dateIndex = d;
        _timeIndex = slot;
        break;
      }
    }
  }

  DateTime _slotAt(int dateIndex, int timeIndex) {
    final date = _dates[dateIndex];
    final parsed = DateFormat('h:mm a').parse(_timeSlots[timeIndex]);
    return DateTime(date.year, date.month, date.day, parsed.hour, parsed.minute);
  }

  bool _isBookable(int dateIndex, int timeIndex) =>
      _slotAt(dateIndex, timeIndex).isAfter(DateTime.now().add(_leadTime));

  int? _firstBookableSlot(int dateIndex) {
    for (var t = 0; t < _timeSlots.length; t++) {
      if (_isBookable(dateIndex, t)) return t;
    }
    return null;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  DateTime get _scheduledAt => _slotAt(_dateIndex, _timeIndex);

  Future<void> _confirm() async {
    final gigId = widget.gigCard['gigId'] as String?;
    final request = widget.gigCard['request'] as Map<String, dynamic>?;
    final addressLine = request?['addressLine'] as String?;
    final latitude = (request?['latitude'] as num?)?.toDouble();
    final longitude = (request?['longitude'] as num?)?.toDouble();

    if (gigId == null || request == null || addressLine == null || latitude == null || longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Missing booking details — please start again.')),
      );
      return;
    }

    // The chips are disabled from the clock at build time, so a screen left
    // open across a slot boundary can still be holding one that has since
    // passed. Re-check at the moment of booking and move the selection on.
    if (!_isBookable(_dateIndex, _timeIndex)) {
      final next = _firstBookableSlot(_dateIndex);
      setState(() {
        if (next != null) {
          _timeIndex = next;
        } else if (_dateIndex + 1 < _dates.length) {
          _dateIndex += 1;
          _timeIndex = _firstBookableSlot(_dateIndex) ?? 0;
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('That time has passed. We moved you to the next '
              'available slot — check it and confirm again.'),
        ),
      );
      return;
    }

    setState(() => _isBooking = true);
    final res = await ref.read(bookingRepositoryProvider).createBooking(
          gigId: gigId,
          problemDescription: (request['description'] as String?)?.trim().isNotEmpty == true
              ? request['description'] as String
              : 'Home service request',
          addressLine: addressLine,
          city: request['city'] as String? ?? '',
          latitude: latitude,
          longitude: longitude,
          scheduledAt: _scheduledAt,
          notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
        );

    if (!mounted) return;
    setState(() => _isBooking = false);

    switch (res) {
      case Ok(:final value):
        context.go('/bookings/${value.id}/payment');
      case Err(:final failure):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking failed: ${failure.message}'), backgroundColor: AppColors.statusError),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final workerName = widget.gigCard['workerName'] as String? ?? 'Professional';
    final serviceTitle = widget.gigCard['serviceTitle'] as String? ?? '';
    final priceLabel = widget.gigCard['priceLabel'] as String? ?? '—';
    final workerPhotoUrl = widget.gigCard['workerPhotoUrl'] as String?;
    final request = widget.gigCard['request'] as Map<String, dynamic>?;
    final addressLine = request?['addressLine'] as String? ?? 'No address selected';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Book a Service')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Worker/gig summary row.
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: AppColors.primarySurface,
                            backgroundImage:
                                workerPhotoUrl != null ? NetworkImage(workerPhotoUrl) : null,
                            child: workerPhotoUrl == null
                                ? Text(
                                    workerName.isNotEmpty ? workerName[0].toUpperCase() : 'W',
                                    style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(workerName,
                                    style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.ink)),
                                Text(serviceTitle,
                                    style: const TextStyle(fontSize: 12, color: AppColors.inkSecondary)),
                              ],
                            ),
                          ),
                          Text(priceLabel,
                              style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.ink)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    const _SectionLabel('Select Date'),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 68,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _dates.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (_, i) {
                          final d = _dates[i];
                          final selected = i == _dateIndex;
                          final label = i == 0 ? 'Today' : DateFormat('EEE').format(d);
                          final firstFree = _firstBookableSlot(i);
                          return _SelectChip(
                            selected: selected,
                            enabled: firstFree != null,
                            onTap: () => setState(() {
                              _dateIndex = i;
                              if (!_isBookable(i, _timeIndex)) {
                                _timeIndex = firstFree ?? _timeIndex;
                              }
                            }),
                            width: 68,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(label,
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: selected ? Colors.white : AppColors.ink)),
                                Text(DateFormat('d MMM').format(d),
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: selected ? Colors.white70 : AppColors.inkSecondary)),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    const _SectionLabel('Select Time'),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: List.generate(_timeSlots.length, (i) {
                        final selected = i == _timeIndex;
                        final bookable = _isBookable(_dateIndex, i);
                        return _SelectChip(
                          selected: selected,
                          enabled: bookable,
                          onTap: () => setState(() => _timeIndex = i),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Text(
                              _timeSlots[i],
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: selected ? Colors.white : AppColors.ink,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const _SectionLabel('Address'),
                        TextButton(
                          onPressed: () => context.pop(),
                          child: const Text('Change'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.home_outlined, color: AppColors.primary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              addressLine,
                              style: const TextStyle(fontSize: 13, color: AppColors.ink),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    const _SectionLabel('Special Instructions (Optional)'),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'e.g. Focus on kitchen and bathroom...',
                        filled: true,
                        fillColor: AppColors.surfaceMuted,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isBooking ? null : _confirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: _isBooking
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                        )
                      : const Text(
                          'Confirm Booking →',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.ink),
    );
  }
}

class _SelectChip extends StatelessWidget {
  const _SelectChip({
    required this.selected,
    required this.onTap,
    required this.child,
    this.width,
    this.enabled = true,
  });

  final bool selected;
  final VoidCallback onTap;
  final Widget child;
  final double? width;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.4,
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: Container(
          width: width,
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: selected ? AppColors.primary : AppColors.border),
          ),
          child: child,
        ),
      ),
    );
  }
}
