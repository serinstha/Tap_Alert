import 'package:college_project/applications/permission_utils/location.dart';
import 'package:college_project/applications/permission_utils/location_permission.dart';
import 'package:geolocator/geolocator.dart';
import 'package:another_telephony/telephony.dart';

class SmsService {
  static final Telephony telephony = Telephony.instance;

  /// Sends current location via SMS to all saved contacts
  static Future<void> sendLocationToContacts(
    List<Map<String, dynamic>> contacts,
  ) async {
    if (contacts.isEmpty) {
      throw Exception('No emergency contacts saved.');
    }

    // Request SMS permission
    bool? permissionsGranted = await telephony.requestPhoneAndSmsPermissions;
    if (permissionsGranted != true) {
      throw Exception('SMS permissions not granted.');
    }
     // Request location permission
    bool locationGranted = await LocationPermissionService.requestLocationPermission();
    if (!locationGranted) {
      print('❌ Location permission denied, opening settings...');
      await LocationPermissionService.openAppSettings();
      return;
    }

    // Get current location
    Position pos;
    try {
      pos = await LocationService.getCurrentLocation();
      print('✅ Current location: ${pos.latitude}, ${pos.longitude}');
    } catch (e) {
      print('❌ Failed to get location: $e');
      return;
    }

    // // Get current GPS location
    // Position pos = await Geolocator.getCurrentPosition(
    //   // ignore: deprecated_member_use
    //   desiredAccuracy: LocationAccuracy.high,
    //  print('✅ Current location: ${pos.latitude}, ${pos.longitude}');
      
    // );

    // Build SOS message with Google Maps link
    final url = "https://www.google.com/maps/search/?api=1&query=${pos.latitude},${pos.longitude}";
     final encodedUrl = Uri.encodeFull(url);
    final message =
         "Emergency! I need help.\nMy location: $encodedUrl";
        //"🚨 Emergency! I need help.\nMy location: https://www.openstreetmap.org/?mlat=${pos.latitude}&mlon=${pos.longitude}&zoom=18";

    // Loop through all saved contacts and send SMS
    for (var c in contacts) {
      final phone = c['P_number'];
      if (phone != null && phone.isNotEmpty) {
        await telephony.sendSms(to: phone, message: message);
        statusListener:
        (SendStatus status) {
          print('SMS Status: $status');
        };
      }
    }
  }
}
