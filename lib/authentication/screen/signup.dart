import 'package:college_project/authentication/auth_bloc/auth_bloc.dart';
import 'package:college_project/authentication/auth_bloc/auth_event.dart';
import 'package:college_project/authentication/auth_bloc/auth_state.dart';
import 'package:college_project/screen/home_dashboard/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  // Controllers for form inputs
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();

  // State to show/hide password
  bool _obscurePassword = true;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    firstName.dispose();
    lastName.dispose();
    phoneNumber.dispose();
    super.dispose();
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _showSnackBar(BuildContext context, String title, String message,
      {Color? backgroundColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor ?? Colors.black87,
        behavior: SnackBarBehavior.floating,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(message, style: const TextStyle(color: Colors.white)),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Validate inputs before signup
  bool validateInputs(BuildContext context) {
    if (firstName.text.isEmpty ||
        lastName.text.isEmpty ||
        email.text.isEmpty ||
        password.text.isEmpty ||
        phoneNumber.text.isEmpty) {
      _showSnackBar(
        context,
        "Validation Error",
        "Please fill all fields",
        backgroundColor: Colors.orange[700],
      );
      return false;
    }

    // Email validation
    if (!email.text.contains('@')) {
      _showSnackBar(
        context,
        "Invalid Email",
        "Please enter a valid email",
        backgroundColor: Colors.orange[700],
      );
      return false;
    }

    // Password validation
    if (password.text.length < 6) {
      _showSnackBar(
        context,
        "Weak Password",
        "Password must be at least 6 characters",
        backgroundColor: Colors.orange[700],
      );
      return false;
    }

    // Phone number validation
    if (!RegExp(r'^\d{10}$').hasMatch(phoneNumber.text.trim())) {
      _showSnackBar(
        context,
        "Invalid Phone",
        "Phone number must be exactly 10 digits",
        backgroundColor: Colors.orange[700],
      );
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[300],
      appBar: AppBar(
        title: const Text(
          'Create Account',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo[300],
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            _showSnackBar(
              context,
              "Success",
              "Account created successfully",
              backgroundColor: Colors.green[700],
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const Homepage()),
            );
          } else if (state is AuthError) {
            _showSnackBar(
              context,
              "Signup Error",
              state.message,
              backgroundColor: Colors.redAccent[700],
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const Icon(Icons.person_add, size: 60, color: Colors.blue),
                      const SizedBox(height: 12),
                      const Text(
                        "Sign Up",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 24),

                      // First Name
                      TextField(
                        controller: firstName,
                        enabled: !isLoading,
                        decoration: InputDecoration(
                          labelText: "First Name",
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Last Name
                      TextField(
                        controller: lastName,
                        enabled: !isLoading,
                        decoration: InputDecoration(
                          labelText: "Last Name",
                          prefixIcon: const Icon(Icons.person_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Email
                      TextField(
                        controller: email,
                        enabled: !isLoading,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email",
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Password with toggle
                      TextField(
                        controller: password,
                        enabled: !isLoading,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: "Password",
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: togglePasswordVisibility,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Phone number
                      TextField(
                        controller: phoneNumber,
                        enabled: !isLoading,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: "Phone Number",
                          prefixIcon: const Icon(Icons.phone),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Signup Button or Loader
                      ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                if (validateInputs(context)) {
                                  context.read<AuthBloc>().add(
                                        SignupRequested(
                                          firstName: firstName.text.trim(),
                                          lastName: lastName.text.trim(),
                                          email: email.text.trim(),
                                          password: password.text.trim(),
                                          phone: phoneNumber.text.trim(),
                                        ),
                                      );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: Colors.indigo[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                "Create Account",
                                style: TextStyle(fontSize: 16, color: Colors.black),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}