import 'package:geolocator/geolocator.dart';

class LocationPermissionService {
  /// Requests location permission and returns true if granted
  static Future<bool> requestLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      return false;
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  /// Redirect user to app settings
  static Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
    await Geolocator.openLocationSettings();
  }
}
