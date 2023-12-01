import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:accessflow/draft/domain/card_response.dart';
import 'package:accessflow/auth/data/preferences/shared_preference.dart';
import 'package:accessflow/utils/strings.dart';

class CardRepository {
  static const baseUrl = ApiEndpoints.baseUrl;
  final SharedPreference sharedPreference = SharedPreference();

  //GET Method of draft card
  Future<List<CardResponse>> getDraftCardData() async {
    String? owner =
        (await sharedPreference.getUserFromSharedPreferences()) ?? '';
    String? token =
        (await sharedPreference.getTokenFromSharedPreferences()) ?? '';

    final response = await http.get(
      Uri.parse('$baseUrl/api/cards'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token,
        'rules': 'load_draft',
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

  //DELETE Method of draft card
  Future<void> deleteDraftCardData(String cardId) async {
    String? owner =
        (await sharedPreference.getUserFromSharedPreferences()) ?? '';
    String? token =
        (await sharedPreference.getTokenFromSharedPreferences()) ?? '';

    final response = await http.delete(
      Uri.parse('$baseUrl/api/cards'), // Include the card ID in the URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token,
        'id': cardId,
        'owner': owner,
      },
    );

    if (response.statusCode == 200) {
      // Card deleted successfully
      return;
    } else {
      final Map<String, dynamic> data = json.decode(response.body);
      throw Exception('Failed to delete card: ${data['message']}');
    }
  }

  Future<Map<String, dynamic>> insertCard(
      int? id,
      String owner,
      String name,
      String cardCredential,
      int cardStatus,
      String cardType,
      String cardSubType,
      bool checklistStatus,
      String createDate,
      String ktpNumber,
      String? photo,
      String reason) async {
    String? token = (await sharedPreference.getTokenFromSharedPreferences()) ??
        ''; // Use an empty string as a default value
    if (id == null) {
      final response = await http.post(
        Uri.parse('$baseUrl/api/cards'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token
        },
        body: jsonEncode({
          'owner': owner,
          'name': name,
          'card_status': cardStatus,
          'card_credential': cardCredential,
          'card_sub_type': cardSubType,
          'card_type': cardType,
          'checklist_status': checklistStatus,
          'create_date': createDate,
          'ktp_number': ktpNumber,
          'photo': photo,
          'reason': reason,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey('status') &&
            responseData.containsKey('message')) {
          return {
            'status': responseData['status'],
            'message': responseData['message'],
          };
        } else {
          throw Exception(
              'Invalid response format: Missing "status" and "message" fields');
        }
      } else {
        throw Exception('Failed to create user');
      }
    } else {
      final response = await http.post(
        Uri.parse('$baseUrl/api/cards'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token
        },
        body: jsonEncode({
          'id': id,
          'owner': owner,
          'name': name,
          'card_status': cardStatus,
          'card_credential': cardCredential,
          'card_sub_type': cardSubType,
          'card_type': cardType,
          'checklist_status': checklistStatus,
          'create_date': createDate,
          'ktp_number': ktpNumber,
          'photo': photo,
          'reason': reason,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey('status') &&
            responseData.containsKey('message')) {
          return {
            'status': responseData['status'],
            'message': responseData['message'],
          };
        } else {
          throw Exception(
              'Invalid response format: Missing "status" and "message" fields');
        }
      } else {
        throw Exception('Failed to create user');
      }
    }
  }
}
