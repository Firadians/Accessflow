import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:accessflow/home/domain/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:accessflow/utils/strings.dart';

class UserRepository {
  static const baseUrl = ApiEndpoints.baseUrl;

  Future<User> signIn(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'ktp': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      // Save the token to SharedPreferences
      return User.fromJson(data);
    } else {
      throw Exception('Failed to create user');
    }
  }

  Future<void> saveTokenToSharedPreferences(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('auth_token', token);
  }
}
