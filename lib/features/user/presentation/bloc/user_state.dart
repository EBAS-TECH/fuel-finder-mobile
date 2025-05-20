abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserSuccess extends UserState {
  final Map<String, dynamic> responseData;
  final String message;

  UserSuccess(this.responseData, {required this.message});
}

class UserLoaded extends UserState {
  final Map<String, dynamic> userData;

  UserLoaded(this.userData);
}

class PasswordChanged extends UserState {
  final String message;

  PasswordChanged({required this.message});
}

class UserError extends UserState {
  final String message;

  UserError(this.message);
}

class UserUpdated extends UserState {
  final Map<String, dynamic> userData;

  UserUpdated(this.userData);
}

class UserNotFound extends UserState {
  final String message;

  UserNotFound({required this.message});
}

class PasswordChangeError extends UserState {
  final String message;

  PasswordChangeError({required this.message});
}

class UserUnauthorized extends UserState {
  final String message;

  UserUnauthorized({required this.message});
}

class UserValidationError extends UserState {
  final String message;

  UserValidationError({required this.message});
}

class UserConflictError extends UserState {
  final String message;

  UserConflictError({required this.message});
}

class UserNetworkError extends UserState {
  final String message;

  UserNetworkError({required this.message});
}

class UserTimeoutError extends UserState {
  final String message;

  UserTimeoutError({required this.message});
}

class UserServerError extends UserState {
  final String message;

  UserServerError({required this.message});
}

class UserFailure extends UserState {
  final String error;

  UserFailure({required this.error});
}

class UserUpdatePasswordSucess extends UserState {
  final String message;

  UserUpdatePasswordSucess({required this.message});
}

class UserUpdatePasswordFailure extends UserState {
  final String error;

  UserUpdatePasswordFailure({required this.error});
}

class ImageFileUploadSucess extends UserState {
  final String message;

  ImageFileUploadSucess({required this.message});
}

class ImageFileUploadFailure extends UserState {
  final String error;

  ImageFileUploadFailure({required this.error});
}

class ImageFileUploadLoading extends UserState {}

