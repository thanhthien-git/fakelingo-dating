// screens/onboarding/location_permission_step.dart
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fakelingo/ui/components/fakelingo_button.dart';
import 'package:fakelingo/ui/components/animate_toast.dart';

class LocationPermissionStep extends StatefulWidget {
  final Function(Map<String, dynamic>?) onNext;

  const LocationPermissionStep({
    super.key,
    required this.onNext,
  });

  @override
  State<LocationPermissionStep> createState() => _LocationPermissionStepState();
}

class _LocationPermissionStepState extends State<LocationPermissionStep> {
  bool _isLoading = false;
  bool _permissionGranted = false;

  Future<void> _requestLocationPermission() async {
    setState(() => _isLoading = true);

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        AnimatedToast.show(context, 'Vui lòng bật dịch vụ vị trí');
        setState(() => _isLoading = false);
        return;
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          AnimatedToast.show(context, 'Quyền truy cập vị trí bị từ chối');
          setState(() => _isLoading = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        AnimatedToast.show(context, 'Vui lòng cấp quyền vị trí trong cài đặt');
        setState(() => _isLoading = false);
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _permissionGranted = true;
        _isLoading = false;
      });

      // Pass location data to next step
      widget.onNext({
        'location' : {
          'coordinates': [position.latitude, position.longitude]
        }
      });

    } catch (e) {
      setState(() => _isLoading = false);
      AnimatedToast.show(context, 'Không thể lấy vị trí hiện tại');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Location icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.1),
            ),
            child: Icon(
              _permissionGranted ? Icons.location_on : Icons.location_off,
              size: 60,
              color: _permissionGranted ? Colors.green : Colors.white,
            ),
          ),
          const SizedBox(height: 40),

          const Text(
            'Enable Location',
            style: TextStyle(
              fontFamily: 'FontBold',
              fontSize: 28,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          Text(
            'We need access to your location to show you people nearby and provide better matches.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 50),

          // Permission button
          AnimatedButton(
            onPressed: _isLoading || _permissionGranted ? null : _requestLocationPermission,
            child: _isLoading
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
                : Text(
              _permissionGranted ? 'Location Enabled ✓' : 'Allow Location Access',
              style: const TextStyle(
                fontFamily: 'FontBold',
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          if (_permissionGranted) ...[
            const SizedBox(height: 20),
            Text(
              'Great! Location access granted.',
              style: TextStyle(
                color: Colors.green.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
          ],

          const SizedBox(height: 30),

          // Skip button
          TextButton(
            onPressed: _isLoading ? null : () {
              // Continue without location
              widget.onNext({'location': null});
            },
            child: Text(
              'Skip for now',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}