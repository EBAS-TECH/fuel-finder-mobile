abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String message;
  String? userId;

  AuthSuccess({required this.message, this.userId});
}

class AuthFailure extends AuthState {
  final String error;

  AuthFailure({required this.error});
}

