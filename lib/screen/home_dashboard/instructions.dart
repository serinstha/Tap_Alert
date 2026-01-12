import 'package:flutter/material.dart';

class InstructionsScreen extends StatelessWidget {
  const InstructionsScreen({super.key});

  final List<String> steps = const [
    "Add your emergency contacts under MENU -> ADD CONTACT",
    "Press the SOS Widget or the SOS Button on the homepage in case of an EMERGENCY. On pressing the button, an SOS message along with the link of your CURRENT LOCATION on Google Maps will be sent as an SMS to your added emergency contacts.",
    "We recommend you to always keep your GPS turned ON so that your device has enough information about your location in case of an emergency which in turn enables the app to fetch your location very quickly otherwise it may take few more seconds (not more than 10 sec).",
    "We recommend you to use SOS Alert Widget and always keep GPS turned ON so that you can send SOS Alert in just one tap. You can adjust the size of the widget as per your requirements.",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Instructions"),
        centerTitle: true,
        backgroundColor: Colors.indigo[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: steps.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.blue,
                          child: Text(
                            "${index + 1}",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            steps[index],
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
