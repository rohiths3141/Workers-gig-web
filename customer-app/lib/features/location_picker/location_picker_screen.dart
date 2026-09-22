import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../app/theme/app_colors.dart';

class LocationPickerScreen extends StatefulWidget {
  final Map<String, dynamic>? initial;

  const LocationPickerScreen({super.key, this.initial});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  GoogleMapController? _mapController;
  LatLng _center = const LatLng(20.5937, 78.9629); // Geographic center of India — placeholder camera position only, never presented as the customer's location.
  final _addressLineController = TextEditingController();
  final _landmarkController = TextEditingController();
  bool _isLocating = false;
  bool _hasLocatedOnce = false;
  bool _permissionDenied = false;
  Timer? _geocodeDebounce;
  String? _city;
  String? _state;
  String? _pincode;

  @override
  void initState() {
    super.initState();
    if (widget.initial != null) {
      final lat = widget.initial!['latitude'] as double?;
      final lng = widget.initial!['longitude'] as double?;
      if (lat != null && lng != null) {
        _center = LatLng(lat, lng);
      }
      _addressLineController.text = widget.initial!['addressLine'] ?? '';
      _landmarkController.text = widget.initial!['landmark'] ?? '';
      _city = widget.initial!['city'] as String?;
      _state = widget.initial!['state'] as String?;
      _pincode = widget.initial!['pincode'] as String?;
      _hasLocatedOnce = true;
    } else {
      _getCurrentLocation();
    }
  }

  void _scheduleReverseGeocode(LatLng point) {
    _geocodeDebounce?.cancel();
    _geocodeDebounce = Timer(const Duration(milliseconds: 700), () => _reverseGeocode(point));
  }

  Future<void> _reverseGeocode(LatLng point) async {
    try {
      final placemarks = await placemarkFromCoordinates(point.latitude, point.longitude);
      if (!mounted || placemarks.isEmpty) return;
      final place = placemarks.first;
      final formatted = [
        place.street,
        place.subLocality,
        place.locality,
      ].where((s) => s != null && s.trim().isNotEmpty).join(', ');

      setState(() {
        _city = place.locality;
        _state = place.administrativeArea;
        _pincode = place.postalCode;
        // Only overwrite if the customer hasn't typed a custom address yet.
        if (_addressLineController.text.trim().isEmpty && formatted.isNotEmpty) {
          _addressLineController.text = formatted;
        }
      });
    } catch (_) {
      // Reverse geocoding is a convenience, not a requirement — the
      // customer can still type the address manually.
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLocating = true;
      _permissionDenied = false;
    });
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _isLocating = false;
          _hasLocatedOnce = true;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          _isLocating = false;
          _hasLocatedOnce = true;
          _permissionDenied = true;
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      final newCenter = LatLng(position.latitude, position.longitude);
      setState(() {
        _center = newCenter;
        _isLocating = false;
        _hasLocatedOnce = true;
      });
      _mapController?.animateCamera(CameraUpdate.newLatLngZoom(newCenter, 16.0));
      _reverseGeocode(newCenter);
    } catch (_) {
      setState(() {
        _isLocating = false;
        _hasLocatedOnce = true;
      });
    }
  }

  void _confirmLocation() {
    final addressText = _addressLineController.text.trim();
    if (addressText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter or confirm the address for this pin')),
      );
      return;
    }

    context.pop({
      'latitude': _center.latitude,
      'longitude': _center.longitude,
      'addressLine': addressText,
      'landmark': _landmarkController.text.trim(),
      'city': _city,
      'state': _state,
      'pincode': _pincode,
    });
  }

  @override
  void dispose() {
    _geocodeDebounce?.cancel();
    _addressLineController.dispose();
    _landmarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Service Address'),
      ),
      body: Stack(
        children: [
          // The map is only created once the first fix (or a pre-supplied
          // location) has landed. Creating it up front meant its Android
          // surface was attached while the system location-permission dialog
          // had the activity paused, and it came back a blank grey sheet —
          // the other maps in the app build after their target is known and
          // never show this. It also stops the camera opening on the middle
          // of India before jumping.
          if (_hasLocatedOnce) ...[
            GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: _center, zoom: 15.0),
              onMapCreated: (controller) => _mapController = controller,
              onCameraMove: (position) => _center = position.target,
              onCameraIdle: () => _scheduleReverseGeocode(_center),
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
            ),

            // Center Pin Marker — a fixed-position overlay icon, not a
            // GoogleMap Marker, so it always tracks the exact camera center
            // the customer is selecting.
            const Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 36),
                child: Icon(
                  Icons.location_on,
                  size: 48,
                  color: AppColors.primary,
                ),
              ),
            ),
          ] else
            Container(
              color: AppColors.surfaceMuted,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 12),
                    Text('Getting your location...',
                        style: TextStyle(color: AppColors.inkSecondary)),
                  ],
                ),
              ),
            ),

          if (_permissionDenied)
            Positioned(
              left: 12,
              right: 12,
              top: 12,
              child: Material(
                color: AppColors.statusError.withOpacity(0.95),
                borderRadius: BorderRadius.circular(12),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Text(
                    'Location permission denied — move the map manually to pick your address.',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ),

          // GPS Location FAB
          Positioned(
            right: 16,
            top: 16,
            child: FloatingActionButton.small(
              backgroundColor: Colors.white,
              onPressed: _isLocating ? null : _getCurrentLocation,
              child: _isLocating
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.my_location, color: AppColors.primary),
            ),
          ),

          // Bottom Address Card
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.place, color: AppColors.primary),
                        SizedBox(width: 8),
                        Text(
                          'Confirm Service Pin Position',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _addressLineController,
                      decoration: InputDecoration(
                        labelText: 'House / Flat / Street Name',
                        hintText: 'e.g. #102, Green Avenue, Indiranagar',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _landmarkController,
                      decoration: InputDecoration(
                        labelText: 'Landmark (Optional)',
                        hintText: 'e.g. Near HDFC Bank ATM',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _confirmLocation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Confirm Location & Proceed',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
