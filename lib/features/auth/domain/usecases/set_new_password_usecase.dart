import 'package:fuel_finder/features/auth/domain/repositories/auth_repository.dart';

class SetNewPasswordUsecase {
  final AuthRepository authRepository;

  SetNewPasswordUsecase({required this.authRepository});
  Future<Map<String, dynamic>> call(String userId, String newPassword) {
    return authRepository.setNewPassword(userId, newPassword);
  }
}

