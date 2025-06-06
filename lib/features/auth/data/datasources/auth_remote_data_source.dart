import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fuel_finder/core/utils/token_services.dart';
import 'package:http/http.dart' as http;
import 'package:fuel_finder/core/exceptions/app_exceptions.dart';
import 'package:fuel_finder/core/utils/exception_handler.dart';

class AuthRemoteDataSource {
  final String baseUrl = "${dotenv.get("BASE_URL")}/auth";
  final TokenService tokenService;

  AuthRemoteDataSource({required this.tokenService});

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
      );

      final responseData = jsonDecode(response.body);
      print(responseData);

      switch (response.statusCode) {
        case 201:
          return responseData;
        case 400:
          throw BadRequestException(
            message:
                responseData['error'] ??
                responseData['message'] ??
                'Bad request',
          );
        case 401:
          throw UnAuthorizedException(
            message:
                responseData['error'] ??
                responseData['message'] ??
                'Unauthorized',
          );
        case 404:
          throw NotFoundException(
            message:
                responseData['error'] ?? responseData['message'] ?? 'Not found',
          );
        case 409:
          throw ConflictException(
            message:
                responseData['error'] ??
                responseData['message'] ??
                'User already exists',
          );
        case 500:
          throw ServerErrorException(
            message:
                responseData['error'] ??
                responseData['message'] ??
                'Server error',
          );
        default:
          throw FetchDataException(
            message:
                responseData['error'] ??
                responseData['message'] ??
                'Error occurred while communicating with server',
          );
      }
    } on http.ClientException catch (e) {
      throw FetchDataException(message: 'Network error: ${e.message}');
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
      );

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
      );

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
      );

      final responseBody = json.decode(response.body);
      print(userId);
      print(token);
      print(responseBody);

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

  Future<void> resendCode(String userId) async {
    try {
      final token = await tokenService.getAuthToken();
      final response = await http.get(
        Uri.parse("$baseUrl/resend/$userId"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

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

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/forgot"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      final responseBody = json.decode(response.body);

      switch (response.statusCode) {
        case 200:
          return responseBody;
        case 400:
          throw BadRequestException(message: responseBody['message']);
        case 404:
          throw NotFoundException(message: responseBody['message']);
        case 500:
          throw ServerErrorException(message: responseBody['message']);
        default:
          throw FetchDataException(
            message: 'Error occurred while processing forgot password',
          );
      }
    } catch (e) {
      throw ExceptionHandler.handleError(e);
    }
  }

  Future<Map<String, dynamic>> forgotVerify(String userId, String code) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/forgot/verify/$userId"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"token": code}),
      );

      final responseBody = json.decode(response.body);

      switch (response.statusCode) {
        case 200:
          return responseBody;
        case 400:
          throw BadRequestException(message: responseBody['message']);
        case 404:
          throw NotFoundException(message: responseBody['message']);
        case 500:
          throw ServerErrorException(message: responseBody['message']);
        default:
          throw FetchDataException(
            message: 'Error occurred while verifying forgot password code',
          );
      }
    } catch (e) {
      throw ExceptionHandler.handleError(e);
    }
  }

  Future<Map<String, dynamic>> setNewPassword(
    String userId,
    String newPassword,
  ) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/new-password/$userId"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"new_password": newPassword}),
      );

      final responseBody = json.decode(response.body);
      switch (response.statusCode) {
        case 200:
          return responseBody;
        case 400:
          throw BadRequestException(message: responseBody['message']);
        case 404:
          throw NotFoundException(message: responseBody['message']);
        case 500:
          throw ServerErrorException(message: responseBody['message']);
        default:
          throw FetchDataException(
            message: 'Error occurred while setting new password',
          );
      }
    } catch (e) {
      throw ExceptionHandler.handleError(e);
    }
  }
}

