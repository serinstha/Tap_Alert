import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  final List<Map<String, String>> faqList = const [
    {
      'question': 'What is the Alert SOS app?',
      'answer':
          'The Alert SOS app is a personal safety tool that allows users to quickly send emergency alerts with their location to contacts or emergency services in case of danger or distress.',
    },
    {
      'question': 'How do I send an SOS alert?',
      'answer':
          'You can trigger an SOS alert by pressing and holding the SOS button on the home screen. This immediately sends your live location and a help message to your emergency contacts.',
    },
    {
      'question': 'Who receives my SOS alert?',
      'answer':
          'Your predefined emergency contacts (e.g., family, friends, or coworkers) will receive a message with your current location and alert status. If enabled, local emergency services may also be notified.',
    },
    {
      'question': 'Can I customize my emergency contacts?',
      'answer':
          'Yes. Go to Contact button → Emergency Contacts to add, remove, or update contacts who will receive your SOS alerts.',
    },
    {
      'question': 'Does the app work without an internet connection?',
      'answer':
          'If you lose your internet connection, the app will attempt to send the alert via SMS (if you’ve granted SMS permissions). However, location accuracy may be reduced.',
    },
    {
      'question': 'Is my location shared all the time?',
      'answer':
          'No. Your location is shared only when you trigger an SOS alert or enable live tracking manually.',
    },
    {
      'question': 'Is my data secure?',
      'answer':
          'Absolutely. All data, including your location and contact details, are encrypted and never shared with third parties without your consent.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQ - Alert SOS App'),
        centerTitle: true,
        backgroundColor: Colors.indigo[300],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: faqList.length,
        itemBuilder: (context, index) {
          final faq = faqList[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ExpansionTile(
              title: Text(
                faq['question']!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    faq['answer']!,
                    style: const TextStyle(color: Colors.black87),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
