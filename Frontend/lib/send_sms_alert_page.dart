import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SendSmsAlertPage extends StatefulWidget {
  const SendSmsAlertPage({super.key});

  @override
  State<SendSmsAlertPage> createState() => _SendSmsAlertPageState();
}

class _SendSmsAlertPageState extends State<SendSmsAlertPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _message = TextEditingController();
  final TextEditingController _shelterInfo = TextEditingController();
  String? selectedDisaster;
  bool _sending = false;

  Future<void> _sendSms() async {
    if (_formKey.currentState!.validate() && selectedDisaster != null) {
      setState(() => _sending = true);
      final response = await http.post(
        Uri.parse("http://10.0.2.2:5000/api/sms/send-sms"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "disasterType": selectedDisaster,
          "message": _message.text,
          "shelterInfo": _shelterInfo.text,
        }),
      );

      final data = jsonDecode(response.body);
      setState(() => _sending = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'] ?? 'Error')),
      );

      if (data['success'] == true) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE4E1),
      appBar: AppBar(
        title: const Text("Send SMS Alert"),
        backgroundColor: const Color(0xFFD32F2F),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Disaster Type",
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: [
                  "Flood",
                  "Earthquake",
                  "Fire",
                  "Cyclone",
                  "Landslide",
                  "Tsunami"
                ]
                    .map((type) =>
                        DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
                onChanged: (value) => setState(() => selectedDisaster = value),
                validator: (value) =>
                    value == null ? 'Select a disaster type' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _message,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: "Alert Message (SMS Text)",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Enter message text" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _shelterInfo,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: "Nearest Shelter Info",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _sending ? null : _sendSms,
                icon: _sending
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Icon(Icons.send),
                label: Text(_sending ? "Sending..." : "Send SMS Alert"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD32F2F),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
