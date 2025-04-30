import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class GasStationRemoteDataSource {
  final String baseUrl = "http://192.168.230.179:5001/api";
  Future<Map<String, dynamic>> getGasStations(String token) async {
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

