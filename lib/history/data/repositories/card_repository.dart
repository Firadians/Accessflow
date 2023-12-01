import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:accessflow/draft/domain/card_response.dart';
import 'package:accessflow/auth/data/preferences/shared_preference.dart';
import 'package:accessflow/utils/strings.dart';

class CardRepository {
  static const baseUrl = ApiEndpoints.baseUrl;
  final SharedPreference sharedPreference = SharedPreference();

  Future<List<CardResponse>> getSubmitCardData() async {
    String? owner =
        (await sharedPreference.getUserFromSharedPreferences()) ?? '';
    String? token =
        (await sharedPreference.getTokenFromSharedPreferences()) ?? '';

    final response = await http.get(
      Uri.parse('$baseUrl/api/cards'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token,
        'rules': 'load_submit',
        'owner': owner,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic>? responseJson = json.decode(response.body);
      if (responseJson != null && responseJson['cards'] is List) {
        final List<dynamic> cardDataList = responseJson['cards'];
        final List<CardResponse> cards =
            cardDataList.map((data) => CardResponse.fromJson(data)).toList();
        return cards;
      } else {
        throw Exception('Failed to get card data: Invalid response format');
      }
    } else {
      final Map<String, dynamic> data = json.decode(response.body);
      throw Exception('Failed to get card data: ${data['message']}');
    }
  }
}
