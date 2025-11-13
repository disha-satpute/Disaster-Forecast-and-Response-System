import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart'; // ✅ Added for calling feature
import 'response_dashboard.dart';
import 'dashboard_page.dart'; // ✅ NEW
import './services/risk_services.dart';
import './services/weather_services.dart';

class DisasterAwarePage extends StatelessWidget {
  const DisasterAwarePage({super.key});

  final Color bgPink = const Color(0xFFFDEDED); // soft pink
  final Color cardWhite = Colors.white;
  final Color primaryRed = Colors.redAccent;

  // ✅ Call launcher function
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

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

            // ✅ Emergency Call Services Section
            const SizedBox(height: 20),
            const Text(
              'Emergency Call Services',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildCard(
              child: Column(
                children: [
                  _buildEmergencyRow('Fire Brigade', '101', Colors.redAccent),
                  const SizedBox(height: 8),
                  _buildEmergencyRow('Police Control Room', '100', Colors.blueAccent),
                  const SizedBox(height: 8),
                  _buildEmergencyRow('Ambulance Service', '108', Colors.green),
                  const SizedBox(height: 8),
                  _buildEmergencyRow('Disaster Management Helpline', '1078', Colors.deepOrangeAccent),
                  const SizedBox(height: 8),
                  _buildEmergencyRow('National Emergency Number', '112', Colors.purpleAccent),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Real-Time Data & Predictions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
           // 🌍 Real-Time Data & Predictions (Dynamic)
_buildCard(
  child: FutureBuilder<Map<String, dynamic>>(
    future: WeatherService().getCurrentWeather(18.5204, 73.8567), // Pune example
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const Center(child: CircularProgressIndicator(color: Colors.red));
      }

      final weather = snapshot.data!;
      final riskService = RiskService();
      final riskData = riskService.getRiskAnalysis(weather);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Real-Time AI Risk Prediction',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 240,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 28),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) {
                        final labels = riskData.keys.toList();
                        if (value < 0 || value >= labels.length) return const SizedBox();
                        return Text(labels[value.toInt()],
                            style: const TextStyle(fontSize: 10));
                      },
                    ),
                  ),
                ),
                barGroups: List.generate(riskData.length, (i) {
                  final label = riskData.keys.elementAt(i);
                  final val = riskData[label]!;
                  final color = riskService.getRiskColor(val);
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: val,
                        color: color,
                        width: 18,
                        gradient: LinearGradient(colors: [
                          color.withOpacity(0.7),
                          color,
                        ]),
                        borderRadius: BorderRadius.circular(4),
                      )
                    ],
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Data updated using live weather feed (Temperature, Wind, Humidity)",
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      );
    },
  ),
),


            const Text(
              'Risk Zones',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
           // 🗺️ Dynamic Risk Zones Map
_buildCard(
  child: SizedBox(
    height: 250,
    child: FutureBuilder<Map<String, dynamic>>(
      future: WeatherService().getCurrentWeather(18.5204, 73.8567),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator(color: Colors.red));
        }

        final weather = snapshot.data!;
        final riskService = RiskService();
        final riskData = riskService.getRiskAnalysis(weather);

        // Define sample locations (these could be dynamic later)
        final List<Map<String, dynamic>> zones = [
          {"lat": 18.5204, "lon": 73.8567, "label": "Pune"},
          {"lat": 19.0760, "lon": 72.8777, "label": "Mumbai"},
          {"lat": 17.6868, "lon": 83.2185, "label": "Vizag"},
        ];

        Set<Marker> markers = {};
        for (var zone in zones) {
          double randomFactor = Random().nextDouble() * 100;
          Color color = riskService.getRiskColor(randomFactor);
          markers.add(
            Marker(
              markerId: MarkerId(zone["label"]),
              position: LatLng(zone["lat"], zone["lon"]),
              infoWindow: InfoWindow(
                title: zone["label"],
                snippet: "Risk: ${randomFactor.toStringAsFixed(1)}%",
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                color == Colors.redAccent
                    ? BitmapDescriptor.hueRed
                    : color == Colors.orangeAccent
                        ? BitmapDescriptor.hueOrange
                        : color == Colors.amber
                            ? BitmapDescriptor.hueYellow
                            : BitmapDescriptor.hueGreen,
              ),
            ),
          );
        }

        return GoogleMap(
          initialCameraPosition: CameraPosition(
            target: const LatLng(18.5204, 73.8567),
            zoom: 5.5,
          ),
          markers: markers,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
        );
      },
    ),
  ),
),

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

  // --- Helper Widgets ---
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

  // ✅ Emergency Contact Row Widget
  Widget _buildEmergencyRow(String name, String number, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text("Phone: $number", style: const TextStyle(color: Colors.black54)),
            ],
          ),
          ElevatedButton(
            onPressed: () => _makePhoneCall(number),
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("Call"),
          ),
        ],
      ),
    );
  }
}
