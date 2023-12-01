import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:accessflow/draft/domain/card_response.dart';
import 'package:accessflow/auth/data/preferences/shared_preference.dart';
import 'package:accessflow/history/data/repositories/card_repository.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockSharedPreference extends Mock implements SharedPreference {}

void main() {
  group('CardRepository Tests', () {
    late CardRepository cardRepository;
    late MockHttpClient mockHttpClient;
    late MockSharedPreference mockSharedPreference;

    setUp(() {
      mockHttpClient = MockHttpClient();
      mockSharedPreference = MockSharedPreference();
      cardRepository = CardRepository();
    });

    test('getSubmitCardData returns a list of CardResponse', () async {
      // Arrange
      // when(mockSharedPreference.getUserFromSharedPreferences())
      //     .thenAnswer((_) async => 'test_owner');
      // when(mockSharedPreference.getTokenFromSharedPreferences())
      //     .thenAnswer((_) async => 'test_token');

      final mockedResponse = http.Response(
        json.encode({
          // 'cards': [
          //   {'cardType': 'Type1', 'createData': '2023-01-01', 'cardStatus': 1},
          //   {'cardType': 'Type2', 'createData': '2023-01-02', 'cardStatus': 2},
          // ],
          'status': 401,
          'message': 'Unauthorized: Missing Authorization header',
        }),
        200,
      );

      when(mockHttpClient.get(
        Uri.parse('https://3411-110-138-238-216.ngrok-free.app/api/cards'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => mockedResponse);

      // Act
      final result = await cardRepository.getSubmitCardData();

      // Assert
      expect(result, isA<List<CardResponse>>());
      expect(result.length, 2);
      expect(result[0].cardType, 'Type1');
      expect(result[1].cardType, 'Type2');
    });

    // Add more tests for error cases, edge cases, etc.
  });

  group('HistoryScreen Tests', () {
    // Add tests for the HistoryScreen class
    // You can mock dependencies using MockHttpClient and MockSharedPreference
  });
}
