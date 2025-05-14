abstract class AuthEvent {}

class AuthSignUpEvent extends AuthEvent {
  final String firstName;
  final String lastName;
  final String userName;
  final String email;
  final String password;
  final String role;

  AuthSignUpEvent({
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.email,
    required this.password,
    required this.role,
  });
}

class AuthSignInEvent extends AuthEvent {
  final String userName;
  final String password;

  AuthSignInEvent({required this.userName, required this.password});
}


class AuthVerifyEmailEvent extends AuthEvent {
  final String userId;
  final String token;

  AuthVerifyEmailEvent({required this.userId, required this.token});
}

class AuthLogOutEvent extends AuthEvent {}

class AuthResendCodeEvent extends AuthEvent {
  final String userId;

  AuthResendCodeEvent({required this.userId});
}

class AuthForgotPasswordEvent extends AuthEvent {
  final String email;

  AuthForgotPasswordEvent({required this.email});
}

class AuthVerifyForgotEvent extends AuthEvent {
  final String userId;
  final String code;

  AuthVerifyForgotEvent({required this.userId, required this.code});
}

class AuthSetNewPasswordEvent extends AuthEvent {
  final String userId;
  final String newPassword;

  AuthSetNewPasswordEvent({required this.userId, required this.newPassword});
}

