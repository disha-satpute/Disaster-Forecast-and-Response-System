import 'dart:math';
import 'package:flutter/material.dart';

class RiskService {
  // Simulate analysis based on live weather data
  Map<String, dynamic> getRiskAnalysis(Map<String, dynamic> weatherData) {
    double temp = weatherData['main']['temp'] ?? 0;
    double wind = weatherData['wind']['speed'] ?? 0;
    double humidity = weatherData['main']['humidity'] ?? 0;

    // AI-based simulated scores (0-100)
    double floodRisk = (humidity / 1.2 + wind / 2).clamp(0, 100);
    double cycloneRisk = (wind * 2 + temp / 3).clamp(0, 100);
    double heatwaveRisk = (temp * 2 - humidity / 3).clamp(0, 100);
    double fireRisk = (temp * 1.5 - humidity / 2).clamp(0, 100);
    double landslideRisk = (humidity / 2 + wind / 3).clamp(0, 100);

    return {
      "Flood": floodRisk,
      "Cyclone": cycloneRisk,
      "Heatwave": heatwaveRisk,
      "Fire": fireRisk,
      "Landslide": landslideRisk,
    };
  }

  // Color coding based on intensity
  Color getRiskColor(double value) {
    if (value > 75) return Colors.redAccent;
    if (value > 50) return Colors.orangeAccent;
    if (value > 25) return Colors.amber;
    return Colors.green;
  }
}
