import 'dart:io';

import 'package:fuel_finder/features/user/data/datasources/user_remote_data_source.dart';
import 'package:fuel_finder/features/user/domain/repositories/user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  final UserRemoteDataSource userRemoteDataSource;

  UserRepositoryImpl({required this.userRemoteDataSource});
  @override
  Future<Map<String, dynamic>> getUserById(String userId) {
    return userRemoteDataSource.getUserById(userId);
  }

  @override
  Future<Map<String, dynamic>> updateUserById(
    String userId,
    String firstName,
    String lastName,
    String userName,
  ) {
    return userRemoteDataSource.updateUserById(
      userId,
      firstName,
      lastName,
      userName,
    );
  }

  @override
  Future<Map<String, dynamic>> changePassword(
    String oldPassword,
    String newPassword,
  ) {
    return userRemoteDataSource.changePassword(oldPassword, newPassword);
  }

  @override
  Future<void> uploadProfilePic(File imageFile) {
    return userRemoteDataSource.uploadProfilePic(imageFile);
  }
}

