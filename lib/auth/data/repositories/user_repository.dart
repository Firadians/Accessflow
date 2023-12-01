import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:accessflow/auth/domain/entities/user.dart';
import 'package:accessflow/utils/strings.dart';
import 'package:accessflow/auth/data/preferences/shared_preference.dart';

class UserRepository {
  //Link URL
  static const baseUrl = ApiEndpoints.baseUrl;
  final SharedPreference sharedPreference = SharedPreference();

  //POST Method
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
      return User.fromJson(data);
    } else {
      throw Exception('Failed to create user');
    }
  }

  //Check if Login Session Token is equal to Token saved in database in case current account is logged in other device
  Future<int> checkLoginAccess(String? name) async {
    String? token =
        (await sharedPreference.getTokenFromSharedPreferences()) ?? '';
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': token,
    };

    final response = await http.get(
      Uri.parse('$baseUrl/api/users'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final int cardDataList = data['status'];
      return cardDataList;
    } else {
      throw Exception('Failed to create user');
    }
  }
}
