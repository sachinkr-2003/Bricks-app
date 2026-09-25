import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Production Live API on Render
  // Do not use localhost or IP here anymore, this hits the real cloud backend.
  static const String baseUrl = 'https://bricks-backend-fk3q.onrender.com/api';

  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token'); // get JWT token
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // LOGIN API — App only (customer role)
  Future<Map<String, dynamic>> login(String phone, String pin) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login/app'), // ✅ App-specific login
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone, 'pin': pin}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Backend returns flat object: {_id, name, phone, role, token}
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        // Store full user object (minus token) for later use
        final userObj = Map<String, dynamic>.from(data)..remove('token');
        await prefs.setString('user', jsonEncode(userObj));
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Login failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Cannot connect to server: $e'};
    }
  }

  // GET DASHBOARD OUTLAY (To fetch live budget & snapshot)
  Future<Map<String, dynamic>> getDashboard() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(Uri.parse('$baseUrl/dashboard'), headers: headers);
      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {'success': false, 'message': 'Failed to load dashboard'};
      }
    } catch (e) {
       return {'success': false, 'message': 'Network error'};
    }
  }

  // GENERIC GET REQUEST
  Future<Map<String, dynamic>> getData(String endpoint) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(Uri.parse('$baseUrl$endpoint'), headers: headers);
      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {'success': false, 'message': 'Failed to load data'};
      }
    } catch (e) {
       return {'success': false, 'message': 'Network error'};
    }
  }

  // GENERIC POST REQUEST (For submitting updates, materials)
  Future<Map<String, dynamic>> postData(String endpoint, Map<String, dynamic> body) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: jsonEncode(body),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Error submitting data'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error'};
    }
  }

  // GENERIC PUT REQUEST (For updating profile)
  Future<Map<String, dynamic>> putData(String endpoint, Map<String, dynamic> body) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: jsonEncode(body),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Error updating data'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error'};
    }
  }

  // MULTER IMAGE UPLOAD
  Future<Map<String, dynamic>> uploadImages(List<String> filePaths) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token'); // get JWT token

      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/upload'));
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      for (var path in filePaths) {
        request.files.add(await http.MultipartFile.fromPath('images', path));
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'urls': data['urls']};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Error uploading image'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error during upload'};
    }
  }
}
