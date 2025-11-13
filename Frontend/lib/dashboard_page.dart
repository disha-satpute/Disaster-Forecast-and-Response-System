import 'package:flutter/material.dart';
import './services/weather_services.dart';
import '../widget/live_predictions.dart'; // ✅ correct folder path

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Map<String, dynamic>? weatherData;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    try {
      // Example: Pune Coordinates
      double lat = 18.5204;
      double lon = 73.8567;

      WeatherService service = WeatherService();
      weatherData = await service.getCurrentWeather(lat, lon);

      setState(() => loading = false);
    } catch (e) {
      print("Weather Error: $e");
      setState(() => loading = false);
    }
  }

  // 🌡 AI-style dynamic risk prediction (safe)
  String getRiskLevel() {
    if (weatherData == null ||
        weatherData!['main'] == null ||
        weatherData!['wind'] == null) {
      return "Loading...";
    }

    try {
      double temp = weatherData!['main']['temp'].toDouble();
      double wind = weatherData!['wind']['speed'].toDouble();
      int humidity = weatherData!['main']['humidity'].toInt();

      if (wind > 40 || humidity > 90) return "Severe";
      if (wind > 25 || humidity > 70) return "High";
      if (temp > 37) return "Moderate";
      return "Low";
    } catch (e) {
      print("Error calculating risk: $e");
      return "Unknown";
    }
  }

  Color riskColor(String risk) {
    switch (risk) {
      case "Severe":
        return Colors.red;
      case "High":
        return Colors.orange;
      case "Moderate":
        return Colors.amber;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFEBEE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEF5350),
        title: const Text('Disaster Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchWeather, // 🔁 refresh weather data
            tooltip: 'Refresh Weather',
          )
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator(color: Colors.red))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    'AI-powered emergency updates',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // 🔔 Status Indicators
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Wrap(
                        spacing: 20,
                        runSpacing: 10,
                        children: [
                          const StatusTile(label: 'Alerts', value: '2'),
                          const StatusTile(
                              label: 'System',
                              value: 'Active',
                              color: Colors.green),
                          const StatusTile(label: 'Services', value: 'Online'),
                          StatusTile(
                            label: 'Risk',
                            value: getRiskLevel(),
                            color: riskColor(getRiskLevel()),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 🌩 Critical Alerts
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Critical Alerts',
                        style: TextStyle(fontWeight: FontWeight.bold)),
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
                    location: 'Citywide',
                    time: '12:55 PM',
                  ),
                  const SizedBox(height: 16),

                  // 🌦 Weather & Risk (Real Data)
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Weather & Risk',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 8),

                  if (weatherData == null)
                    const Text("Loading weather data...")
                  else
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            WeatherRow(
                                label: 'Temperature',
                                value:
                                    "${weatherData!['main']['temp']}°C"),
                            WeatherRow(
                                label: 'Humidity',
                                value:
                                    "${weatherData!['main']['humidity']}%"),
                            WeatherRow(
                                label: 'Wind Speed',
                                value:
                                    "${weatherData!['wind']['speed']} km/h"),
                            WeatherRow(
                                label: 'Pressure',
                                value:
                                    "${weatherData!['main']['pressure']} hPa"),
                            WeatherRow(
                                label: 'Condition',
                                value: weatherData!['weather'][0]['main']),
                            WeatherRow(
                              label: 'Predicted Risk Level',
                              value: getRiskLevel(),
                              color: riskColor(getRiskLevel()),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),

                  // 📊 Live Predictions (Interactive)
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Live Predictions',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 8),
                  const LivePredictions(),
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
  const StatusTile(
      {required this.label, required this.value, this.color, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text('$label: $value',
          style:
              TextStyle(color: color != null ? Colors.white : Colors.black)),
      backgroundColor: color ?? Colors.grey[200],
    );
  }
}

// 🌦 Weather Row
class WeatherRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  const WeatherRow(
      {required this.label, required this.value, this.color, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
              child: Text(label,
                  style: const TextStyle(fontWeight: FontWeight.w500))),
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
  const AlertCard(
      {required this.title,
      required this.severity,
      required this.location,
      required this.time,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
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
                    child: Text('Critical Alert',
                        style: TextStyle(fontWeight: FontWeight.bold))),
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
