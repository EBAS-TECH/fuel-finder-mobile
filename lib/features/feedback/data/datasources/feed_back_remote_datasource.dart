import 'dart:convert';

import 'package:fuel_finder/core/utils/exception_handler.dart';
import 'package:http/http.dart' as http;
import 'package:fuel_finder/core/exceptions/app_exceptions.dart';
import 'package:fuel_finder/core/utils/token_services.dart';

class FeedBackRemoteDatasource {
  final String baseUrl = 'http://192.168.230.78:5001/api';
  final TokenService tokenService;

  FeedBackRemoteDatasource({required this.tokenService});

  Future<void> createFeedback(
    String stationId,
    int rating,
    String comment,
  ) async {
    try {
      final token = await tokenService.getAuthToken();
      final response = await http.post(
        Uri.parse('$baseUrl/feedback'),
        body: jsonEncode({
          "station_id": stationId,
          "rating": rating,
          "comment": comment,
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      _handleResponse(response);
    } catch (e) {
      final exception = ExceptionHandler.handleError(e);
      throw ExceptionHandler.getErrorMessage(exception);
    }
  }

  Future<Map<String, dynamic>> getFeedBackByStationAndUser(
    String stationId,
  ) async {
    try {
      final userId = tokenService.getUserId();
      final token = await tokenService.getAuthToken();
      final response = await http.get(
        Uri.parse('$baseUrl/feedback/station/$stationId/user/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return _handleResponse(response);
    } catch (e) {
      final exception = ExceptionHandler.handleError(e);
      throw ExceptionHandler.getErrorMessage(exception);
    }
  }

  dynamic _handleResponse(http.Response response) {
    final responseData = jsonDecode(response.body);

    switch (response.statusCode) {
      case 200:
      case 201:
        return responseData;
      case 400:
        throw BadRequestException(
          message: responseData['message'] ?? 'Invalid request',
        );
      case 401:
      case 403:
        throw UnAuthorizedException(
          message: responseData['message'] ?? 'Unauthorized access',
        );
      case 404:
        throw NotFoundException(
          message: responseData['message'] ?? 'Feedback not found',
        );
      case 409:
        throw ConflictException(
          message: responseData['message'] ?? 'Conflict occurred',
        );
      case 422:
        throw InvalidInputException(
          message: responseData['message'] ?? 'Invalid input data',
        );
      case 500:
        throw ServerErrorException(
          message: responseData['message'] ?? 'Server error',
        );
      default:
        throw FetchDataException(
          message:
              responseData['message'] ??
              'Error occurred while communication with server',
        );
    }
  }
}

