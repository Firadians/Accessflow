import 'package:flutter_test/flutter_test.dart';
import 'package:accessflow/auth/data/repositories/user_repository.dart'; // Adjust the import based on your file structure
import 'package:accessflow/auth/domain/entities/user.dart';

void main() {
  group('Auth Repository Tests', () {
    test('signIn - Failed Authentication', () async {
      final userRepository = UserRepository();

      // Provide invalid credentials for testing
      const invalidUsername = 'invalidUsername';
      const invalidPassword = 'invalidPassword';

      // Call the signIn method with invalid credentials
      User? user;
      expect(
        () async {
          user = await userRepository.signIn(invalidUsername, invalidPassword);
        },
        throwsA(isA<TypeError>()),
      );

      // Assert that the user is null
      expect(user, isNull);
    });

    test('signIn - Valid Credentials', () async {
      final userRepository = UserRepository();

      // Provide valid credentials for testing
      const validUsername = '205150201111036';
      const validPassword = '123123123';

      // Use try-catch to catch the exception if it occurs
      User? user;
      try {
        // Call the signIn method with valid credentials
        user = await userRepository.signIn(validUsername, validPassword);
      } catch (e) {
        // Handle the exception if needed
        print('Exception during signIn: $e');
      }

      // Assert that the returned user is not null and has the expected properties
      expect(user, isNotNull);
      expect(user!.id, isNotNull);
      expect(user.name, isNotNull);
      expect(user.ktp, isNotNull);
      expect(user.photo, isNotNull);
      expect(user.position, isNotNull);
      expect(user.rememberToken, isNotNull);
    });
  });
}
