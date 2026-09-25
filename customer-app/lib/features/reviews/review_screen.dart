import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers/providers.dart';
import '../../app/theme/app_colors.dart';
import '../../core/errors/result.dart';
import '../../core/localization/l10n.dart';

class ReviewScreen extends ConsumerStatefulWidget {
  final String bookingId;

  const ReviewScreen({super.key, required this.bookingId});

  @override
  ConsumerState<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends ConsumerState<ReviewScreen> {
  int _rating = 5;
  final _commentController = TextEditingController();
  bool _isSubmitting = false;
  String? _error;

  Future<void> _submitReview() async {
    setState(() {
      _isSubmitting = true;
      _error = null;
    });

    final res = await ref.read(reviewRepositoryProvider).rateWorker(
          bookingId: widget.bookingId,
          rating: _rating,
          comment: _commentController.text,
        );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    switch (res) {
      case Ok():
        if (!mounted) return;
        final booking = ref.read(bookingStreamProvider(widget.bookingId)).valueOrNull;
        context.go(
          '/bookings/${widget.bookingId}/completed',
          extra: {
            'serviceName': booking?.serviceName ?? context.l10n.paymentService,
            'workerName': booking?.workerName,
            'amountLabel': booking?.amountLabel,
          },
        );
      case Err(:final failure):
        setState(() => _error = failure.message);
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(l10n.reviewTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(color: AppColors.primarySurface, shape: BoxShape.circle),
                child: const Icon(Icons.thumb_up_alt_rounded, color: AppColors.primary, size: 44),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.reviewHeading,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.ink),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.reviewQuestion,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.inkSecondary, fontSize: 13),
              ),
              const SizedBox(height: 24),

              // Star Rating Row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final starNum = index + 1;
                  return AnimatedScale(
                    scale: starNum <= _rating ? 1.1 : 1.0,
                    duration: const Duration(milliseconds: 150),
                    child: IconButton(
                      iconSize: 40,
                      tooltip: l10n.reviewStars(starNum),
                      icon: Icon(
                        starNum <= _rating ? Icons.star_rounded : Icons.star_border_rounded,
                        color: AppColors.star,
                      ),
                      onPressed: () => setState(() => _rating = starNum),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),

              // Comment Field
              TextField(
                controller: _commentController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: l10n.reviewCommentHint,
                  filled: true,
                  fillColor: AppColors.surfaceMuted,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              if (_error != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.dangerSurface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: AppColors.statusError),
                      const SizedBox(width: 8),
                      Expanded(child: Text(_error!, style: const TextStyle(color: AppColors.statusError))),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitReview,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                        )
                      : Text(
                          l10n.reviewSubmit,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
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
