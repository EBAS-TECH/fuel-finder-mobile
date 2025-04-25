import 'package:fuel_finder/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Map<String,dynamic>> signUp(
    String firstName,
    String lastName,
    String userName,
    String email,
    String password,
    String role,
  );
  Future<UserEntity> signIn(String userName, String password);
  Future<void> logOut();
  Future<void> verifyEmail(String? userId, String token);
}

