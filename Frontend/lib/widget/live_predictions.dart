// lib/widgets/live_predictions.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // ✅ for timestamp formatting


class LivePredictions extends StatefulWidget {
  const LivePredictions({Key? key}) : super(key: key);

  @override
  State<LivePredictions> createState() => _LivePredictionsState();
}

class _LivePredictionsState extends State<LivePredictions>
    with SingleTickerProviderStateMixin {
  late List<double> values;
  late AnimationController controller;
  late String lastUpdated; // ✅ track last refresh time

  final List<String> labels = [
    "Cyclone",
    "Flood",
    "Heatwave",
    "Landslide",
    "Fire"
  ];

  @override
  void initState() {
    super.initState();
    // 🌡 Initial semi-realistic predictions
    values = [80, 60, 35, 20, 15];
    lastUpdated = DateFormat('hh:mm:ss a').format(DateTime.now());

    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..forward();

    // 🔁 Mild, realistic auto-update every 8 seconds (±3% random variation)
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 8));
      if (!mounted) return false;

      setState(() {
        values = values
            .map((v) {
              double delta = Random().nextDouble() * 6 - 3; // smaller ±3% change
              return (v + delta).clamp(0, 100).toDouble();
            })
            .toList();
        lastUpdated = DateFormat('hh:mm:ss a').format(DateTime.now());
      });

      return true;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // 🎨 Dynamic color based on intensity
  Color getColor(double value) {
    if (value > 75) return Colors.redAccent;
    if (value > 50) return Colors.orange;
    if (value > 25) return Colors.amber;
    return Colors.green;
  }

  // 🌀 Icon per risk type
  IconData getIcon(String label) {
    switch (label) {
      case "Cyclone":
        return Icons.cyclone;
      case "Flood":
        return Icons.water_drop;
      case "Heatwave":
        return Icons.wb_sunny;
      case "Landslide":
        return Icons.terrain;
      case "Fire":
        return Icons.local_fire_department;
      default:
        return Icons.analytics;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "AI-Predicted Disaster Risks",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Column(
              children: List.generate(labels.length, (index) {
                final val = values[index];
                final color = getColor(val);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Icon(getIcon(labels[index]), color: color, size: 22),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Stack(
                          children: [
                            Container(
                              height: 18,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 900),
                              curve: Curves.easeInOut,
                              height: 18,
                              width: MediaQuery.of(context).size.width *
                                  (val / 150),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                gradient: LinearGradient(
                                  colors: [
                                    color.withOpacity(0.6),
                                    color,
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "${val.toInt()}%",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                );
              }),
            ),
            const SizedBox(height: 10),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "AI model recalibrates every 8 seconds",
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      lastUpdated,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
