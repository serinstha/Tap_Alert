import 'package:permission_handler/permission_handler.dart';

class SmsPermissionService {
  /// Request SMS permission
  static Future<bool> requestSmsPermission() async {
    var status = await Permission.sms.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isDenied || status.isRestricted) {
      status = await Permission.sms.request();
      return status.isGranted;
    }

    return false;
  }

  /// Open app settings (for manual enabling)
  static Future<void> openAppSettings() async {
    await openAppSettings(); // from permission_handler
  }
}
