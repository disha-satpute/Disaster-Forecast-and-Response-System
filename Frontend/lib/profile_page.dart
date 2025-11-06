import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'config.dart';
import 'login_page.dart'; // for navigation after delete/logout

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController regionController = TextEditingController();
  final TextEditingController emergencyContactController = TextEditingController();

  bool isLoading = false;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    setState(() => isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      if (token == null) {
        _showSnack("⚠️ Not logged in");
        return;
      }

      final response = await http.get(
        Uri.parse("${AppConfig.baseUrl}/api/profile/me"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = data["user"];

        setState(() {
          nameController.text = user["name"] ?? "";
          emailController.text = user["email"] ?? "";
          phoneController.text = user["phone"] ?? "";
          regionController.text = user["region"] ?? "";
          locationController.text = user["location"] ?? "";
          emergencyContactController.text = user["emergency_contact"] ?? "";
        });
      } else {
        _showSnack("❌ Failed to load profile");
        debugPrint("Fetch profile error: ${response.body}");
      }
    } catch (e) {
      _showSnack("⚠️ Error fetching profile: $e");
      debugPrint("Profile fetch error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      if (token == null) {
        _showSnack("⚠️ Not logged in");
        return;
      }

      final response = await http.put(
        Uri.parse("${AppConfig.baseUrl}/api/profile/update"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          "phone": phoneController.text.trim(),
          "location": locationController.text.trim(),
          "region": regionController.text.trim(),
          "emergency_contact": emergencyContactController.text.trim(),
        }),
      );

      if (response.statusCode == 200) {
        _showSnack("✅ Profile updated successfully!");
        setState(() => isEditing = false);
      } else {
        _showSnack("❌ Update failed: ${response.body}");
      }
    } catch (e) {
      _showSnack("⚠️ Error updating profile: $e");
      debugPrint("Update error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> deleteProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null) {
      _showSnack("⚠️ Not logged in");
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Profile"),
        content: const Text(
          "Are you sure you want to permanently delete your profile? This action cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final response = await http.delete(
        Uri.parse("${AppConfig.baseUrl}/api/profile/delete"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );

      if (response.statusCode == 200) {
        _showSnack("✅ Profile deleted successfully");
        await prefs.clear();

        // Navigate back to login
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );
      } else {
        _showSnack("❌ Delete failed: ${response.body}");
      }
    } catch (e) {
      _showSnack("⚠️ Error deleting profile: $e");
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final primaryRed = Colors.redAccent;
    final bgPink = const Color(0xFFFDECEC);

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: primaryRed,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.lock : Icons.edit),
            onPressed: () => setState(() => isEditing = !isEditing),
          )
        ],
      ),
      body: Container(
        color: bgPink,
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.redAccent))
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    const SizedBox(height: 10),
                    _buildTextField("Full Name", nameController, false),
                    _buildTextField("Email", emailController, false),
                    _buildTextField("Phone Number", phoneController, isEditing),
                    _buildTextField("Location", locationController, isEditing),
                    _buildTextField("Region", regionController, isEditing),
                    _buildTextField("Emergency Contact", emergencyContactController, isEditing),

                    const SizedBox(height: 25),
                    if (isEditing)
                      ElevatedButton.icon(
                        onPressed: isLoading ? null : updateProfile,
                        icon: const Icon(Icons.save),
                        label: const Text("Save Changes"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryRed,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: deleteProfile,
                      icon: const Icon(Icons.delete_forever),
                      label: const Text("Delete Profile"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[850],
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, bool editable) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        readOnly: !editable,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: const OutlineInputBorder(),
        ),
        validator: (v) =>
            editable && (v == null || v.isEmpty) ? "Enter $label" : null,
      ),
    );
  }
}
