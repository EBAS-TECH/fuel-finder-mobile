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
      emit(AuthSucess(message: "Registration sucessful"));
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
    emit(AuthInitial());
  }

  Future<void> _onSignIn(AuthSignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await signinUsecase(event.userName, event.password);
      debugPrint(user.toString());
      emit(AuthSucess(message: "Login sucessful"));
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
    emit(AuthInitial());
  }

  Future<void> _onVerifyEmail(
    AuthVerifyEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
    await verifyEmailUsecase(event.userId, event.token);
    emit(AuthLoading());
    try {
      emit(AuthSucess(message: "Email verifcation sucessful"));
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
    emit(AuthInitial());
  }

  Future<void> _onLogOut(AuthLogOutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await logoutUsecase();
      emit(AuthSucess(message: "Logout sucessful"));
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
    emit(AuthInitial());
  }
}

