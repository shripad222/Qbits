import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  static const String BACKEND_URL = 'http://10.79.215.218:3000';
  static const String MOBILE_KEY = 'user_mobile';

  // Save mobile number to local storage
  Future<void> saveMobileNumber(String mobileNo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(MOBILE_KEY, mobileNo);
  }

  // Get saved mobile number
  Future<String?> getSavedMobileNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(MOBILE_KEY);
  }

  // Clear saved data (logout)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(MOBILE_KEY);
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final mobile = await getSavedMobileNumber();
    return mobile != null && mobile.isNotEmpty;
  }

  // Login
  Future<Map<String, dynamic>> login(String mobileNo, String password) async {
    final response = await http.post(
      Uri.parse('$BACKEND_URL/api/auth/login-donor'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'mobile_no': mobileNo,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['success']) {
      await saveMobileNumber(mobileNo);
      return data;
    } else {
      throw Exception(data['error'] ?? 'Login failed');
    }
  }

  // Get donor data by mobile number
  Future<Map<String, dynamic>> getDonorData(String mobileNo) async {
    final response = await http.get(
      Uri.parse('$BACKEND_URL/api/auth/get-donor/$mobileNo'),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['success']) {
      return data['donor'];
    } else {
      throw Exception(data['error'] ?? 'Failed to fetch donor data');
    }
  }

  // Get current logged in user data
  Future<Map<String, dynamic>?> getCurrentUser() async {
    final mobile = await getSavedMobileNumber();
    if (mobile == null) return null;

    try {
      return await getDonorData(mobile);
    } catch (e) {
      print('Error fetching current user: $e');
      return null;
    }
  }
}