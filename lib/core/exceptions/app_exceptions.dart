class AppException implements Exception {
  final String message;
  final String prefix;
  final String? url;

  AppException({required this.message, required this.prefix, this.url});
}

class BadRequestException extends AppException {
  BadRequestException({String? message, super.url})
    : super(message: message ?? 'Bad request', prefix: 'Bad Request');
}

class FetchDataException extends AppException {
  FetchDataException({String? message, super.url})
    : super(
        message: message ?? 'Unable to process',
        prefix: 'Unable to process',
      );
}

class ApiNotRespondingException extends AppException {
  ApiNotRespondingException({String? message, super.url})
    : super(
        message: message ?? 'Api not responded in time',
        prefix: 'Api not responded',
      );
}

class UnAuthorizedException extends AppException {
  UnAuthorizedException({String? message, super.url})
    : super(message: message ?? 'Unauthorized request', prefix: 'Unauthorized');
}

class NotFoundException extends AppException {
  NotFoundException({String? message, super.url})
    : super(
        message: message ?? 'Requested resource not found',
        prefix: 'Not Found',
      );
}

class ConflictException extends AppException {
  ConflictException({String? message, super.url})
    : super(message: message ?? 'Conflict occurred', prefix: 'Conflict');
}

class InvalidInputException extends AppException {
  InvalidInputException({String? message, super.url})
    : super(message: message ?? 'Invalid input', prefix: 'Invalid Input');
}

class SocketException extends AppException {
  SocketException({String? message, super.url})
    : super(
        message: message ?? 'No internet connection',
        prefix: 'No Internet',
      );
}

class TimeoutException extends AppException {
  TimeoutException({String? message, super.url})
    : super(message: message ?? 'Request timeout', prefix: 'Timeout');
}

class ServerErrorException extends AppException {
  ServerErrorException({String? message, super.url})
    : super(
        message: message ?? 'Internal server error',
        prefix: 'Server Error',
      );
}

class FormatException extends AppException {
  FormatException({String? message, super.url})
    : super(message: message ?? 'Data format error', prefix: 'Format Error');
}

class UnknownException extends AppException {
  UnknownException({String? message, super.url})
    : super(
        message: message ?? 'Unknown error occurred',
        prefix: 'Unknown Error',
      );
}

class NoInternetException extends AppException {
  NoInternetException({required String message})
    : super(message: message, prefix: "No internet connection");
}

