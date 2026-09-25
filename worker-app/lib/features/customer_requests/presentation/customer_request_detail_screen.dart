import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers/providers.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/localization/l10n.dart';
import '../../../domain/entities/customer_service_request.dart';
import '../../../shared/widgets/service_names.dart';

/// Detail screen for a customer service request with an offer form.
class CustomerRequestDetailScreen extends ConsumerStatefulWidget {
  const CustomerRequestDetailScreen({
    super.key,
    required this.requestId,
    this.preloaded,
  });

  final String requestId;
  final CustomerServiceRequest? preloaded;

  @override
  ConsumerState<CustomerRequestDetailScreen> createState() =>
      _CustomerRequestDetailScreenState();
}

class _CustomerRequestDetailScreenState
    extends ConsumerState<CustomerRequestDetailScreen> {
  CustomerServiceRequest? _request;
  bool _loading = true;
  bool _submitting = false;
  String? _error;

  // Offer form
  final _priceController = TextEditingController();
  final _durationController = TextEditingController();
  final _messageController = TextEditingController();
  bool _showOfferForm = false;
  bool _alreadyOffered = false;

  @override
  void initState() {
    super.initState();
    if (widget.preloaded != null) {
      _request = widget.preloaded;
      _loading = false;
    }
    _loadData();
  }

  @override
  void dispose() {
    _priceController.dispose();
    _durationController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    // Load request details.
    final result = await ref
        .read(customerRequestDiscoveryProvider)
        .getRequest(widget.requestId);

    if (!mounted) return;
    result.fold(
      (request) => setState(() {
        _request = request;
        _loading = false;
      }),
      (failure) => setState(() {
        _error = failure.message;
        _loading = false;
      }),
    );

    // Check if we already submitted an offer.
    final offers = await ref
        .read(workerOfferRepositoryProvider)
        .getOffersForRequest(widget.requestId);
    if (mounted) {
      offers.fold(
        (list) =>
            setState(() => _alreadyOffered = list.isNotEmpty),
        (_) {},
      );
    }
  }

  Future<void> _submitOffer() async {
    final price = double.tryParse(_priceController.text);
    if (price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(context.l10n.requestEnterPrice),
      ));
      return;
    }

    setState(() => _submitting = true);

    final result = await ref.read(workerOfferRepositoryProvider).submitOffer(
          serviceRequestId: widget.requestId,
          quotedAmountMinor: (price * 100).round(),
          estimatedDuration: _durationController.text.trim().isNotEmpty
              ? _durationController.text.trim()
              : null,
          message: _messageController.text.trim().isNotEmpty
              ? _messageController.text.trim()
              : null,
        );

    if (!mounted) return;
    setState(() => _submitting = false);

    result.fold(
      (offer) {
        setState(() {
          _alreadyOffered = true;
          _showOfferForm = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(context.l10n.requestOfferSubmitted(offer.priceLabel)),
          backgroundColor: AppColors.success,
        ));
      },
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(failure.message),
          backgroundColor: AppColors.danger,
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.requestDetailsTitle)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : _buildContent(),
      bottomNavigationBar: _request != null && !_alreadyOffered
          ? _buildBottomBar()
          : _alreadyOffered
              ? _buildAlreadyOfferedBar()
              : null,
    );
  }

  Widget _buildContent() {
    final l10n = context.l10n;
    final r = _request!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            r.title,
            style: const TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.ink),
          ),
          const SizedBox(height: 12),

          // Status & Code
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  r.status.isOpen ? l10n.requestStatusOpen : r.status.wire,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '#${r.requestCode}',
                style: TextStyle(fontSize: 12, color: AppColors.inkTertiary),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Description
          Text(
            r.description,
            style: TextStyle(
                color: AppColors.inkSecondary, fontSize: 14, height: 1.6),
          ),
          const SizedBox(height: 20),

          // Details card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                _row(Icons.category_rounded, l10n.requestCategory,
                    localizedServiceName(l10n, r.categoryName)),
                _row(Icons.currency_rupee, l10n.requestBudget, r.budgetLabel),
                _row(Icons.schedule, l10n.requestSchedule, r.scheduleLabel),
                if (r.distanceLabel.isNotEmpty)
                  _row(Icons.location_on, l10n.requestDistance, r.distanceLabel),
                if (r.city != null)
                  _row(Icons.place, l10n.requestArea, '${r.city ?? ''}${r.pincode != null ? ' (${r.pincode})' : ''}'),
                _row(Icons.people_outline, l10n.requestOffers, r.offerCountLabel),
                if (r.additionalNotes != null)
                  _row(Icons.note, l10n.requestNotes, r.additionalNotes!),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Privacy notice
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.infoSurface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.privacy_tip_outlined,
                    size: 18, color: AppColors.info),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.requestAddressPrivacy,
                    style: TextStyle(fontSize: 12, color: AppColors.info),
                  ),
                ),
              ],
            ),
          ),

          // Offer form
          if (_showOfferForm) ...[
            const SizedBox(height: 24),
            _buildOfferForm(),
          ],
        ],
      ),
    );
  }

  Widget _buildOfferForm() {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.requestYourOffer,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: l10n.requestYourPrice,
              hintText: l10n.requestPriceHint,
              prefixIcon: const Icon(Icons.currency_rupee),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _durationController,
            decoration: InputDecoration(
              labelText: l10n.requestDuration,
              hintText: l10n.requestDurationHint,
              prefixIcon: const Icon(Icons.timer_outlined),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _messageController,
            maxLines: 3,
            maxLength: 500,
            decoration: InputDecoration(
              labelText: l10n.requestMessage,
              hintText: l10n.requestMessageHint,
              prefixIcon: const Padding(
                padding: EdgeInsets.only(bottom: 48),
                child: Icon(Icons.message_outlined),
              ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _submitting ? null : _submitOffer,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: _submitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : Text(l10n.requestSubmitOffer,
                      style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: FilledButton.icon(
          onPressed: () => setState(() => _showOfferForm = !_showOfferForm),
          icon: Icon(_showOfferForm ? Icons.close : Icons.local_offer),
          label: Text(_showOfferForm
              ? context.l10n.commonCancel
              : context.l10n.requestMakeOffer),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }

  Widget _buildAlreadyOfferedBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.successSurface,
        border: Border(top: BorderSide(color: AppColors.success)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.success),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                context.l10n.requestAlreadyOffered,
                style: TextStyle(fontSize: 13),
              ),
            ),
            TextButton(
              onPressed: () => context.push('/my-offers'),
              child: Text(context.l10n.requestViewOffers),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          SizedBox(
            width: 72,
            child: Text(label,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.inkTertiary,
                    fontSize: 13)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(color: AppColors.ink, fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
