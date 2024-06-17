import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:accessflow/auth/data/preferences/shared_preference.dart';
import 'package:accessflow/draft/domain/card_response.dart';
import 'package:accessflow/utils/strings.dart';
import 'package:accessflow/create_card/data/repositories/card_repository.dart'; // Import the CardRepository class

class MockClient extends Mock implements http.Client {}

void main() {
  group('CardRepository', () {
    late CardRepository cardRepository;
    late MockClient mockClient;

    setUp(() {
      cardRepository = CardRepository();
      mockClient = MockClient();
    });

    tearDown(() {
      mockClient.close();
    });

    // Test the insertCard method
    test('insertCard - Successful', () async {
      // Arrange
      final responseJson = {'status': 200, 'message': 'Success'};
      final response = http.Response(json.encode(responseJson), 200);

      // Mock the http.post method to return a predefined response
      when(mockClient.post(
        Uri.parse('https://ecad-36-78-138-137.ngrok-free.app/api/cards'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => response);

      // Act
      final result = await cardRepository.insertCard(
        null, // id
        'owner',
        'name',
        'cardCredential',
        1, // cardStatus
        'cardType',
        'cardSubType',
        false, // checklistStatus
        'createDate',
        'ktpNumber',
        'photo',
        'reason',
      );

      // Assert
      expect(result, responseJson);
    });

    // Test the getAvailableAccessCard method
    test('getAvailableAccessCard - Successful', () async {
      // Arrange
      final responseJson = {
        'cards': [
          {
            'id': 1,
            'owner': 'John Doe',
            'card_status': 1,
            'card_credential': 'Credential',
            'card_type': 'Type',
            'card_sub_type': 'SubType',
            'checklist_status': true,
            'create_date': '2023-01-01',
            'ktp_number': '1234567890',
            'photo': 'base64image',
            'reason': 'Reason',
            'name': 'Card 1',
          }
        ]
      };
      final response = http.Response(json.encode(responseJson), 200);

      // Mock the http.get method to return a predefined response
      when(mockClient.get(
        Uri.parse('https://ecad-36-78-138-137.ngrok-free.app/api/cards'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => response);

      // Act
      final result = await cardRepository.getAvailableAccessCard();

      // Assert
      expect(result.length, 1);
      expect(result.first, isA<CardResponse>());
    });

    // Test the getAvailableAksesPerumdin method
    test('getAvailableAksesPerumdin - Successful', () async {
      // Arrange
      final responseJson = {
        'cards': [
          {
            'id': 1,
            'owner': 'John Doe',
            'card_status': 1,
            'card_credential': 'Credential',
            'card_type': 'Type',
            'card_sub_type': 'SubType',
            'checklist_status': true,
            'create_date': '2023-01-01',
            'ktp_number': '1234567890',
            'photo': 'base64image',
            'reason': 'Reason',
            'name': 'Card 1',
          }
        ]
      };
      final response = http.Response(json.encode(responseJson), 200);

      // Mock the http.get method to return a predefined response
      when(mockClient.get(
        Uri.parse('https://ecad-36-78-138-137.ngrok-free.app/api/cards'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => response);

      // Act
      final result = await cardRepository.getAvailableAksesPerumdin();

      // Assert
      expect(result.length, 1);
      expect(result.first, isA<CardResponse>());
    });
  });
}
