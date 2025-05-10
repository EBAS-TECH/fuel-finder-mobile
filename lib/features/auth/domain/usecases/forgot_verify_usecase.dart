import 'package:fuel_finder/features/auth/domain/repositories/auth_repository.dart';

class ForgotVerifyUsecase {
  final AuthRepository authRepository;

  ForgotVerifyUsecase({required this.authRepository});
  Future<Map<String, dynamic>> call(String userId, String code) async {
    return authRepository.forgotVerify(userId, code);
  }
}

