import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:fuel_finder/core/utils/token_services.dart';

class FavoriteRemoteDataSource {
  final baseurl = "http://192.168.230.196:5001/api";
  final TokenService tokenService;
  FavoriteRemoteDataSource({required this.tokenService});

  Future<void> setFavorite(String stationId) async {
    try {
      final token = await tokenService.getAuthToken();
      final response = await http.post(
        Uri.parse('$baseurl/favorite'),
        body: jsonEncode({"station_id": stationId}),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode != 201) {
        throw 'Failed to set favorite: ${response.body}';
      }
    } catch (e) {
      throw 'Failed to set favorite: ${e.toString()}';
    }
  }

  Future<void> removeFavorite(String stationId) async {
    try {
      final token = await tokenService.getAuthToken();
      final response = await http.delete(
        Uri.parse('$baseurl/favorite'),
        body: jsonEncode({"station_id": stationId}),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode != 201) {
        throw 'Failed to remove favorite: ${response.body}';
      }
    } catch (e) {
      throw 'Failed to remove favorite: ${e.toString()}';
    }
  }

  Future<Map<String, dynamic>> getFavorites() async {
    try {
      final token = await tokenService.getAuthToken();
      final response = await http.get(
        Uri.parse('$baseurl/favorite/user'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      final responseData = jsonDecode(response.body);
      print("Favorite ResponseData: $responseData");
      return responseData;
    } catch (e) {
      throw 'Failed to get favorite: ${e.toString()}';
    }
  }
}

