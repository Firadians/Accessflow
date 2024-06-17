import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:accessflow/history/data/repositories/card_repository.dart';
import 'package:accessflow/history/domain/card_response.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  group('CardRepository Tests', () {
    late CardRepository cardRepository;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
      cardRepository = CardRepository();
    });

    test('getSubmitCardData returns a list of CardResponse', () async {
      // Arrange
      // Mock the response you expect from the server.
      when(mockClient.get(
        Uri.parse('${CardRepository.baseUrl}/api/cards'),
        headers: captureAnyNamed('headers'), // Capture the headers.
      )).thenAnswer((_) async => http.Response(
            '''
            {
              "status": 200,
              "message": "Cards found",
              "cards": [
  {
            "id": 51,
            "owner": "firdo",
            "card_status": 1,
            "card_credential": "no data",
            "card_type": "Access Card",
            "card_sub_type": "PT Graha Sarana Gresik",
            "checklist_status": false,
            "create_date": "2023-12-01 13:38:36",
            "ktp_number": "64645788",
            "photo": "no data",
            "reason": "no data",
            "name": "edi cahyadi draf"
        },
        {
            "id": 50,
            "owner": "firdo",
            "card_status": 1,
            "card_credential": "no data",
            "card_type": "Access Card",
            "card_sub_type": "PT Graha Sarana Gresik",
            "checklist_status": false,
            "create_date": "2023-12-01 13:37:32",
            "ktp_number": "3134275854",
            "photo": "no data",
            "reason": "no data",
            "name": "edi cahyadi"
        },
        {
            "id": 15,
            "owner": "firdo",
            "card_status": 1,
            "card_credential": "no data",
            "card_type": "Akses Perumdin",
            "card_sub_type": "Ayah",
            "checklist_status": false,
            "create_date": "2023-11-23 09:52:55",
            "ktp_number": "51515151515",
            "photo": "no data",
            "reason": "no data",
            "name": "xadadwdwdw"
        },
        {
            "id": 46,
            "owner": "firdo",
            "card_status": 4,
            "card_credential": "no data",
            "card_type": "ID Card",
            "card_sub_type": "no data",
            "checklist_status": false,
            "create_date": "2023-11-09 07:27:21",
            "ktp_number": "123123123",
            "photo": "no data",
            "reason": "hshshsa",
            "name": "firdo"
        },
        {
            "id": 45,
            "owner": "firdo",
            "card_status": 3,
            "card_credential": "no data",
            "card_type": "Akses Perumdin",
            "card_sub_type": "Ayah",
            "checklist_status": false,
            "create_date": "2023-11-09 07:27:04",
            "ktp_number": "645899165",
            "photo": "no data",
            "reason": "no data",
            "name": "nosferatu"
        },
        {
            "id": 53,
            "owner": "firdo",
            "card_status": 4,
            "card_credential": "no data",
            "card_type": "Akses Perumdin",
            "card_sub_type": "Ayah",
            "checklist_status": false,
            "create_date": "2023-11-09 07:27:04",
            "ktp_number": "645899165",
            "photo": "no data",
            "reason": "no data",
            "name": "nosferatu"
        },
        {
            "id": 44,
            "owner": "firdo",
            "card_status": 2,
            "card_credential": "no data",
            "card_type": "Access Card",
            "card_sub_type": "PT Graha Sarana Gresik",
            "checklist_status": true,
            "create_date": "2023-11-09 07:26:43",
            "ktp_number": "316645789",
            "photo": "no data",
            "reason": "no data",
            "name": "curiga yang membuat"
        },
        {
            "id": 28,
            "owner": "firdo",
            "card_status": 1,
            "card_credential": "no data",
            "card_type": "Access Card",
            "card_sub_type": "PT Graha Sarana Gresik",
            "checklist_status": false,
            "create_date": "2023-11-02 07:29:59",
            "ktp_number": "8545545",
            "photo": "no data",
            "reason": "no data",
            "name": "gdgxgdte"
                }
              ]
            }
            ''',
            200,
          ));

      // Set the mock client in your repository.
      cardRepository.client = mockClient;

      // Act
      final result = await cardRepository.getSubmitCardData();

      // Assert
      expect(result, isA<List<CardResponse>>());
      // Add more assertions based on the actual data in the response.
    });

    // Add more test cases as needed.

    tearDown(() {
      // Clear any interactions with the mock client.
      clearInteractions(mockClient);
    });
  });
}
