import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl =  "http://192.168.1.7:5000"; // Your PC IP

  // ✅ Save Profile API
  Future<Map<String, dynamic>> saveProfile({
    required int userId,
    required String phone,
    required String address,
    required String region,
  }) async {
    try {
      final url = Uri.parse("$baseUrl/api/profile");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": userId,
          "phone": phone,
          "address": address,
          "region": region,
        }),
      );

      if (response.statusCode == 201) {
        return {"success": true, "message": "Profile saved successfully"};
      } else {
        final error = jsonDecode(response.body);
        return {"success": false, "message": error["message"] ?? "Failed"};
      }
    } catch (e) {
      return {"success": false, "message": "Error: $e"};
    }
  }

  // ✅ Existing Reports API
  Future<void> fetchDisasterReports() async {
    try {
      final url = Uri.parse("$baseUrl/api/reports");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Reports: $data");
      } else {
        print("❌ Server Error: ${response.statusCode}");
      }
    } catch (e) {
      print("⚠️ Connection Error: $e");
    }
  }
}
