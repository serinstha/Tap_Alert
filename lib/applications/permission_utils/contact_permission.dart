import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> requestContactPermission() async {
    // Check current status
    PermissionStatus status = await Permission.contacts.status;
    // If not granted, request permission
    if (!status.isGranted) {
      status = await Permission.contacts.request();
    }
    // Return final status
    return status.isGranted;
  }
}
