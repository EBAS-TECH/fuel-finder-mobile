import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:fuel_finder/core/utils/token_services.dart';

class FuelPriceRemoteRepository {
  final String baseUrl = "http://192.168.230.150:5001/api";
  final TokenService tokenService;
  FuelPriceRemoteRepository({required this.tokenService});
  Future<Map<String, dynamic>> getFuelPrice() async {
    try {
      final token = await tokenService.getAuthToken();
      final response = await http.get(
        Uri.parse('$baseUrl/price'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      final responseData = jsonDecode(response.body);
      debugPrint("Fuel Price ResponseData: $responseData");
      return responseData;
    } catch (e) {
      throw e.toString();
    }
  }
}

