import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:accessflow/draft/data/repositories/card_repository.dart';
import 'package:accessflow/draft/domain/card_response.dart';
import 'package:accessflow/auth/data/preferences/shared_preference.dart';
import 'package:accessflow/utils/strings.dart';
import 'package:mockito/mockito.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockSharedPreference extends Mock implements SharedPreference {}

void main() {
  group('CardRepository', () {
    late CardRepository cardRepository;
    late MockHttpClient mockHttpClient;
    late MockSharedPreference mockSharedPreference;

    setUp(() {
      mockHttpClient = MockHttpClient();
      mockSharedPreference = MockSharedPreference();
      cardRepository = CardRepository();
    });

    test('getDraftCardData returns a list of CardResponse', () async {
      // Arrange
      when(mockSharedPreference.getUserFromSharedPreferences())
          .thenAnswer((_) async => 'test_owner');
      when(mockSharedPreference.getTokenFromSharedPreferences())
          .thenAnswer((_) async => 'test_token');

      final mockResponse = http.Response(
        '{"cards": [{"id": 1, "owner": "test_owner", "name": "Test Card", "card_status": 0, "card_credential": "Credential", "card_sub_type": "SubType", "card_type": "Type", "checklist_status": false, "create_date": "2023-01-01", "ktp_number": "123456789", "photo": "null", "reason": "Test Reason"}]}',
        200,
      );

      when(mockHttpClient.get(
        Uri.parse('${CardRepository.baseUrl}/api/cards'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => mockResponse);

      // Act
      final result = await cardRepository.getDraftCardData();

      // Assert
      expect(result, isA<List<CardResponse>>());
      expect(result.length, 1);
      expect(result[0].id, 1);
      expect(result[0].owner, 'test_owner');
      expect(result[0].name, 'Test Card');
      // Add more assertions based on your actual CardResponse class properties
    });

    // Add more test cases for other functions in CardRepository
  });
}
