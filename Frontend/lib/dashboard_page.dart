import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'disaster_alerts_advanced_form.dart';
import 'send_sms_alert_page.dart';
import 'profile_page.dart';
import 'manage_users_page.dart';
import 'reports_page.dart';
import 'settings_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  String? role;
  String? userName;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      role = prefs.getString("role") ?? "user";
      userName = prefs.getString("user_name") ?? "User";
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = role == "admin"
        ? [
            DashboardHome(role: role ?? "user"),
            const ManageUsersPage(),
            const ReportsPage(),
            const SettingsPage(),
          ]
        : [
            DashboardHome(role: role ?? "user"),
            const ReportsPage(),
            const ProfilePage(),
            const SettingsPage(),
          ];

    return WillPopScope(
      onWillPop: () async {
        if (_selectedIndex != 0) {
          setState(() => _selectedIndex = 0);
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFFEBEE),
        appBar: AppBar(
          backgroundColor: const Color(0xFFEF5350),
          title: Text('Welcome, ${userName ?? "User"}'),
          centerTitle: true,
        ),
        body: pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xFFEF5350),
          unselectedItemColor: Colors.grey,
          onTap: (index) => setState(() => _selectedIndex = index),
          items: role == "admin"
              ? const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.dashboard), label: "Dashboard"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.people), label: "Users"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.bar_chart), label: "Reports"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.settings), label: "Settings"),
                ]
              : const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.dashboard), label: "Dashboard"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.report), label: "Reports"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.person), label: "Profile"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.settings), label: "Settings"),
                ],
        ),
      ),
    );
  }
}

class DashboardHome extends StatefulWidget {
  final String role;
  const DashboardHome({super.key, required this.role});

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome> {
  List alerts = [];

  Future<void> fetchAlerts() async {
    final response =
        await http.get(Uri.parse("http://10.0.2.2:5000/api/alerts/get-alerts"));
    if (response.statusCode == 200) {
      setState(() {
        alerts = json.decode(response.body);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAlerts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFEBEE),
  floatingActionButton: widget.role == "admin"
    ? Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "addAlert",
            backgroundColor: Colors.red,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const DisasterAlertsAdvancedForm(),
                ),
              ).then((_) => fetchAlerts());
            },
            child: const Icon(Icons.add_alert),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: "sendSms",
            backgroundColor: Colors.blueAccent,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SendSmsAlertPage(),
                ),
              );
            },
            child: const Icon(Icons.sms),
          ),
        ],
      )
    : null,


      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'AI-powered Emergency Updates',
              style: TextStyle(fontSize: 14, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // 🔔 Real-time alerts
            const Text('Critical Alerts',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            alerts.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: alerts.map((alert) {
                      return Card(
                        color: Colors.white,
                        elevation: 3,
                        child: ListTile(
                          leading:
                              const Icon(Icons.warning, color: Colors.redAccent),
                          title: Text(
                            alert['disaster_type'] ?? 'Unknown Disaster',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: Text(
                            "📍 Location: ${alert['location']}\n"
                            "📞 Contact: ${alert['emergency_contact']}\n"
                            "🚍 Evacuation: ${alert['evacuation_needed'] ? "Yes" : "No"}\n"
                            "🧰 Kit Items: ${alert['kit_items']}\n"
                            "🕒 Reported: ${alert['timestamp']?.toString().substring(0, 19)}",
                          ),
                          trailing: Text(alert['status'] ?? ''),
                        ),
                      );
                    }).toList(),
                  ),
          ],
        ),
      ),
    );
  }
}
