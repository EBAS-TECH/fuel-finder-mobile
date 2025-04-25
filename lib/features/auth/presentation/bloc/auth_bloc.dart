import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuel_finder/features/auth/domain/usecases/logout_usecase.dart';
import 'package:fuel_finder/features/auth/domain/usecases/signin_usecase.dart';
import 'package:fuel_finder/features/auth/domain/usecases/signup_usecase.dart';
import 'package:fuel_finder/features/auth/domain/usecases/verify_email_usecase.dart';
import 'package:fuel_finder/features/auth/presentation/bloc/auth_event.dart';
import 'package:fuel_finder/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignupUsecase signupUsecase;
  final SigninUsecase signinUsecase;
  final VerifyEmailUsecase verifyEmailUsecase;
  final LogoutUsecase logoutUsecase;

  String _cleanErrorMessage(dynamic error) {
    String message = error.toString();
    if (message.startsWith('Exception: ')) {
      message = message.substring('Exception: '.length);
    }
    return message;
  }

  AuthBloc({
    required this.signupUsecase,
    required this.signinUsecase,
    required this.verifyEmailUsecase,
    required this.logoutUsecase,
  }) : super(AuthInitial()) {
    on<AuthSignUpEvent>(_onSignUp);
    on<AuthSignInEvent>(_onSignIn);
    on<AuthVerifyEmailEvent>(_onVerifyEmail);
    on<AuthLogOutEvent>(_onLogOut);
  }

  Future<void> _onSignUp(AuthSignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await signupUsecase(
        event.firstName,
        event.lastName,
        event.userName,
        event.email,
        event.password,
        event.role,
      );

      emit(
        AuthVerifyEmail(
          message: "Registration successful",
          userId: user["data"]["id"],
        ),
      );
    } on SocketException {
      emit(AuthFailure(error: "No Internet connection"));
    } on FormatException {
      emit(AuthFailure(error: "Invalid data format"));
    } catch (e) {
      emit(AuthFailure(error: _cleanErrorMessage(e)));
    }
  }

  Future<void> _onSignIn(AuthSignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await signinUsecase(event.userName, event.password);
      final userId = response["data"]["id"];
      emit(AuthLogInSucess(message: "Login successful", userId: userId));
    } on SocketException {
      emit(AuthFailure(error: "No Internet connection"));
    } on FormatException {
      emit(AuthFailure(error: "Invalid data format"));
    } catch (e) {
      emit(AuthFailure(error: _cleanErrorMessage(e)));
    }
  }

  Future<void> _onVerifyEmail(
    AuthVerifyEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await verifyEmailUsecase(event.userId, event.token);
      emit(AuthSuccess(message: "Email verification successful"));
    } on SocketException {
      emit(AuthFailure(error: "No Internet connection"));
    } on FormatException {
      emit(AuthFailure(error: "Invalid verification code"));
    } catch (e) {
      emit(AuthFailure(error: _cleanErrorMessage(e)));
    }
  }

  Future<void> _onLogOut(AuthLogOutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await logoutUsecase();
      emit(AuthSuccess(message: "Logout successful"));
    } on SocketException {
      emit(AuthFailure(error: "No Internet connection"));
    } catch (e) {
      emit(AuthFailure(error: _cleanErrorMessage(e)));
    }
  }
}

