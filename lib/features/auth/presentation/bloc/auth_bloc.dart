import 'dart:io';
import 'package:flutter/foundation.dart';
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
      debugPrint(user.toString());
      debugPrint(user["data"]["id"]);

      emit(AuthSuccess(
        message: "Registration successful",
        userId: user["data"]["id"],
      ));
    } on SocketException {
      emit(AuthFailure(error: "No Internet connection."));
    } on FormatException {
      emit(AuthFailure(error: "Invalid data format received."));
    } catch (e, stack) {
      if (kDebugMode) debugPrintStack(stackTrace: stack);
      emit(AuthFailure(error: "Sign up failed. ${e.toString()}"));
    }
  }

  Future<void> _onSignIn(AuthSignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await signinUsecase(event.userName, event.password);
      debugPrint(user.toString());
      emit(AuthSuccess(message: "Login successful"));
    } on SocketException {
      emit(AuthFailure(error: "No Internet connection."));
    } on FormatException {
      emit(AuthFailure(error: "Invalid response format."));
    } catch (e, stack) {
      if (kDebugMode) debugPrintStack(stackTrace: stack);
      emit(AuthFailure(error: "Login failed. ${e.toString()}"));
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
    emit(AuthFailure(error: "No Internet connection."));
  } on FormatException {
    emit(AuthFailure(error: "Invalid response format."));
  } catch (e) {
    emit(AuthFailure(error: e.toString()));
  }
}

  Future<void> _onLogOut(AuthLogOutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await logoutUsecase();
      emit(AuthSuccess(message: "Logout successful"));
    } on SocketException {
      emit(AuthFailure(error: "No Internet connection."));
    } catch (e, stack) {
      if (kDebugMode) debugPrintStack(stackTrace: stack);
      emit(AuthFailure(error: "Logout failed. ${e.toString()}"));
    }
  }
}

