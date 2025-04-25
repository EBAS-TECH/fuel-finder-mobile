abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserSucess extends UserState {
  final String message;
  final Map<String, dynamic> responseData;

  UserSucess(this.responseData, {required this.message});
}

class UserFailure extends UserState {
  final String error;

  UserFailure({required this.error});
}

