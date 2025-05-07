// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fuel_finder/features/user/domain/usecases/get_user_by_id_usecase.dart';
import 'package:fuel_finder/features/user/domain/usecases/update_user_by_id_usecase.dart';
import 'package:fuel_finder/features/user/presentation/bloc/user_event.dart';
import 'package:fuel_finder/features/user/presentation/bloc/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUserByIdUsecase getUserByIdUsecase;
  final UpdateUserByIdUsecase updateUserByIdUsecase;

  UserBloc({
    required this.getUserByIdUsecase,
    required this.updateUserByIdUsecase,
  }) : super(UserInitial()) {
    on<GetUserByIdEvent>(_getUserById);
    on<UpdateUserByIdEvent>(_updateUserById);
  }

  Future<void> _getUserById(
    GetUserByIdEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      final response = await getUserByIdUsecase(event.userId);
      if (response['data'] == null) {
        emit(UserNotFound(message: "User not found"));
      } else {
        emit(UserSuccess(response, message: "Successfully fetched"));
      }
    } catch (e) {
      if (e.toString().contains("404") || e.toString().contains("not found")) {
        emit(UserNotFound(message: "User not found"));
      } else {
        emit(UserFailure(error: e.toString()));
      }
    }
  }

  Future<void> _updateUserById(
    UpdateUserByIdEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      final response = await updateUserByIdUsecase(
        event.userId,
        event.firstName,
        event.lastName,
        event.userName,
      );
      if (response['data'] == null) {
        emit(UserNotFound(message: "User not found"));
      } else {
        emit(UserSuccess(response, message: "Successfully Upadated"));
      }
    } catch (e) {
      if (e.toString().contains("404") || e.toString().contains("not found")) {
        emit(UserNotFound(message: "User not found"));
      } else {
        emit(UserFailure(error: e.toString()));
      }
    }
  }
}

