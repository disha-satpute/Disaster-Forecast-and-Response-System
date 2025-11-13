import 'package:flutter/material.dart';
import './services/weather_services.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final Color bgPink = const Color(0xFFFDECEC);
  final Color primaryRed = Colors.redAccent;

  Map<String, dynamic>? weatherData; 
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    try {
      // Pune Coordinates
      double lat = 18.5204;
      double lon = 73.8567;

      WeatherService service = WeatherService();
      weatherData = await service.getCurrentWeather(lat, lon);

      setState(() {
        loading = false;
      });
    } catch (e) {
      print("Weather Error: $e");
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgPink,
      appBar: AppBar(
        title: const Text('Weather Forecast'),
        backgroundColor: primaryRed,
        centerTitle: true,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator(color: Colors.redAccent))
          : weatherData == null
              ? const Center(child: Text("Failed to load weather"))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 20),
                      _buildCurrentWeather(),
                      const SizedBox(height: 20),
                      _buildForecast(),
                      const SizedBox(height: 20),
                      _buildAlerts(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Image.asset('assets/weather_banner1.png', height: 80),
        const SizedBox(width: 12),
        Text(
          "Pune, MH\n${weatherData!['main']['temp']}°C • ${weatherData!['weather'][0]['main']}",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildCurrentWeather() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _WeatherRow(
              icon: Icons.thermostat,
              label: 'Temperature',
              value: "${weatherData!['main']['temp']}°C",
            ),
            _WeatherRow(
              icon: Icons.water_drop,
              label: 'Humidity',
              value: "${weatherData!['main']['humidity']}%",
            ),
            _WeatherRow(
              icon: Icons.air,
              label: 'Wind Speed',
              value: "${weatherData!['wind']['speed']} km/h",
            ),
            _WeatherRow(
              icon: Icons.visibility,
              label: 'Visibility',
              value: "${(weatherData!['visibility'] / 1000).toStringAsFixed(1)} km",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForecast() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('3-Day Forecast', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        _ForecastTile(day: 'Thu', icon: Icons.wb_sunny, temp: '30°C / 22°C'),
        _ForecastTile(day: 'Fri', icon: Icons.cloud, temp: '28°C / 21°C'),
        _ForecastTile(day: 'Sat', icon: Icons.beach_access, temp: '26°C / 20°C'),
      ],
    );
  }

  Widget _buildAlerts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('Weather Alerts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Card(
          color: Colors.redAccent,
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              '⚠️ Heatwave Warning: Stay hydrated and avoid outdoor activities between 12–4 PM.',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

// Widgets remain same
class _WeatherRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _WeatherRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.redAccent),
          const SizedBox(width: 12),
          Expanded(child: Text(label)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _ForecastTile extends StatelessWidget {
  final String day;
  final IconData icon;
  final String temp;

  const _ForecastTile({required this.day, required this.icon, required this.temp});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.redAccent),
      title: Text(day),
      trailing: Text(temp),
    );
  }
}
