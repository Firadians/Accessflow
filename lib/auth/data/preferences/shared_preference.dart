import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  // Function to save the user in SharedPreferences
  Future<void> saveUserToSharedPreferences(String owner) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('owner', owner);
  }

// Function to get the user from SharedPreferences
  Future<String?> getUserFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('owner');
  }

  // Function to remove user from SharedPreferences
  Future<void> removeUserFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('owner');
  }

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

  // Function to remove position from SharedPreferences
  Future<void> removePositionFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('position');
  }

  // Function to save the nik in SharedPreferences
  Future<void> saveNIKToSharedPreferences(String nikNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nik_number', nikNumber);
  }

// Function to get the nik from SharedPreferences
  Future<String?> getNIKFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('nik_number');
  }

  // Function to remove nik from SharedPreferences
  Future<void> removeNIKFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('nik_number');
  }
}
