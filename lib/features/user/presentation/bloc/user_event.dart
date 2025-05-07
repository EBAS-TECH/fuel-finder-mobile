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

