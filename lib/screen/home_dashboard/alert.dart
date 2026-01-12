import 'package:college_project/contact/contact_repository/contact_repository.dart';
import 'package:college_project/screen/home_dashboard/sms.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class Alert extends StatefulWidget {
  const Alert({super.key});

  @override
  State<Alert> createState() => _AlertState();
}

class _AlertState extends State<Alert> {
  final user = FirebaseAuth.instance.currentUser;
  final repo = ContactRepository();

  void _showSnackBar(String message, {Color? backgroundColor}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _sendSOS() async {
    try {
      if (user == null) {
        _showSnackBar("User not logged in", backgroundColor: Colors.redAccent);
        return;
      }

      var smsStatus = await Permission.sms.status;
      if (!smsStatus.isGranted) smsStatus = await Permission.sms.request();
      if (!smsStatus.isGranted) {
        _showSnackBar("❌ SMS permission denied. Please enable it.");
        return;
      }

      final contacts = await repo.getContacts(user!.uid);
      await SmsService.sendLocationToContacts(contacts);
      _showSnackBar("🚨 SOS sent to contacts");
    } catch (e) {
      _showSnackBar("Error: $e", backgroundColor: Colors.redAccent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                TextButton(
                  onPressed: () {
                    _sendSOS();
                  },
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/Screenshot 2025-11-10 at 2.34.45 AM.png",
                      ),
                      Text(
                        "PRESS THE BUTTON IN CASE OF EMERGENCY",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
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
