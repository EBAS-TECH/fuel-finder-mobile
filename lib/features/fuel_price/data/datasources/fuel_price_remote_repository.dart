import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fuel_finder/core/utils/exception_handler.dart';
import 'package:http/http.dart' as http;
import 'package:fuel_finder/core/exceptions/app_exceptions.dart';
import 'package:fuel_finder/core/utils/token_services.dart';

class FuelPriceRemoteRepository {
  final String baseUrl = "http://192.168.230.78:5001/api";
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

      return _handleResponse(response);
    } catch (e) {
      final exception = ExceptionHandler.handleError(e);
      throw ExceptionHandler.getErrorMessage(exception);
    }
  }

  dynamic _handleResponse(http.Response response) {
    final responseData = jsonDecode(response.body);
    debugPrint("Fuel Price ResponseData: $responseData");

    switch (response.statusCode) {
      case 200:
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
          message: responseData['message'] ?? 'Fuel prices not found',
        );
      case 500:
        throw ServerErrorException(
          message: responseData['message'] ?? 'Server error',
        );
      default:
        throw FetchDataException(
          message:
              responseData['message'] ??
              'Error occurred while fetching fuel prices',
        );
    }
  }
}

