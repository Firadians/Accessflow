import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:accessflow/create_card/data/repositories/card_repository.dart'; // Adjust the import based on your actual file structure
import 'package:accessflow/utils/strings.dart';

// Mocking the http client
class MockClient extends Mock implements http.Client {}

void main() {
  group('CardRepository', () {
    late CardRepository cardRepository;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
      cardRepository = CardRepository();
    });

    test('insertCard - POST method', () async {
      // Arrange
      final expectedResponse = {
        'status': 'success',
        'message': 'Card created successfully',
      };
      when(mockClient.post(
        Uri.parse(ApiEndpoints.baseUrl),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer(
          (_) async => http.Response(jsonEncode(expectedResponse), 200));

      // Act
      final result = await cardRepository.insertCard(
        null,
        'John Doe',
        'Card Name',
        'Credential',
        1,
        'Type',
        'Subtype',
        true,
        '2023-11-22',
        '1234567890',
        'photo.jpg',
        'Reason',
      );

      // Assert
      expect(result, expectedResponse);
    });

    test('getAvailableAccessCard - GET method', () async {
      // Arrange
      final expectedResponse = {
        'cards': [
          // List of card data
        ],
      };
      when(mockClient.get(
        Uri.parse('https://3411-110-138-238-216.ngrok-free.app/api/cards'),
        headers: anyNamed('headers'),
      )).thenAnswer(
          (_) async => http.Response(jsonEncode(expectedResponse), 200));

      // Act
      final result = await cardRepository.getAvailableAccessCard();

      // Assert
      expect(result, isA<List>());
    });

    // Add more tests for other methods if needed

    tearDown(() {
      clearInteractions(mockClient);
    });
  });
}
