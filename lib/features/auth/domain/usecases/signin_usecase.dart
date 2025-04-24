import 'package:fuel_finder/features/auth/domain/entities/user_entity.dart';
import 'package:fuel_finder/features/auth/domain/repositories/auth_repository.dart';

class SigninUsecase {
  final AuthRepository authRepository;

  SigninUsecase({required this.authRepository});
  Future<UserEntity> call(String userName, String password) {
    return authRepository.signIn(userName, password);
  }
}

