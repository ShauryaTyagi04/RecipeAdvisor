import 'package:dio/dio.dart'; // Use Dio
import 'package:flutter/foundation.dart';
import 'package:recipe_advisor_app/api/auth_api_service.dart';
import 'package:recipe_advisor_app/api/dio_client.dart';
import '../models/recipe_model.dart';

class RecipeApiService {
  late final Dio _dio;

  RecipeApiService(AuthApiService authService) {
    // It uses the same DioClient, getting the authService passed in.
    _dio = DioClient(authService).instance;
  }

  Future<Recipe> queryAgent(String query) async {
    debugPrint('[API Call] Attempting to POST to: /recipes/query/');
    try {
      final response = await _dio.post(
        '/recipes/query/',
        data: {'query': query},
      );
      debugPrint('[API Call] Success! Response body: ${response.data}');
      return Recipe.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('[API Call] Failed! Server returned error: ${e.message}');
      throw Exception(e.response?.data['detail'] ?? 'Failed to load recipe.');
    }
  }
}
