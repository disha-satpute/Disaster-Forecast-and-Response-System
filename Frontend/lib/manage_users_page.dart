import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'config.dart';

class ManageUsersPage extends StatefulWidget {
  const ManageUsersPage({super.key});

  @override
  State<ManageUsersPage> createState() => _ManageUsersPageState();
}

class _ManageUsersPageState extends State<ManageUsersPage> {
  List<dynamic> users = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    setState(() => isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      final response = await http.get(
        Uri.parse("${AppConfig.baseUrl}/api/admin/users"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() => users = data["users"]);
      } else {
        _showSnack("❌ Failed to load users: ${response.body}");
      }
    } catch (e) {
      _showSnack("⚠️ Error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> deleteUser(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete User"),
        content: const Text("Are you sure you want to delete this user?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancel")),
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
        Uri.parse("${AppConfig.baseUrl}/api/admin/user/$id"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        _showSnack("✅ User deleted");
        fetchUsers();
      } else {
        _showSnack("❌ Failed: ${response.body}");
      }
    } catch (e) {
      _showSnack("⚠️ Error: $e");
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDECEC),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.redAccent))
          : RefreshIndicator(
              onRefresh: fetchUsers,
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final u = users[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: ListTile(
                      title: Text(u["name"]),
                      subtitle: Text("${u["email"]} • ${u["role"]}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => deleteUser(u["id"]),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
