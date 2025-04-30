import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:fuel_finder/core/utils/token_services.dart';
import 'package:http/http.dart' as http;

class GasStationRemoteDataSource {
  final String baseUrl = "http://192.168.230.179:5001/api";
  final TokenService tokenService;

  GasStationRemoteDataSource({required this.tokenService});
  Future<Map<String, dynamic>> getGasStations() async {
    final token = await tokenService.getAuthToken();
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/station'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      final responseData = jsonDecode(response.body);
      debugPrint("ResponseData: $responseData");
      return responseData;
    } catch (e) {
      throw e.toString();
    }
  }
}

