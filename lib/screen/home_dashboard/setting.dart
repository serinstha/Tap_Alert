import 'package:college_project/authentication/auth_bloc/auth_bloc.dart';
import 'package:college_project/authentication/auth_bloc/auth_event.dart';
import 'package:college_project/authentication/auth_bloc/auth_state.dart';
import 'package:college_project/authentication/screen/loginscreen.dart';
import 'package:college_project/screen/home_dashboard/about.dart';
import 'package:college_project/screen/home_dashboard/faq.dart';
import 'package:college_project/screen/home_dashboard/instructions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  void _showSnackBar(String message, {Color? backgroundColor}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            message,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        backgroundColor: backgroundColor ?? Colors.grey[300],
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure you want to logout?"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                // Dispatch logout event to AuthBloc
                context.read<AuthBloc>().add(LogoutRequested());
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text(
                "Logout",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
        backgroundColor: Colors.indigo[300],
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Unauthenticated) {
            _showSnackBar("LOGGED OUT SUCCESSFULLY");
            // Navigate to login and remove all previous routes
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginPage()),
              (route) => false,
            );
          } else if (state is AuthError) {
            _showSnackBar(
              "Logout failed: ${state.message}",
              backgroundColor: Colors.redAccent,
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Column(
            children: [
              const SizedBox(height: 15),
              _buildSettingTile(
                icon: Icons.phone_android,
                label: 'Instructions',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context)=> const InstructionsScreen() ),
                  );
                },
              ),
              const SizedBox(height: 15),
              _buildSettingTile(
                icon: Icons.question_answer,
                label: 'FAQ',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const FaqScreen())
                  );
                  
                },
              ),
              const SizedBox(height: 15),
              _buildSettingTile(
                icon: Icons.group_add,
                label: 'Invite Friends',
                onTap: () {
                  // TODO: Implement share/invite logic
                  debugPrint("Invite Friends tapped");
                },
              ),
              const SizedBox(height: 15),
              _buildSettingTile(
                icon: Icons.info_outline,
                label: 'About',
                onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AboutUsPage())
                  );
                },
              ),
              const SizedBox(height: 15),
              _buildSettingTile(
                icon: Icons.logout,
                label: 'Logout',
                iconColor: Colors.red,
                onTap: _handleLogout,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: iconColor ?? Colors.indigo),
        title: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: onTap,
      ),
    );
  }
}
