import 'package:fuel_finder/features/auth/domain/repositories/auth_repository.dart';

class ResendCodeUsecase {
  final AuthRepository authRepository;

  ResendCodeUsecase({required this.authRepository});

  Future<void> call(String userId) {
    return authRepository.resendCode(userId);
  }
}

