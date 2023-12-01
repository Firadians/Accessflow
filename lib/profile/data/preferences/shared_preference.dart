import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  // Function to save the token in SharedPreferences
  Future<void> saveTokenToSharedPreferences(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('remember_token', token);
  }

// Function to get the token from SharedPreferences
  Future<String?> getTokenFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('remember_token');
  }

  // Function to remove "remember_token" from SharedPreferences
  Future<void> removeTokenFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('remember_token');
  }

  // Function to save the position in SharedPreferences
  Future<void> savePositionToSharedPreferences(String position) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('position', position);
  }

// Function to get the position from SharedPreferences
  Future<String?> getPositionFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('position');
  }

  // Function to remove "position" from SharedPreferences
  Future<void> removePositionFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('position');
  }
}
