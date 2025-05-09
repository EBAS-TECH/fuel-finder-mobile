import 'package:fuel_finder/features/user/domain/repositories/user_repository.dart';

class ChangePasswordUsecase {
  final UserRepository userRepository;

  ChangePasswordUsecase({required this.userRepository});

  Future<Map<String, dynamic>> call(String oldPassword, String newPassword) {
    return userRepository.changePassword(oldPassword, newPassword);
  }
}

