import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
        backgroundColor: Colors.indigo[300],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              "The SOS App is designed to enhance personal safety by providing a fast and reliable way to alert your loved ones during emergencies. Our mission is to empower users to feel secure, whether they are at home, traveling, or in unfamiliar surroundings.",
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 16),
            const Text(
              "With just a single tap, the app shares your real-time location via SMS with your emergency contacts, helping them respond quickly when you need assistance. Using OpenStreetMap, the SOS App ensures accurate location tracking without relying on proprietary map services.",
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 16),
            const Text(
              "We believe that safety should be accessible to everyone. That’s why our app focuses on simplicity, speed, and reliability, giving you peace of mind knowing that help is always just a tap away.",
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24),
            Text(
              "Our Vision:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "To create a world where everyone can feel safe and supported in times of emergency.",
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 16),
            Text(
              "Our Mission:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "To provide a simple, fast, and secure way to alert loved ones and emergency contacts in critical situations.",
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
