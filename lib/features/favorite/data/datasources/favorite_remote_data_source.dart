import 'dart:convert';
import 'package:fuel_finder/core/utils/exception_handler.dart';
import 'package:http/http.dart' as http;
import 'package:fuel_finder/core/exceptions/app_exceptions.dart';
import 'package:fuel_finder/core/utils/token_services.dart';

class FavoriteRemoteDataSource {
  final String baseurl = "https://fuel-finder-backend.onrender.com/api";
  final TokenService tokenService;

  FavoriteRemoteDataSource({required this.tokenService});

  Future<void> setFavorite(String stationId) async {
    try {
      final token = await tokenService.getAuthToken();
      final response = await http
          .post(
            Uri.parse('$baseurl/favorite'),
            body: jsonEncode({"station_id": stationId}),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 30));

      _handleResponse(response);
    } on SocketException catch (e) {
      throw NoInternetException(message: 'Failed to connect to server');
    } catch (e) {
      throw ExceptionHandler.handleError(e);
    }
  }

  Future<void> removeFavorite(String stationId) async {
    try {
      final token = await tokenService.getAuthToken();
      final response = await http
          .delete(
            Uri.parse('$baseurl/favorite/$stationId'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 30));

      _handleResponse(response);
    } on SocketException catch (e) {
      throw NoInternetException(message: 'Failed to connect to server');
    } catch (e) {
      throw ExceptionHandler.handleError(e);
    }
  }

  Future<Map<String, dynamic>> getFavorites() async {
    try {
      final token = await tokenService.getAuthToken();
      final response = await http
          .get(
            Uri.parse('$baseurl/favorite/user'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on SocketException catch (e) {
      throw NoInternetException(message: 'Failed to connect to server');
    } catch (e) {
      throw ExceptionHandler.handleError(e);
    }
  }

  dynamic _handleResponse(http.Response response) {
    try {
      final responseData = jsonDecode(response.body);

      switch (response.statusCode) {
        case 200:
        case 201:
          return responseData;
        case 400:
          throw BadRequestException(message: responseData['message']);
        case 401:
        case 403:
          throw UnAuthorizedException(message: responseData['message']);
        case 404:
          throw NotFoundException(message: responseData['message']);
        case 409:
          throw ConflictException(message: responseData['message']);
        case 422:
          throw InvalidInputException(message: responseData['message']);
        case 500:
          throw ServerErrorException(message: responseData['message']);
        default:
          throw FetchDataException(
            message: 'Error occurred while communication with server',
          );
      }
    } on FormatException {
      throw FetchDataException(message: 'Invalid server response format');
    }
  }
}

