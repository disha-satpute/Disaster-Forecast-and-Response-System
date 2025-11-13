import 'package:flutter/material.dart';

class ResponseDashboard extends StatefulWidget {
  const ResponseDashboard({super.key});

  @override
  State<ResponseDashboard> createState() => _ResponseDashboardState();
}

class _ResponseDashboardState extends State<ResponseDashboard> {
  final TextEditingController teamNameController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  double readiness = 0.6;
  bool communicationActive = true;
  String selectedVehicle = "Ambulance";

  final List<String> vehicles = ["Ambulance", "Jeep", "Truck", "Bike"];
  final Map<String, bool> supplies = {
    "First Aid": true,
    "Oxygen": false,
    "Stretchers": true,
    "Masks": false,
    "IV Fluids": false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE4E1),
      appBar: AppBar(
        title: const Text(
          "Response Dashboard",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFD32F2F),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCard(
            title: "Team Identity",
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField("Team Name", teamNameController),
                const SizedBox(height: 8),
                const Text("Team Size: 5", style: TextStyle(color: Colors.black)),
              ],
            ),
          ),

          _buildCard(
            title: "Readiness Meter",
            child: Center(
              child: SizedBox(
                height: 120,
                width: 120,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: readiness,
                      strokeWidth: 10,
                      backgroundColor: Colors.white,
                      color: const Color(0xFFD32F2F),
                    ),
                    Text(
                      "${(readiness * 100).toInt()}%",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          _buildCard(
            title: "Vehicle Deployment",
            child: Wrap(
              spacing: 8,
              children: vehicles.map((v) {
                final selected = v == selectedVehicle;
                return ChoiceChip(
                  label: Text(v),
                  selected: selected,
                  onSelected: (_) => setState(() => selectedVehicle = v),
                  selectedColor: const Color(0xFFD32F2F),
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : Colors.black,
                  ),
                );
              }).toList(),
            ),
          ),

          _buildCard(
            title: "Medical Supplies",
            child: Wrap(
              spacing: 8,
              children: supplies.keys.map((item) {
                return FilterChip(
                  label: Text(item),
                  selected: supplies[item]!,
                  onSelected: (val) => setState(() => supplies[item] = val),
                  selectedColor: const Color(0xFFD32F2F),
                  labelStyle: TextStyle(
                    color: supplies[item]! ? Colors.white : Colors.black,
                  ),
                );
              }).toList(),
            ),
          ),

          _buildCard(
            title: "Communication Channel",
            child: SwitchListTile(
              title: const Text("Radio/Mobile Network Active"),
              value: communicationActive,
              onChanged: (val) => setState(() => communicationActive = val),
              activeColor: const Color(0xFFD32F2F),
            ),
          ),

          _buildCard(
            title: "Response Notes",
            child: _buildTextField("Add Notes", notesController, maxLines: 3),
          ),

          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Response details saved successfully!")),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD32F2F),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Save Response",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper Widgets ---
  Widget _buildCard({required String title, required Widget child}) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: const OutlineInputBorder(),
      ),
      style: const TextStyle(color: Colors.black),
    );
  }
}
