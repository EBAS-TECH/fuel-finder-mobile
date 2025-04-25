import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:fuel_finder/features/auth/data/models/user_model.dart';
import 'package:http/http.dart' as http;

class AuthRemoteDataSource {
  final String baseUrl = "http://192.168.70.147:5001/api/auth";
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
      debugPrint("SIGNUP RESPONSE: ${jsonDecode(response.body)}");
      return jsonDecode(response.body);
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("SIGN UP FAILED: $e");
    }
  }

  Future<UserModel> signIn(String userName, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        body: jsonEncode({"username": userName, "password": password}),
        headers: {"Content-Type": "application/json"},
      );
      debugPrint("LOGIN RESPONSE: ${jsonDecode(response.body)}");
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception("SIGN IN FAILED: $e");
    }
  }

  Future<void> logOut() async {
    try {
      final response = http.post(Uri.parse("$baseUrl/logout"));
      debugPrint(jsonDecode(response.toString()));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> verifyEmail(String? userId, String token) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/verify/$userId"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"token": token}),
      );

      final responseBody = json.decode(response.body);
      debugPrint("Verification response: $responseBody");

      if (response.statusCode == 200) {
        return;
      } else {
        final errorMessage =
            responseBody["message"] ?? "Email verification failed";
        throw errorMessage;
      }
    } catch (e) {
      debugPrint("Verification error: $e");
      throw e.toString();
    }
  }
}

