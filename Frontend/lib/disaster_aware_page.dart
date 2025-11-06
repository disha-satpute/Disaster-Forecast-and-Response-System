import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'response_dashboard.dart';
import 'dashboard_page.dart'; // ✅ NEW

class DisasterAwarePage extends StatelessWidget {
  const DisasterAwarePage({super.key});

  final Color bgPink = const Color(0xFFFDEDED); // soft pink
  final Color cardWhite = Colors.white;
  final Color primaryRed = Colors.redAccent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgPink,
      appBar: AppBar(
        title: const Text('DisasterAware'),
        backgroundColor: primaryRed,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'AI-Powered Forecasting',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Our AI algorithms provide accurate disaster predictions to help you stay prepared.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Upcoming Alerts',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildAlertRow('Tornado Warning', '2 hours left'),
                  _buildAlertRow('Flood Alert', '5 hours left'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DashboardPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryRed,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Forecast Dashboard'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ResponseDashboard(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: primaryRed, width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Response Actions'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            const Text(
              'Current Weather Conditions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWeatherRow(Icons.thermostat, 'Temperature: 28°C'),
                  _buildWeatherRow(Icons.water_drop, 'Humidity: 65%'),
                  _buildWeatherRow(Icons.air, 'Wind Speed: 16 km/h'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Real-Time Data & Predictions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildCard(
              child: SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true),
                      ),
                    ),
                    barGroups: [
                      BarChartGroupData(
                        x: 0,
                        barRods: [BarChartRodData(toY: 5, color: Colors.red)],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [BarChartRodData(toY: 3, color: Colors.blue)],
                      ),
                      BarChartGroupData(
                        x: 2,
                        barRods: [BarChartRodData(toY: 4, color: Colors.green)],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Risk Zones',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildCard(
              child: SizedBox(
                height: 200,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(18.5204, 73.8567), // Pune example
                    zoom: 10,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Preventive Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildBulletPoint('Stock up on essential supplies.'),
            _buildBulletPoint('Secure loose objects around your home.'),
            _buildBulletPoint('Stay informed through official channels.'),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // --- UI Helper Widgets ---
  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: child,
    );
  }

  static Widget _buildAlertRow(String title, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(time, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  static Widget _buildWeatherRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.redAccent),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }

  static Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text("• $text"),
    );
  }
}
