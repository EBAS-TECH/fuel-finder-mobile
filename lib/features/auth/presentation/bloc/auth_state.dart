abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String message;

  AuthSuccess({required this.message});
}

class AuthEmailNotVerifed extends AuthState {
  final String message;
  final String userId;
  final Map<String, dynamic> user;

  AuthEmailNotVerifed({required this.message, required this.userId, required this.user});
}

class ResendCodeSuccess extends AuthState {
  final String message;

  ResendCodeSuccess({required this.message});
}

class AuthVerifyEmail extends AuthState {
  final String message;
  final String userId;
  final Map<String, dynamic> user;

  AuthVerifyEmail({
    required this.message,
    required this.userId,
    required this.user,
  });
}

class AuthLogInSucess extends AuthState {
  final String message;
  final String userId;

  AuthLogInSucess({required this.message, required this.userId});
}

class AuthFailure extends AuthState {
  final String error;

  AuthFailure({required this.error});
}

class AuthForgotPasswordSucess extends AuthState {
  final Map<String, dynamic> response;

  AuthForgotPasswordSucess({required this.response});
}

class AuthVerifyForgotSucess extends AuthState {
  final Map<String, dynamic> response;

  AuthVerifyForgotSucess({required this.response});
}

class AuthSetNewPasswordSucess extends AuthState {
  final String message;

  AuthSetNewPasswordSucess({required this.message});
}

