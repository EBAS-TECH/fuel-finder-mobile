import 'package:fuel_finder/features/auth/domain/repositories/auth_repository.dart';

class ForgotPasswordUsecase {
  final AuthRepository authRepository;

  ForgotPasswordUsecase({required this.authRepository});

  Future<Map<String, dynamic>> call(String email) async {
    return authRepository.forgotPassword(email);
  }
}

