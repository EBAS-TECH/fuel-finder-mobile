import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:fuel_finder/core/utils/exception_handler.dart';
import 'package:http/http.dart' as http;
import 'package:fuel_finder/core/exceptions/app_exceptions.dart';
import 'package:fuel_finder/core/utils/token_services.dart';

class GasStationRemoteDataSource {
  final String baseUrl = "http://192.168.230.78:5001/api";
  final TokenService tokenService;

  GasStationRemoteDataSource({required this.tokenService});

  Future<Map<String, dynamic>> getGasStations(
    String latitude,
    String longitude,
  ) async {
    try {
      final token = await tokenService.getAuthToken();
      final response = await http.post(
        Uri.parse('$baseUrl/station/near-station'),
        body: jsonEncode({"latitude": latitude, "longitude": longitude}),
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
    debugPrint("Gas Station ResponseData: $responseData");

    switch (response.statusCode) {
      case 200:
        return responseData;
      case 400:
        throw BadRequestException(
          message: responseData['message'] ?? 'Invalid location coordinates',
        );
      case 401:
      case 403:
        throw UnAuthorizedException(
          message:
              responseData['message'] ??
              'Unauthorized access to gas station data',
        );
      case 404:
        throw NotFoundException(
          message: responseData['message'] ?? 'No gas stations found nearby',
        );
      case 422:
        throw InvalidInputException(
          message:
              responseData['message'] ?? 'Invalid latitude/longitude format',
        );
      case 500:
        throw ServerErrorException(
          message: responseData['message'] ?? 'Failed to fetch gas stations',
        );
      default:
        throw FetchDataException(
          message:
              responseData['message'] ??
              'Error occurred while fetching gas stations',
        );
    }
  }
}

