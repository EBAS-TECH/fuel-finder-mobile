abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSucess extends AuthState {
  final String message;
  String? userId;

  AuthSucess({required this.message, this.userId});
}

class AuthFailure extends AuthState {
  final String error;

  AuthFailure({required this.error});
}

