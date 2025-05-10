import 'package:fuel_finder/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:fuel_finder/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepositoryImpl({required this.authRemoteDataSource});
  @override
  Future<Map<String, dynamic>> signIn(String userName, String password) {
    return authRemoteDataSource.signIn(userName, password);
  }

  @override
  Future<Map<String, dynamic>> signUp(
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
  Future<void> verifyEmail(String userId, String token) async {
    return await authRemoteDataSource.verifyEmail(userId, token);
  }

  @override
  Future<void> logOut() async {
    return await authRemoteDataSource.logOut();
  }

  @override
  Future<void> resendCode(String userId) async {
    return await authRemoteDataSource.resendCode(userId);
  }

  @override
  Future<Map<String, dynamic>> forgotPassword(String email) {
    return authRemoteDataSource.forgotPassword(email);
  }

  @override
  Future<Map<String, dynamic>> forgotVerify(String userId, String code) {
    return authRemoteDataSource.forgotVerify(userId, code);
  }

  @override
  Future<Map<String, dynamic>> setNewPassword(
    String userId,
    String newPassword,
  ) {
    return authRemoteDataSource.setNewPassword(userId, newPassword);
  }
}

