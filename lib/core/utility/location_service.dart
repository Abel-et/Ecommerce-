
import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> determineCurrentLocation() async {
    // 1. Check whether GPS/location services are enabled.
    bool serviceEnabled =
        await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception(
        'Location services are disabled. Please enable GPS.',
      );
    }

    // 2. Check location permission.
    LocationPermission permission =
        await Geolocator.checkPermission();

    // 3. Request permission if denied.
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        throw Exception(
          'Location permission was denied.',
        );
      }
    }

    // 4. Handle permanently denied permission.
    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permission is permanently denied. '
        'Please enable it from app settings.',
      );
    }

    // 5. Get current coordinates.
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }
}
