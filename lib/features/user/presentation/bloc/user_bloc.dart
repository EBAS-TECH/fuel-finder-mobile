import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuel_finder/core/exceptions/app_exceptions.dart';
import 'package:fuel_finder/core/utils/exception_handler.dart';
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
      final exception = ExceptionHandler.handleError(e);

      switch (exception.runtimeType) {
        case NotFoundException _:
          emit(UserNotFound(message: exception.message));
          break;
        case UnAuthorizedException _:
          emit(UserUnauthorized(message: exception.message));
          break;
        case BadRequestException _:
          emit(UserValidationError(message: exception.message));
          break;
        case SocketException _:
          emit(UserNetworkError(message: exception.message));
          break;
        case TimeoutException _:
          emit(UserTimeoutError(message: exception.message));
          break;
        case ServerErrorException _:
          emit(UserServerError(message: exception.message));
          break;
        default:
          emit(UserFailure(error: exception.message));
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
        emit(UserSuccess(response, message: "Successfully Updated"));
      }
    } catch (e) {
      final exception = ExceptionHandler.handleError(e);

      switch (exception.runtimeType) {
        case NotFoundException _:
          emit(UserNotFound(message: exception.message));
          break;
        case UnAuthorizedException _:
          emit(UserUnauthorized(message: exception.message));
          break;
        case BadRequestException _:
          emit(UserValidationError(message: exception.message));
          break;
        case ConflictException _:
          emit(UserConflictError(message: exception.message));
          break;
        case SocketException _:
          emit(UserNetworkError(message: exception.message));
          break;
        case TimeoutException _:
          emit(UserTimeoutError(message: exception.message));
          break;
        case ServerErrorException _:
          emit(UserServerError(message: exception.message));
          break;
        default:
          emit(UserFailure(error: exception.message));
      }
    }
  }
}

