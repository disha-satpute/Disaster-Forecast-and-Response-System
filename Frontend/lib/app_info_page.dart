import 'package:flutter/material.dart';
import 'login_page.dart';

class AppInfoPage extends StatelessWidget {
  const AppInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDECEC),
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text("About DisasterForecast"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.public, size: 100, color: Colors.red),
            const SizedBox(height: 20),
            const Text(
              "Empowering disaster awareness & rapid response.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            const Text(
              "This application integrates real-time alerts, AI-powered prediction models, "
              "and regional data to ensure safety during emergencies.\n\n"
              "Features:\n"
              "• Real-time disaster alerts\n"
              "• Emergency contacts\n"
              "• Response dashboard\n"
              "• Preparedness missions\n"
              "• Weather and location tracking\n",
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              ),
              child: const Text("Continue to Login"),
            ),
          ],
        ),
      ),
    );
  }
}
