abstract class UserRepository {
  Future<Map<String, dynamic>> getUserById(String userId);
  Future<Map<String, dynamic>> updateUserById(
    String userId,
    String firstName,
    String lastName,
    String userName,
  );
  Future<Map<String, dynamic>> changePassword(
    String oldPassword,
    String newPassword,
  );
}

