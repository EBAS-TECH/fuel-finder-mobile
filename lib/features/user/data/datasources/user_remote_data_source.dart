import 'dart:convert';

import 'package:http/http.dart' as http;

class UserRemoteDataSource {
  final String baseUrl = "http://192.168.70.211:5001/api/user";

  Future<Map<String, dynamic>> getUserById(String userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$userId'));
      final responseData = jsonDecode(response.body);
      print('ResponseData $responseData');
      return responseData;
    } catch (e) {
      throw e.toString();
    }
  }
}

