abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSucess extends AuthState {
  final String message;

  AuthSucess({required this.message});
}

class AuthFailure extends AuthState {
  final String error;

  AuthFailure({required this.error});
}

