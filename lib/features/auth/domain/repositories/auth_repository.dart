import 'package:fuel_finder/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> signUp(
    String firstName,
    String lastName,
    String userName,
    String email,
    String password,
  );
  Future<UserEntity> signIn(String userName, String password);
  Future<void> logOut();
}

