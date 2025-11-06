import 'package:flutter/material.dart';
import 'signup_page.dart';
import 'home_page.dart';
import 'real_time_plan_page.dart';
import 'app_info_page.dart'; // ✅ new app info page
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const DisasterForecastApp());
}

class DisasterForecastApp extends StatelessWidget {
  const DisasterForecastApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DisasterForecast',
      theme: ThemeData(primarySwatch: Colors.red),
      home: const WelcomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  Future<void> testBackendConnection(BuildContext context) async {
    const String url = "http://10.31.253.239:5000/api/reports";
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("✅ Connected! ${data.length} reports fetched.")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("⚠️ Server error: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Connection failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        color: const Color(0xFFFDECEC),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.shield, color: Colors.red, size: 30),
                    SizedBox(width: 10),
                    Text(
                      'Welcome',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                Center(
                  child: Image.asset(
                    'assets/home.png',
                    height: screenWidth * 0.6,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.image_not_supported,
                      size: 80,
                      color: Colors.grey,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Center(
                  child: Text(
                    'DisasterForecast',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),

                const Center(
                  child: Text(
                    'Stay prepared with AI insights & emergency tools',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ),

                const SizedBox(height: 30),

                Center(
                  child: ElevatedButton.icon(
                    onPressed: () => testBackendConnection(context),
                    icon: const Icon(Icons.cloud_done),
                    label: const Text("Test Backend Connection"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RealTimePlanPage()),
                      );
                    },
                    icon: const Icon(Icons.upgrade),
                    label: const Text('UPGRADE PLAN'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                    ),
                  ),
                ),

                const Spacer(),

                Row(
                  children: [
                    // 🟢 Updated Get Started button (now goes to AppInfoPage)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AppInfoPage()),
                          );
                        },
                        icon: const Icon(Icons.info_outline),
                        label: const Text('Get Started'),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          foregroundColor: Colors.red,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // 🔴 Create account button stays same
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SignupPage()),
                          );
                        },
                        icon: const Icon(Icons.person_add),
                        label: const Text('Create Account'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
