import 'package:flutter/material.dart';

class WarningPage extends StatefulWidget {
  const WarningPage({Key? key}) : super(key: key);

  @override
  State<WarningPage> createState() => _WarningPageState();
}

class _WarningPageState extends State<WarningPage> {
  String selectedDisaster = 'Cyclone';
  double severityLevel = 2;
  String selectedLocation = 'Auto Detect';

  final List<Map<String, dynamic>> disasterOptions = [
    {'label': 'Flood', 'icon': Icons.water},
    {'label': 'Fire', 'icon': Icons.local_fire_department},
    {'label': 'Earthquake', 'icon': Icons.public},
    {'label': 'Cyclone', 'icon': Icons.wind_power},
  ];

  final List<String> locationOptions = [
    'Auto Detect',
    'Mumbai',
    'Delhi',
    'Chennai',
  ];

  Color getSeverityColor() {
    switch (severityLevel.round()) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String getSeverityLabel() {
    switch (severityLevel.round()) {
      case 1:
        return 'Low';
      case 2:
        return 'Moderate';
      case 3:
        return 'High';
      default:
        return '';
    }
  }

  bool isFormValid() {
    return selectedDisaster.isNotEmpty && selectedLocation.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFEBEE), // Soft pink tint
      appBar: AppBar(
        backgroundColor: const Color(0xFFD32F2F), // Red
        title: const Text('Warning'), // Left-aligned heading
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              color: Colors.white,
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Disaster Type:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      children: disasterOptions.map((option) {
                        final isSelected = selectedDisaster == option['label'];
                        return ChoiceChip(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(option['icon'], size: 18),
                              const SizedBox(width: 4),
                              Text(option['label']),
                            ],
                          ),
                          selected: isSelected,
                          selectedColor: const Color(0xFFD32F2F),
                          onSelected: (_) => setState(
                            () => selectedDisaster = option['label'],
                          ),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              color: Colors.white,
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Severity Level:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Slider(
                      value: severityLevel,
                      min: 1,
                      max: 3,
                      divisions: 2,
                      label: getSeverityLabel(),
                      activeColor: getSeverityColor(),
                      onChanged: (value) =>
                          setState(() => severityLevel = value),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              color: Colors.white,
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Location:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    DropdownButton<String>(
                      value: selectedLocation,
                      isExpanded: true,
                      items: locationOptions.map((loc) {
                        return DropdownMenuItem(value: loc, child: Text(loc));
                      }).toList(),
                      onChanged: (value) =>
                          setState(() => selectedLocation = value!),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: Colors.white,
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.warning, color: Color(0xFFD32F2F)),
                title: Text('⚠ $selectedDisaster Warning'),
                subtitle: Text(
                  'Severity: ${getSeverityLabel()} • Location: $selectedLocation',
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isFormValid()
                      ? const Color(0xFFD32F2F)
                      : Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: isFormValid()
                    ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Warning saved successfully'),
                          ),
                        );
                      }
                    : null,
                child: const Text(
                  'Save Warning',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ), // 🖤 Black font
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}