import 'package:fuel_finder/core/exceptions/app_exceptions.dart';

class ExceptionHandler {
  static AppException handleError(dynamic error) {
    if (error is AppException) {
      return error;
    } else if (error is FormatException) {
      return FormatException(message: error.message);
    } else if (error is SocketException) {
      return SocketException(message: error.message);
    } else if (error is TimeoutException) {
      return TimeoutException(message: error.message);
    } else if (error is String) {
      return _parseStringError(error);
    } else {
      return UnknownException(message: error.toString());
    }
  }

  static AppException _parseStringError(String error) {
    if (error.contains('No Internet')) {
      return SocketException();
    } else if (error.contains('Unauthorized')) {
      return UnAuthorizedException();
    } else if (error.contains('Bad Request')) {
      return BadRequestException();
    } else if (error.contains('Not Found')) {
      return NotFoundException();
    } else if (error.contains('Timeout')) {
      return TimeoutException();
    } else if (error.contains('Conflict')) {
      return ConflictException();
    } else if (error.contains('Server Error')) {
      return ServerErrorException();
    } else if (error.contains('Format')) {
      return FormatException();
    } else {
      return UnknownException(message: error);
    }
  }

  static String getErrorMessage(AppException exception) {
    return exception.message;
  }
}

