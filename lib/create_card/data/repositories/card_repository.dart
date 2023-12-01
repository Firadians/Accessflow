import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:accessflow/auth/data/preferences/shared_preference.dart';
import 'package:accessflow/draft/domain/card_response.dart';
import 'package:accessflow/utils/strings.dart';

class CardRepository {
  //link URL
  static const baseUrl = ApiEndpoints.baseUrl;
  final SharedPreference sharedPreference = SharedPreference();

  //POST Method Create Card Function
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
    String? token =
        (await sharedPreference.getTokenFromSharedPreferences()) ?? '';
    if (id == null) {
      //POST Method Create Card Function
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
      //PUT Method Create Card Function
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

  //GET Method of submitted card for DropModelList that card status equal to 4 (finished card)
  Future<List<CardResponse>> getAvailableAccessCard() async {
    String? owner =
        (await sharedPreference.getUserFromSharedPreferences()) ?? '';
    String? token =
        (await sharedPreference.getTokenFromSharedPreferences()) ?? '';
    final response = await http.get(
      Uri.parse('$baseUrl/api/cards'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'rules': 'load_exist_access_card', // Add your authorization header
        'owner': owner,
        'Authorization': token
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

  //GET Method of submitted card for DropModelList that card status equal to 4 (finished card)
  Future<List<CardResponse>> getAvailableAksesPerumdin() async {
    String? owner =
        (await sharedPreference.getUserFromSharedPreferences()) ?? '';
    String? token =
        (await sharedPreference.getTokenFromSharedPreferences()) ?? '';
    final response = await http.get(
      Uri.parse('$baseUrl/api/cards'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'rules': 'load_exist_akses_perumdin', // Add your authorization header
        'owner': owner,
        'Authorization': token
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
