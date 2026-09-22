import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers/providers.dart';
import '../../app/theme/app_colors.dart';
import '../../core/errors/result.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/service_category.dart';

/// Multi-step wizard for posting a customer service request.
///
/// Steps:
///   0. Category selection (pre-filled when navigated from a category page)
///   1. Title and description
///   2. Budget preference
///   3. Schedule preference
///   4. Location / address
///   5. Review and submit
class PostServiceRequestScreen extends ConsumerStatefulWidget {
  const PostServiceRequestScreen({
    super.key,
    this.preselectedCategoryId,
    this.preselectedCategoryName,
    this.prefilledLocation,
    this.prefilledTitle,
    this.prefilledDescription,
  });

  final String? preselectedCategoryId;
  final String? preselectedCategoryName;
  final Map<String, dynamic>? prefilledLocation;

  /// Carried in from the assistant, which has already asked the customer
  /// what is wrong. Re-typing it here is the single most obvious way to
  /// lose someone between describing a problem and posting it.
  final String? prefilledTitle;
  final String? prefilledDescription;

  @override
  ConsumerState<PostServiceRequestScreen> createState() =>
      _PostServiceRequestScreenState();
}

class _PostServiceRequestScreenState
    extends ConsumerState<PostServiceRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  int _currentStep = 0;
  bool _submitting = false;

  // Form data
  String? _categoryId;
  String? _categoryName;
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _notesController = TextEditingController();
  BudgetType _budgetType = BudgetType.none;
  final _budgetMinController = TextEditingController();
  final _budgetMaxController = TextEditingController();
  ScheduleType _scheduleType = ScheduleType.asap;
  DateTime? _scheduledDate;
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _pincodeController = TextEditingController();
  double? _latitude;
  double? _longitude;

  static const _totalSteps = 5;

  @override
  void initState() {
    super.initState();
    _categoryId = widget.preselectedCategoryId;
    _categoryName = widget.preselectedCategoryName;
    if (widget.prefilledTitle != null) {
      _titleController.text = widget.prefilledTitle!;
    }
    if (widget.prefilledDescription != null) {
      _descController.text = widget.prefilledDescription!;
    }
    if (widget.prefilledLocation != null) {
      _addressController.text =
          widget.prefilledLocation!['address_line'] as String? ?? '';
      _cityController.text =
          widget.prefilledLocation!['city'] as String? ?? '';
      _pincodeController.text =
          widget.prefilledLocation!['pincode'] as String? ?? '';
      _latitude = widget.prefilledLocation!['latitude'] as double?;
      _longitude = widget.prefilledLocation!['longitude'] as double?;
    }
    // If category is pre-selected, start on step 1.
    if (_categoryId != null) {
      _currentStep = 1;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _pageController.jumpToPage(1);
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _titleController.dispose();
    _descController.dispose();
    _notesController.dispose();
    _budgetMinController.dispose();
    _budgetMaxController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps) {
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _submit() async {
    if (_submitting) return;
    setState(() => _submitting = true);

    final repo = ref.read(serviceRequestRepositoryProvider);
    final result = await repo.createServiceRequest(
      categoryId: _categoryId!,
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      budgetType: _budgetType,
      budgetMinMinor: _budgetMinController.text.isNotEmpty
          ? (double.tryParse(_budgetMinController.text)! * 100).round()
          : null,
      budgetMaxMinor: _budgetMaxController.text.isNotEmpty
          ? (double.tryParse(_budgetMaxController.text)! * 100).round()
          : null,
      scheduleType: _scheduleType,
      scheduledDate: _scheduledDate,
      addressLine: _addressController.text.trim(),
      city: _cityController.text.trim().isNotEmpty
          ? _cityController.text.trim()
          : null,
      pincode: _pincodeController.text.trim().isNotEmpty
          ? _pincodeController.text.trim()
          : null,
      latitude: _latitude,
      longitude: _longitude,
      additionalNotes: _notesController.text.trim().isNotEmpty
          ? _notesController.text.trim()
          : null,
    );

    if (!mounted) return;
    setState(() => _submitting = false);

    switch (result) {
      case Ok(value: final request):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Service request ${request.requestCode} posted!'),
            backgroundColor: AppColors.successGreen,
          ),
        );
        // Navigate to the request detail or back to requests list.
        context.go('/my-requests/${request.id}');
      case Err(:final failure):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(failure.message),
            backgroundColor: Colors.redAccent,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post a Service Request'),
      ),
      body: Column(
        children: [
          // Progress indicator
          _buildProgress(),

          Expanded(
            child: Form(
              key: _formKey,
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildCategoryStep(),
                  _buildDetailsStep(),
                  _buildBudgetStep(),
                  _buildScheduleStep(),
                  _buildLocationStep(),
                  _buildReviewStep(),
                ],
              ),
            ),
          ),

          // Navigation buttons
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildProgress() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Row(
        children: List.generate(_totalSteps + 1, (i) {
          final isActive = i <= _currentStep;
          return Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primary
                    : AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ── Step 0: Category ──

  Widget _buildCategoryStep() {
    final categoriesAsync = ref.watch(serviceCategoriesProvider);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What service do you need?',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.ink),
          ),
          const SizedBox(height: 8),
          const Text(
            'Select the category that best describes your need.',
            style: TextStyle(color: AppColors.inkSecondary),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: categoriesAsync.when(
              data: (cats) => _buildCategoryList(cats),
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) =>
                  Center(child: Text('Error loading categories: $e')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList(List<ServiceCategory> categories) {
    return ListView.separated(
      itemCount: categories.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final cat = categories[index];
        final isSelected = _categoryId == cat.id;
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: isSelected
                ? AppColors.primary
                : AppColors.primary.withOpacity(0.08),
            child: Icon(
              Icons.home_repair_service_rounded,
              color: isSelected ? Colors.white : AppColors.primary,
            ),
          ),
          title: Text(
            cat.name,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? AppColors.primary : AppColors.ink,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSelected
                  ? AppColors.primary
                  : AppColors.border,
              width: isSelected ? 2 : 1,
            ),
          ),
          tileColor:
              isSelected ? AppColors.primary.withOpacity(0.04) : Colors.white,
          onTap: () {
            setState(() {
              _categoryId = cat.id;
              _categoryName = cat.name;
            });
          },
        );
      },
    );
  }

  // ── Step 1: Title & Description ──

  Widget _buildDetailsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Describe your requirement',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.ink),
          ),
          const SizedBox(height: 8),
          Text(
            _categoryName != null
                ? 'Service: $_categoryName'
                : 'What do you need done?',
            style: const TextStyle(color: AppColors.inkSecondary),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _titleController,
            decoration: _inputDecor('Title', 'e.g. Fix leaking kitchen tap'),
            maxLength: 200,
            validator: (v) =>
                (v == null || v.trim().length < 6) ? 'Enter at least 6 characters' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descController,
            decoration: _inputDecor(
              'Description',
              'Describe the problem in detail…',
            ),
            maxLines: 5,
            maxLength: 1000,
            validator: (v) =>
                (v == null || v.trim().length < 10) ? 'Enter at least 10 characters' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _notesController,
            decoration: _inputDecor(
              'Additional notes (optional)',
              'Gate code, preferred timing, etc.',
            ),
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  // ── Step 2: Budget ──

  Widget _buildBudgetStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your budget',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.ink),
          ),
          const SizedBox(height: 8),
          const Text(
            'Give workers an idea of what you\'re willing to pay.',
            style: TextStyle(color: AppColors.inkSecondary),
          ),
          const SizedBox(height: 24),
          ...BudgetType.values.map((bt) => RadioListTile<BudgetType>(
                value: bt,
                groupValue: _budgetType,
                title: Text(bt.label),
                activeColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                onChanged: (v) => setState(() => _budgetType = v!),
              )),
          if (_budgetType == BudgetType.fixed) ...[
            const SizedBox(height: 16),
            TextFormField(
              controller: _budgetMinController,
              decoration: _inputDecor('Fixed price (₹)', 'e.g. 500'),
              keyboardType: TextInputType.number,
            ),
          ],
          if (_budgetType == BudgetType.range) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _budgetMinController,
                    decoration: _inputDecor('Min (₹)', 'e.g. 300'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _budgetMaxController,
                    decoration: _inputDecor('Max (₹)', 'e.g. 800'),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ── Step 3: Schedule ──

  Widget _buildScheduleStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'When do you need this?',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.ink),
          ),
          const SizedBox(height: 24),
          ...ScheduleType.values.map((st) => RadioListTile<ScheduleType>(
                value: st,
                groupValue: _scheduleType,
                title: Text(st.label),
                activeColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                onChanged: (v) => setState(() => _scheduleType = v!),
              )),
          if (_scheduleType == ScheduleType.specificDate) ...[
            const SizedBox(height: 16),
            ListTile(
              title: Text(
                _scheduledDate != null
                    ? '${_scheduledDate!.day}/${_scheduledDate!.month}/${_scheduledDate!.year}'
                    : 'Pick a date',
                style: const TextStyle(color: AppColors.ink),
              ),
              trailing:
                  const Icon(Icons.calendar_today, color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: AppColors.border),
              ),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(days: 1)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 90)),
                );
                if (date != null) setState(() => _scheduledDate = date);
              },
            ),
          ],
        ],
      ),
    );
  }

  // ── Step 4: Location ──

  Widget _buildLocationStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Service location',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.ink),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your exact address is only shared once you accept an offer.',
            style: TextStyle(color: AppColors.inkSecondary, fontSize: 13),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _addressController,
            decoration: _inputDecor('Address', 'Full address'),
            maxLines: 2,
            validator: (v) =>
                (v == null || v.trim().length < 5) ? 'Enter a valid address' : null,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _cityController,
                  decoration: _inputDecor('City', 'e.g. Bangalore'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _pincodeController,
                  decoration: _inputDecor('Pincode', 'e.g. 560001'),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () async {
              final result = await context.push<Map<String, dynamic>>(
                '/location-picker',
              );
              if (result != null) {
                setState(() {
                  _latitude = result['latitude'] as double?;
                  _longitude = result['longitude'] as double?;
                  if (result['address_line'] != null) {
                    _addressController.text =
                        result['address_line'] as String;
                  }
                  if (result['city'] != null) {
                    _cityController.text = result['city'] as String;
                  }
                });
              }
            },
            icon: const Icon(Icons.my_location),
            label: Text(
              _latitude != null ? 'Location set ✓' : 'Set location on map',
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }

  // ── Step 5: Review ──

  Widget _buildReviewStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Review your request',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.ink),
          ),
          const SizedBox(height: 20),
          _reviewRow(Icons.category_rounded, 'Category',
              _categoryName ?? 'Not selected'),
          _reviewRow(Icons.title, 'Title',
              _titleController.text.isEmpty ? '—' : _titleController.text),
          _reviewRow(Icons.description, 'Description',
              _descController.text.isEmpty ? '—' : _descController.text),
          _reviewRow(Icons.currency_rupee, 'Budget',
              _budgetType == BudgetType.none
                  ? 'Flexible'
                  : _budgetType == BudgetType.fixed
                      ? '₹${_budgetMinController.text}'
                      : '₹${_budgetMinController.text} – ₹${_budgetMaxController.text}'),
          _reviewRow(Icons.schedule, 'When', _scheduleType.label),
          if (_scheduledDate != null)
            _reviewRow(Icons.calendar_today, 'Date',
                '${_scheduledDate!.day}/${_scheduledDate!.month}/${_scheduledDate!.year}'),
          _reviewRow(Icons.location_on, 'Location',
              _addressController.text.isEmpty ? '—' : _addressController.text),
          if (_notesController.text.isNotEmpty)
            _reviewRow(Icons.note, 'Notes', _notesController.text),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.accentGold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.accentGold.withOpacity(0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.accentGold, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Your exact address stays private until you accept an offer and a booking is created.',
                    style: TextStyle(fontSize: 12, color: AppColors.inkSecondary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _reviewRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.inkSecondary,
                  fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    color: AppColors.ink, fontSize: 14)),
          ),
        ],
      ),
    );
  }

  // ── Bottom bar ──

  Widget _buildBottomBar() {
    final isLast = _currentStep == _totalSteps;
    final canProceed = _canProceedFromCurrentStep();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            if (_currentStep > 0)
              TextButton.icon(
                onPressed: _prevStep,
                icon: const Icon(Icons.arrow_back_ios, size: 16),
                label: const Text('Back'),
                style: TextButton.styleFrom(
                    foregroundColor: AppColors.inkSecondary),
              ),
            const Spacer(),
            FilledButton(
              onPressed: canProceed
                  ? (isLast ? _submit : _nextStep)
                  : null,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.border,
                // A Row cannot satisfy the themed infinite minimum width.
                minimumSize: const Size(0, 44),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
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
                  : Text(isLast ? 'Submit Request' : 'Next'),
            ),
          ],
        ),
      ),
    );
  }

  bool _canProceedFromCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _categoryId != null;
      case 1:
        return _titleController.text.trim().length >= 6 &&
            _descController.text.trim().length >= 10;
      case 2:
        return true; // Budget is always optional
      case 3:
        if (_scheduleType == ScheduleType.specificDate && _scheduledDate == null) {
          return false;
        }
        return true;
      case 4:
        return _addressController.text.trim().length >= 5;
      case 5:
        return true;
      default:
        return false;
    }
  }

  InputDecoration _inputDecor(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            const BorderSide(color: AppColors.primary, width: 2),
      ),
    );
  }
}
