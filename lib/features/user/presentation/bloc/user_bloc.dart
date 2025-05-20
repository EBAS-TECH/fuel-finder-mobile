import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuel_finder/core/exceptions/app_exceptions.dart';
import 'package:fuel_finder/core/utils/exception_handler.dart';
import 'package:fuel_finder/features/user/domain/usecases/change_password_usecase.dart';
import 'package:fuel_finder/features/user/domain/usecases/get_user_by_id_usecase.dart';
import 'package:fuel_finder/features/user/domain/usecases/update_user_by_id_usecase.dart';
import 'package:fuel_finder/features/user/domain/usecases/upload_profile_pic_usecase.dart';
import 'package:fuel_finder/features/user/presentation/bloc/user_event.dart';
import 'package:fuel_finder/features/user/presentation/bloc/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUserByIdUsecase getUserByIdUsecase;
  final UpdateUserByIdUsecase updateUserByIdUsecase;
  final ChangePasswordUsecase changePasswordUsecase;
  final UploadProfilePicUsecase uploadProfilePicUsecase;

  UserBloc({
    required this.getUserByIdUsecase,
    required this.updateUserByIdUsecase,
    required this.changePasswordUsecase,
    required this.uploadProfilePicUsecase,
  }) : super(UserInitial()) {
    on<GetUserByIdEvent>(_getUserById);
    on<UpdateUserByIdEvent>(_updateUserById);
    on<ChangePasswordEvent>(_changePassword);
    on<UploadProfilePicEvent>(_uploadProfilePic);
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
      _handleError(exception, emit);
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
      emit(UserUpdated(response));
    } catch (e) {
      final exception = ExceptionHandler.handleError(e);
      _handleError(exception, emit);
    }
  }

  Future<void> _changePassword(
    ChangePasswordEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      await changePasswordUsecase(event.oldPassword, event.newPassword);
      emit(PasswordChanged(message: "Successfully updated password"));
    } catch (e) {
      final exception = ExceptionHandler.handleError(e);
      if (exception is UnAuthorizedException) {
        emit(PasswordChangeError(message: exception.message));
      } else {
        _handleError(exception, emit);
      }
    }
  }

  void _handleError(AppException exception, Emitter<UserState> emit) {
    switch (exception.runtimeType) {
      case NotFoundException:
        emit(UserNotFound(message: exception.message));
        break;
      case UnAuthorizedException:
        emit(UserUnauthorized(message: exception.message));
        break;
      case BadRequestException:
        emit(UserValidationError(message: exception.message));
        break;
      case ConflictException:
        emit(UserConflictError(message: exception.message));
        break;
      default:
        emit(UserError(exception.message));
    }
  }

  Future<void> _uploadProfilePic(
    UploadProfilePicEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(ImageFileUploadLoading());
    try {
      final response = await uploadProfilePicUsecase(event.imageFile);
      emit(
        ImageFileUploadSucess(message: "Profile picture updated successfully"),
      );
    } catch (e) {
      final exception = ExceptionHandler.handleError(e);
      emit(ImageFileUploadFailure(error: exception.message));
    }
  }
}

