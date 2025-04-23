abstract class Failure {}

class ServerFailure extends Failure {}
class NetworkFailure extends Failure {}
class ParsingFailure extends Failure {}
class UnknownFailure extends Failure {}

abstract class AppException implements Exception {
  final String message;
  AppException(this.message);
}

class ServerException extends AppException {
  ServerException(String message) : super(message);
}

class NetworkException extends AppException {
  NetworkException(String message) : super(message);
}

class ParsingException extends AppException {
  ParsingException(String message) : super(message);
}

class ConnectionException extends AppException {
  ConnectionException(String message) : super(message);
}

class BadRequestException extends AppException {
  BadRequestException(String message) : super(message);
}

class UnknownException extends AppException {
  UnknownException(String message) : super(message);
}