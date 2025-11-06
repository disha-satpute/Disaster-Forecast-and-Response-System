import 'package:flutter/material.dart';

class DisasterAlertsAdvancedForm extends StatefulWidget {
  const DisasterAlertsAdvancedForm({super.key});

  @override
  State<DisasterAlertsAdvancedForm> createState() =>
      _DisasterAlertsAdvancedFormState();
}

class _DisasterAlertsAdvancedFormState
    extends State<DisasterAlertsAdvancedForm> {
  final _formKey = GlobalKey<FormState>();
  bool _submitted = false;

  // Controllers
  final TextEditingController locationController = TextEditingController();
  final TextEditingController emergencyContactController =
      TextEditingController();

  // Dropdown
  String? selectedDisaster;

  // Radio
  String? drillStatus;

  // Slider
  double responseTeamLevel = 5;

  // Switch
  bool evacuationNeeded = false;

  // Checklist
  final Map<String, bool> kitItems = {
    "First Aid Kit": false,
    "Flashlight": false,
    "Water Bottles": false,
    "Food Supplies": false,
    "Power Bank": false,
  };

  void _submitForm() {
    if (_formKey.currentState!.validate() &&
        selectedDisaster != null &&
        drillStatus != null) {
      setState(() {
        _submitted = true;
      });
    }
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType type = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: const OutlineInputBorder(),
        ),
        style: const TextStyle(color: Colors.black),
        validator: (value) =>
            value == null || value.isEmpty ? 'Required' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE4E1),
      appBar: AppBar(
        title: const Text("Disaster Alerts"),
        backgroundColor: const Color(0xFFD32F2F),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField("Location (City/Village)", locationController),
              _buildTextField(
                "Emergency Contact",
                emergencyContactController,
                type: TextInputType.phone,
              ),

              // Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Disaster Type",
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: ["Flood", "Earthquake", "Fire", "Cyclone", "Landslide"]
                    .map(
                      (type) =>
                          DropdownMenuItem(value: type, child: Text(type)),
                    )
                    .toList(),
                onChanged: (value) => setState(() => selectedDisaster = value),
                validator: (value) =>
                    value == null ? 'Select a disaster type' : null,
              ),

              const SizedBox(height: 16),

              // Radio buttons
              const Text(
                "Did you participate in the last drill?",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              RadioListTile<String>(
                title: const Text("Yes"),
                value: "Yes",
                groupValue: drillStatus,
                onChanged: (value) => setState(() => drillStatus = value),
              ),
              RadioListTile<String>(
                title: const Text("No"),
                value: "No",
                groupValue: drillStatus,
                onChanged: (value) => setState(() => drillStatus = value),
              ),

              const SizedBox(height: 16),

              // Slider
              Text("Response Team Readiness: ${responseTeamLevel.toInt()}"),
              Slider(
                value: responseTeamLevel,
                min: 0,
                max: 10,
                divisions: 10,
                label: responseTeamLevel.toInt().toString(),
                onChanged: (value) => setState(() => responseTeamLevel = value),
              ),

              const SizedBox(height: 16),

              // Switch
              SwitchListTile(
                title: const Text("Evacuation Transport Needed"),
                value: evacuationNeeded,
                onChanged: (value) => setState(() => evacuationNeeded = value),
              ),

              const SizedBox(height: 16),

              // Checklist
              const Text(
                "Emergency Kit Items",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...kitItems.keys.map((item) {
                return CheckboxListTile(
                  title: Text(item),
                  value: kitItems[item],
                  onChanged: (value) => setState(() => kitItems[item] = value!),
                );
              }),

              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD32F2F),
                  foregroundColor: Colors.white,
                ),
                child: const Text("Save Alerts"),
              ),

              if (_submitted)
                const Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Text(
                    "Alerts Saved Successfully",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
