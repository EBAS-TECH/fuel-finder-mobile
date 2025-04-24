import 'package:fuel_finder/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:fuel_finder/features/auth/domain/entities/user_entity.dart';
import 'package:fuel_finder/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepositoryImpl({required this.authRemoteDataSource});
  @override
  Future<UserEntity> signIn(String userName, String password) {
    return authRemoteDataSource.signIn(userName, password);
  }

  @override
  Future<UserEntity> signUp(
    String firstName,
    String lastName,
    String userName,
    String email,
    String password,
    String role,
  ) {
    return authRemoteDataSource.signUp(
      firstName,
      lastName,
      userName,
      email,
      password,
      role,
    );
  }

  @override
  Future<void> verifyEmail(String userId, String token) {
    return authRemoteDataSource.veriyEmail(userId);
  }

  @override
  Future<void> logOut() {
    return authRemoteDataSource.logOut();
  }
}

