import 'dart:io';

abstract class UserEvent {}

class GetUserByIdEvent extends UserEvent {
  final String userId;

  GetUserByIdEvent({required this.userId});
}

class UpdateUserByIdEvent extends UserEvent {
  final String userId;
  final String firstName;
  final String lastName;
  final String userName;

  UpdateUserByIdEvent(
    this.firstName,
    this.lastName,
    this.userName,
    this.userId,
  );
}

class ChangePasswordEvent extends UserEvent {
  final String oldPassword;
  final String newPassword;

  ChangePasswordEvent({required this.oldPassword, required this.newPassword});
}

class UploadProfilePicEvent extends UserEvent {
  final File imageFile;

  UploadProfilePicEvent({required this.imageFile});
}
