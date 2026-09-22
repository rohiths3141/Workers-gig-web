import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../app/theme/app_colors.dart';

class ServiceRequestScreen extends StatefulWidget {
  final String serviceId;
  final String serviceName;

  /// Either a location map (from the location picker, carrying latitude/
  /// longitude/addressLine/...) or a preset map carrying only
  /// 'presetDescription' (from the service-problem picker) — never both at
  /// once in this app's current navigation paths.
  final Map<String, dynamic>? prefilledLocation;

  const ServiceRequestScreen({
    super.key,
    required this.serviceId,
    required this.serviceName,
    this.prefilledLocation,
  });

  @override
  State<ServiceRequestScreen> createState() => _ServiceRequestScreenState();
}

class _ServiceRequestScreenState extends State<ServiceRequestScreen> {
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final List<XFile> _selectedImages = [];
  Map<String, dynamic>? _selectedLocation;
  bool _isInstantBooking = true;
  bool _isDetectingLocation = false;
  final DateTime _scheduledTime = DateTime.now().add(const Duration(hours: 2));

  @override
  void initState() {
    super.initState();
    final extra = widget.prefilledLocation;
    if (extra != null && extra.containsKey('latitude') && extra.containsKey('longitude')) {
      _selectedLocation = extra;
      if (extra['presetDescription'] is String) {
        _descriptionController.text = extra['presetDescription'] as String;
      }
    } else if (extra != null && extra['presetDescription'] is String) {
      _descriptionController.text = extra['presetDescription'] as String;
      // No location yet — auto-detect GPS so the address card is pre-filled.
      _autoDetectLocation();
    } else if (extra == null) {
      _autoDetectLocation();
    }
  }

  /// Silently detects the device's GPS position and reverse-geocodes it.
  /// The result pre-fills the address card so users don't have to open the
  /// map picker manually before tapping "Find Available Workers".
  Future<void> _autoDetectLocation() async {
    setState(() => _isDetectingLocation = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) return;

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );

      // Reverse-geocode to get a human-readable address.
      String addressLine = '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
      String? city, state, pincode;
      try {
        final placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          final parts = [
            p.street,
            p.subLocality,
            p.locality,
          ].where((s) => s != null && s.trim().isNotEmpty);
          if (parts.isNotEmpty) addressLine = parts.join(', ');
          city = p.locality;
          state = p.administrativeArea;
          pincode = p.postalCode;
        }
      } catch (_) {
        // Geocoding failed — fall back to raw coordinates.
      }

      if (!mounted) return;
      setState(() {
        _selectedLocation = {
          'latitude': position.latitude,
          'longitude': position.longitude,
          'addressLine': addressLine,
          'landmark': '',
          'city': city,
          'state': state,
          'pincode': pincode,
        };
      });
    } catch (_) {
      // Silent — user can still tap the address card to pick manually.
    } finally {
      if (mounted) setState(() => _isDetectingLocation = false);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null && _selectedImages.length < 3) {
      setState(() {
        _selectedImages.add(image);
      });
    }
  }

  Future<void> _chooseLocation() async {
    final result = await context.push<Map<String, dynamic>>(
      '/location-picker',
      extra: _selectedLocation,
    );
    if (result != null) {
      setState(() {
        _selectedLocation = result;
      });
    }
  }

  void _proceedToGigDiscovery() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a service location')),
      );
      return;
    }

    final requestData = {
      'serviceId': widget.serviceId,
      'serviceName': widget.serviceName.isEmpty ? 'Home Service' : widget.serviceName,
      'description': _descriptionController.text.trim(),
      'latitude': _selectedLocation!['latitude'],
      'longitude': _selectedLocation!['longitude'],
      'addressLine': _selectedLocation!['addressLine'],
      'landmark': _selectedLocation!['landmark'],
      'city': _selectedLocation!['city'],
      'state': _selectedLocation!['state'],
      'pincode': _selectedLocation!['pincode'],
      'isInstant': _isInstantBooking,
      'scheduledTime': _scheduledTime.toIso8601String(),
    };

    context.push('/gig-discovery', extra: requestData);
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request ${widget.serviceName.isEmpty ? "Service" : widget.serviceName}'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Location Selector Card
                GestureDetector(
                  onTap: _chooseLocation,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, color: AppColors.primary, size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Service Address',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: AppColors.ink,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _isDetectingLocation
                                    ? 'Detecting your location…'
                                    : (_selectedLocation != null
                                        ? _selectedLocation!['addressLine'] as String
                                        : 'Tap to pick service location'),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: _isDetectingLocation ? AppColors.primary : AppColors.inkSecondary,
                                  fontStyle: _isDetectingLocation ? FontStyle.italic : FontStyle.normal,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: AppColors.primary),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Description Box
                Text(
                  'Describe the Issue / Task',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.ink,
                      ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'e.g. Living room main ceiling light switch is sparking when turned on.',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().length < 10) {
                      return 'Please describe the problem in at least 10 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Photo Attachments
                Text(
                  'Attach Photos of Problem (Optional)',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.ink,
                      ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ..._selectedImages.map(
                      (file) => Container(
                        width: 70,
                        height: 70,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                          color: Colors.grey[200],
                        ),
                        child: const Icon(Icons.image, color: AppColors.inkSecondary),
                      ),
                    ),
                    if (_selectedImages.length < 3)
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.primary, style: BorderStyle.solid),
                            color: AppColors.primary.withOpacity(0.05),
                          ),
                          child: const Icon(Icons.add_a_photo_outlined, color: AppColors.primary),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 24),

                // Timing Option
                Text(
                  'When do you need the service?',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.ink,
                      ),
                ),
                const SizedBox(height: 8),
                // A chip sizes itself to its label, so inside an Expanded the
                // label was clipped to "Instant (30" and "Schedule Late".
                // Centring and scaling the label keeps both readable at any
                // width.
                Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        label: const SizedBox(
                          width: double.infinity,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.center,
                            child: Text('⚡ Instant (30 min)'),
                          ),
                        ),
                        selected: _isInstantBooking,
                        onSelected: (val) => setState(() => _isInstantBooking = true),
                        selectedColor: AppColors.primary.withOpacity(0.2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ChoiceChip(
                        label: const SizedBox(
                          width: double.infinity,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.center,
                            child: Text('📅 Schedule later'),
                          ),
                        ),
                        selected: !_isInstantBooking,
                        onSelected: (val) => setState(() => _isInstantBooking = false),
                        selectedColor: AppColors.primary.withOpacity(0.2),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Proceed Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _proceedToGigDiscovery,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Find Available Workers',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
