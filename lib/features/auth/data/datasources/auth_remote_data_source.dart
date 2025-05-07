import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fuel_finder/core/exceptions/app_exceptions.dart';
import 'package:fuel_finder/core/utils/exception_handler.dart';

class AuthRemoteDataSource {
  final String baseUrl = "https://fuel-finder-backend.onrender.com/api/auth";

  Future<Map<String, dynamic>> signUp(
    String firstName,
    String lastName,
    String userName,
    String email,
    String password,
    String role,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/signup'),
        body: jsonEncode({
          "first_name": firstName,
          "last_name": lastName,
          "username": userName,
          "password": password,
          "email": email,
          "role": role,
        }),
        headers: {"Content-Type": "application/json"},
      ).timeout(const Duration(seconds: 30));

      final responseData = jsonDecode(response.body);

      switch (response.statusCode) {
        case 201:
          return responseData;
        case 400:
          throw BadRequestException(message: responseData['error']);
        case 401:
          throw UnAuthorizedException(message: responseData['error']);
        case 404:
          throw NotFoundException(message: responseData['error']);
        case 409:
          throw ConflictException(message: responseData['error']);
        case 500:
          throw ServerErrorException(message: responseData['error']);
        default:
          throw FetchDataException(
            message: 'Error occurred while communicating with server',
          );
      }
    } on http.ClientException catch (e) {
      throw FetchDataException(message: e.message);
    } on FormatException catch (_) {
      throw FormatException(message: 'Invalid response format');
    } catch (e) {
      throw ExceptionHandler.handleError(e);
    }
  }

  Future<Map<String, dynamic>> signIn(String userName, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        body: jsonEncode({"username": userName, "password": password}),
        headers: {"Content-Type": "application/json"},
      ).timeout(const Duration(seconds: 30));

      final responseData = jsonDecode(response.body);

      switch (response.statusCode) {
        case 200:
          return responseData;
        case 400:
          throw BadRequestException(message: responseData['error']);
        case 401:
          throw UnAuthorizedException(message: responseData['error']);
        case 404:
          throw NotFoundException(message: responseData['error']);
        case 500:
          throw ServerErrorException(message: responseData['error']);
        default:
          throw FetchDataException(
            message: 'Error occurred while communicating with server',
          );
      }
    } on http.ClientException catch (e) {
      throw FetchDataException(message: e.message);
    } on FormatException catch (_) {
      throw FormatException(message: 'Invalid response format');
    } catch (e) {
      throw ExceptionHandler.handleError(e);
    }
  }

  Future<void> logOut() async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/logout"),
        headers: {"Content-Type": "application/json"},
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        throw FetchDataException(message: 'Logout failed');
      }
    } catch (e) {
      throw ExceptionHandler.handleError(e);
    }
  }

  Future<void> verifyEmail(String userId, String token) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/verify/$userId"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"token": token}),
      ).timeout(const Duration(seconds: 30));

      final responseBody = json.decode(response.body);

      switch (response.statusCode) {
        case 200:
          return;
        case 400:
          throw BadRequestException(message: responseBody['message']);
        case 401:
          throw UnAuthorizedException(message: responseBody['message']);
        case 404:
          throw NotFoundException(message: responseBody['message']);
        case 500:
          throw ServerErrorException(message: responseBody['message']);
        default:
          throw FetchDataException(
            message: 'Error occurred while verifying email',
          );
      }
    } catch (e) {
      throw ExceptionHandler.handleError(e);
    }
  }
}

