import 'package:accessflow/auth/data/repositories/user_repository.dart';
import 'package:accessflow/auth/domain/entities/user.dart';

class UserUseCase {
  static Future<User> signIn(String username, String password) async {
    final user = await UserRepository().signIn(username, password);
    return user;
  }
}
