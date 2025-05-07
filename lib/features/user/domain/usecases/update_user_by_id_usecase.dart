import 'package:fuel_finder/features/user/domain/repositories/user_repository.dart';

class UpdateUserByIdUsecase {
  final UserRepository userRepository;

  UpdateUserByIdUsecase({required this.userRepository});
  Future<Map<String, dynamic>> call(
    String userId,
    String firstName,
    String lastName,
    String userName,
  ) {
    return userRepository.updateUserById(userId, firstName, lastName, userName);
  }
}

