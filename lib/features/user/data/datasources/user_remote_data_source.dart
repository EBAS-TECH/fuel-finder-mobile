import 'dart:convert';

import 'package:fuel_finder/core/utils/token_services.dart';
import 'package:http/http.dart' as http;

class UserRemoteDataSource {
  final String baseUrl = "http://192.168.230.14:5001/api/user";
  final TokenService tokenService;

  UserRemoteDataSource({required this.tokenService});

  Future<Map<String, dynamic>> getUserById(String userId) async {
    try {
      final token = await tokenService.getAuthToken();

      final response = await http.get(
        Uri.parse('$baseUrl/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw 'Failed to fetch user: ${response.statusCode}';
      }

      final responseData = jsonDecode(response.body);
      return responseData;
    } catch (e) {
      throw 'Failed to fetch user: ${e.toString()}';
    }
  }
}

