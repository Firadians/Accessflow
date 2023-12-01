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

      User? user;
      // Call the signIn method with invalid credentials
      try {
        user = await userRepository.signIn(invalidUsername, invalidPassword);
      } catch (e) {
        // Assert that the exception is thrown and has the expected message
        expect(e, isA<Exception>());
        expect(user, isNull);
      }
    });

    test('signIn - Valid Credentials', () async {
      final userRepository = UserRepository();

      // Provide valid credentials for testing
      const validUsername = '123123123';
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

  test('checkLoginAccess - Valid Name and Token', () async {
    final userRepository = UserRepository();
    final int accessStatus = await userRepository.checkLoginAccess('firdo');

    print(accessStatus);
    // Assert that the returned access status is as expected
    expect(
        accessStatus, isNotNull); // Adjust based on the actual expected value
  });

  test('checkLoginAccess - Invalid Name and Token', () async {
    final userRepository = UserRepository();

    // Assert that the checkLoginAccess method throws an exception for invalid parameters
    expect(() async {
      await userRepository.checkLoginAccess(null);
    }, throwsException);
  });

  // Add more test cases for checkLoginAccess method based on different scenarios
}
