import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuel_finder/core/exceptions/app_exceptions.dart';
import 'package:fuel_finder/core/utils/exception_handler.dart';
import 'package:fuel_finder/core/utils/token_services.dart';
import 'package:fuel_finder/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:fuel_finder/features/auth/domain/usecases/forgot_verify_usecase.dart';
import 'package:fuel_finder/features/auth/domain/usecases/logout_usecase.dart';
import 'package:fuel_finder/features/auth/domain/usecases/resend_code_usecase.dart';
import 'package:fuel_finder/features/auth/domain/usecases/set_new_password_usecase.dart';
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
  final ResendCodeUsecase resendCodeUsecase;
  final ForgotPasswordUsecase forgotPasswordUsecase;
  final ForgotVerifyUsecase forgotVerifyUsecase;
  final SetNewPasswordUsecase setNewPasswordUsecase;
  final TokenService tokenService;

  static const int _minimumLoadingTime = 1500;

  AuthBloc({
    required this.forgotVerifyUsecase,
    required this.setNewPasswordUsecase,
    required this.forgotPasswordUsecase,
    required this.resendCodeUsecase,
    required this.signupUsecase,
    required this.signinUsecase,
    required this.verifyEmailUsecase,
    required this.logoutUsecase,
    required this.tokenService,
  }) : super(AuthInitial()) {
    on<AuthSignUpEvent>(_onSignUp);
    on<AuthSignInEvent>(_onSignIn);
    on<AuthVerifyEmailEvent>(_onVerifyEmail);
    on<AuthLogOutEvent>(_onLogOut);
    on<AuthResendCodeEvent>(_onResend);
    on<AuthForgotPasswordEvent>(_onForgotPassword);
    on<AuthVerifyForgotEvent>(_onForgotVerify);
    on<AuthSetNewPasswordEvent>(_onSetNewPassword);
  }

  Future<void> _onSignUp(AuthSignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await signupUsecase(
        event.firstName,
        event.lastName,
        event.userName,
        event.email,
        event.password,
        event.role,
      );

      final userData = response["data"];
      final userId = userData["id"];
      final isVerified = userData["verified"] ?? false;

      if (isVerified) {
        emit(AuthSuccess(message: "Registration successful"));
      } else {
        emit(
          AuthVerifyEmail(
            message: "Verification code sent to your email",
            userId: userId,
            user: userData,
          ),
        );
      }
    } on ConflictException catch (e) {
      emit(AuthFailure(error: e.message));
    } catch (e) {
      final exception = ExceptionHandler.handleError(e);
      emit(AuthFailure(error: ExceptionHandler.getErrorMessage(exception)));
    }
  }

  Future<void> _onSignIn(AuthSignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final stopwatch = Stopwatch()..start();

    try {
      final response = await signinUsecase(event.userName, event.password);
      final userId = response["user"]["id"];
      final token = response["token"] ?? "";
      final userData = response["user"];
      final isVerified = response["user"]["verified"] ?? false;

      await tokenService.saveToken(token);
      await tokenService.saveUserId(userId);

      final elapsed = stopwatch.elapsedMilliseconds;
      if (elapsed < _minimumLoadingTime) {
        await Future.delayed(
          Duration(milliseconds: _minimumLoadingTime - elapsed),
        );
      }
      if (isVerified) {
        emit(AuthLogInSucess(message: "Login successful", userId: userId));
      } else {
        emit(
          AuthEmailNotVerifed(
            message: "Email not verifed",
            userId: userId,
            user: userData,
          ),
        );
      }
    } catch (e) {
      final exception = ExceptionHandler.handleError(e);
      emit(AuthFailure(error: exception.toString()));
    } finally {
      stopwatch.stop();
    }
  }

  Future<void> _onVerifyEmail(
    AuthVerifyEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await verifyEmailUsecase(event.userId, event.token);
      emit(AuthSuccess(message: "Email verification successful. Please login"));
    } catch (e) {
      final exception = ExceptionHandler.handleError(e);
      emit(AuthFailure(error: ExceptionHandler.getErrorMessage(exception)));
    }
  }

  Future<void> _onLogOut(AuthLogOutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await logoutUsecase();
      await tokenService.clearAll();
      emit(AuthSuccess(message: "Logout successful"));
    } catch (e) {
      final exception = ExceptionHandler.handleError(e);
      emit(AuthFailure(error: ExceptionHandler.getErrorMessage(exception)));
    }
  }

  Future<void> _onResend(
    AuthResendCodeEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await resendCodeUsecase(event.userId);
      emit(ResendCodeSuccess(message: "Verification code resent"));
    } catch (e) {
      final exception = ExceptionHandler.handleError(e);
      emit(AuthFailure(error: ExceptionHandler.getErrorMessage(exception)));
    }
  }

  Future<void> _onForgotPassword(
    AuthForgotPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await forgotPasswordUsecase(event.email);
      emit(AuthForgotPasswordSucess(response: response));
    } catch (e) {
      final exception = ExceptionHandler.handleError(e);
      emit(AuthFailure(error: ExceptionHandler.getErrorMessage(exception)));
    }
  }

  Future<void> _onForgotVerify(
    AuthVerifyForgotEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await forgotVerifyUsecase(event.userId, event.code);
      emit(AuthVerifyForgotSucess(response: response));
    } catch (e) {
      final exception = ExceptionHandler.handleError(e);
      emit(AuthFailure(error: ExceptionHandler.getErrorMessage(exception)));
    }
  }

  Future<void> _onSetNewPassword(
    AuthSetNewPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final responsee = await setNewPasswordUsecase(
        event.userId,
        event.newPassword,
      );
      emit(
        AuthSetNewPasswordSucess(
          message: "Successfully updated password. Please login",
        ),
      );
      print("Password update response $responsee");
    } catch (e) {
      print(e.toString());
      final exception = ExceptionHandler.handleError(e);
      emit(AuthFailure(error: ExceptionHandler.getErrorMessage(exception)));
    }
  }
}

