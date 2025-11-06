import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login_page.dart';
import 'config.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cpasswordController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController regionController = TextEditingController();
  final TextEditingController emergencyController = TextEditingController();
  final TextEditingController adminKeyController = TextEditingController();

  String? selectedRole = "user";
  bool isLoading = false;

  Future<void> registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    // Validate password match
    if (passwordController.text.trim() != cpasswordController.text.trim()) {
      _showSnack("Passwords do not match ❌");
      return;
    }

    // Validate admin key if admin role selected
    if (selectedRole == "admin" && adminKeyController.text.trim() != "welcome@789") {
      _showSnack("Invalid admin key ❌");
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse("${AppConfig.baseUrl}/api/auth/signup"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": nameController.text.trim(),
          "age": int.tryParse(ageController.text.trim()) ?? 0,
          "phone": phoneController.text.trim(),
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
          "location": locationController.text.trim(),
          "region": regionController.text.trim(),
          "emergency_contact": emergencyController.text.trim(),
          "role": selectedRole,
        }),
      );

      setState(() => isLoading = false);

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 && data["success"] == true) {
        _showSnack("✅ Account Created Successfully!");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      } else {
        _showSnack("❌ ${data["message"] ?? "Registration failed"}");
      }
    } catch (e) {
      setState(() => isLoading = false);
      _showSnack("⚠️ Network Error: $e");
    }
  }

  void _showSnack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    final Color bgPink = const Color(0xFFFDECEC);
    final Color primaryRed = Colors.redAccent;

    return Scaffold(
      backgroundColor: bgPink,
      appBar: AppBar(
        backgroundColor: primaryRed,
        title: const Text("Create Account"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildField("Full Name", nameController, TextInputType.text),
                _buildField("Age", ageController, TextInputType.number),
                _buildField("Phone", phoneController, TextInputType.phone),
                _buildField("Email", emailController, TextInputType.emailAddress),
                _buildField("Password", passwordController, TextInputType.visiblePassword, isPassword: true),
                _buildField("Confirm Password", cpasswordController, TextInputType.visiblePassword, isPassword: true),
                _buildField("Location (City/Village)", locationController, TextInputType.text),
                _buildField("Region", regionController, TextInputType.text),
                _buildField("Emergency Contact", emergencyController, TextInputType.phone),

                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  items: const [
                    DropdownMenuItem(value: "user", child: Text("User")),
                    DropdownMenuItem(value: "admin", child: Text("Admin")),
                  ],
                  onChanged: (value) => setState(() => selectedRole = value),
                  decoration: const InputDecoration(
                    labelText: "Select Role",
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),

                if (selectedRole == "admin") ...[
                  const SizedBox(height: 10),
                  _buildField("Admin Key", adminKeyController, TextInputType.text, isPassword: true),
                ],

                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : registerUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryRed,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Sign Up",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                  ),
                ),

                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  ),
                  child: const Text("Already have an account? Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, TextInputType type, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        obscureText: isPassword,
        validator: (value) => value == null || value.isEmpty ? "Enter $label" : null,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
