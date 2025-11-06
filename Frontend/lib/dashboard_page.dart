import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_page.dart';
import 'reports_page.dart';
import 'manage_users_page.dart';
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
            const DashboardHome(),
            const ManageUsersPage(),
            const ReportsPage(),
            const SettingsPage(),
          ]
        : [
            const DashboardHome(),
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
                  BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
                  BottomNavigationBarItem(icon: Icon(Icons.people), label: "Users"),
                  BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Reports"),
                  BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
                ]
              : const [
                  BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
                  BottomNavigationBarItem(icon: Icon(Icons.report), label: "Reports"),
                  BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
                  BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
                ],
        ),
      ),
    );
  }
}

class DashboardHome extends StatelessWidget {
  const DashboardHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFEBEE),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 8),
            const Text(
              'AI-powered Emergency Updates',
              style: TextStyle(fontSize: 14, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // 🔔 Status Indicators
            Card(
              color: Colors.white,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Wrap(
                  spacing: 20,
                  runSpacing: 10,
                  children: const [
                    StatusTile(label: 'Alerts', value: '3'),
                    StatusTile(label: 'System', value: 'Active', color: Colors.green),
                    StatusTile(label: 'Reports', value: '5'),
                    StatusTile(label: 'Risk', value: 'Moderate', color: Colors.orange),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 🚨 Alerts
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Critical Alerts', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            const AlertCard(
              title: 'Cyclone approaching coast',
              severity: 'Extreme',
              location: 'Mumbai',
              time: '11:55 AM',
            ),
            const SizedBox(height: 8),
            const AlertCard(
              title: 'Flash Flood Warning',
              severity: 'High',
              location: 'Pune City',
              time: '12:55 PM',
            ),
            const SizedBox(height: 16),

            // 🌦 Weather & Risk
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Weather & Risk', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            Card(
              color: Colors.white,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Column(
                  children: const [
                    WeatherRow(label: 'Temperature', value: '34°C'),
                    WeatherRow(label: 'Wind Speed', value: '18 km/h'),
                    WeatherRow(label: 'Humidity', value: '42%'),
                    WeatherRow(label: 'Rainfall', value: '0.5 mm'),
                    WeatherRow(label: 'Condition', value: 'Cloudy'),
                    WeatherRow(label: 'Risk Level', value: 'High', color: Colors.red),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 📞 Emergency Contacts
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Emergency Services', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            const EmergencyServiceTile(name: 'Fire Brigade', phone: '101'),
            const EmergencyServiceTile(name: 'Police Control Room', phone: '100'),
            const EmergencyServiceTile(name: 'Disaster Helpline', phone: '108'),
            const SizedBox(height: 20),

            // 📊 Live Predictions (AI Simulation)
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Live Risk Predictions', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            Card(
              color: Colors.white,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(5, (index) {
                    return Column(
                      children: [
                        Container(
                          height: 40.0 + index * 15,
                          width: 20,
                          color: Colors.red[100 * (index + 1)],
                        ),
                        const SizedBox(height: 4),
                        Text('${index + 1}'),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 🔘 Status Tile
class StatusTile extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  const StatusTile({required this.label, required this.value, this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text('$label: $value'),
      backgroundColor: color ?? Colors.grey[200],
    );
  }
}

// 🌦 Weather Row
class WeatherRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  const WeatherRow({required this.label, required this.value, this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          Text(value, style: TextStyle(color: color ?? Colors.black)),
        ],
      ),
    );
  }
}

// 🚨 Alert Card
class AlertCard extends StatelessWidget {
  final String title;
  final String severity;
  final String location;
  final String time;
  const AlertCard({
    required this.title,
    required this.severity,
    required this.location,
    required this.time,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.warning, color: Color(0xFFEF5350)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Critical Alert',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 4),
            Text('Severity: $severity'),
            Text('Location: $location'),
            Text('Time: $time'),
          ],
        ),
      ),
    );
  }
}

// 📞 Emergency Service Tile
class EmergencyServiceTile extends StatelessWidget {
  final String name;
  final String phone;
  const EmergencyServiceTile({required this.name, required this.phone, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      child: ListTile(
        title: Text(name),
        subtitle: Text('Phone: $phone'),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF5350)),
          onPressed: () {},
          child: const Text('Call'),
        ),
      ),
    );
  }
}
