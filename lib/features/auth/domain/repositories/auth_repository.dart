abstract class AuthRepository {
  Future<Map<String, dynamic>> signUp(
    String firstName,
    String lastName,
    String userName,
    String email,
    String password,
    String role,
  );
  Future<Map<String, dynamic>> signIn(String userName, String password);
  Future<void> logOut();
  Future<void> verifyEmail(String userId, String token);
  Future<void> resendCode(String userId);
  Future<Map<String, dynamic>> forgotPassword(String email);
  Future<Map<String, dynamic>> forgotVerify(String userId, String code);
  Future<Map<String, dynamic>> setNewPassword(
    String userId,
    String newPassword,
  );
}

