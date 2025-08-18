import 'package:dio/dio.dart'; // Use Dio
import 'package:flutter/foundation.dart';
import 'package:recipe_advisor_app/api/auth_api_service.dart';
import 'package:recipe_advisor_app/api/dio_client.dart';
import '../models/recipe_model.dart';

class RecipeApiService {
  late final Dio _dio;

  RecipeApiService(AuthApiService authService) {
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

  Future<Recipe> createRecipe(Recipe recipe) async {
    try {
      final response = await _dio.post('/recipes/', data: recipe.toJson());
      return Recipe.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? 'Failed to create recipe.');
    }
  }

  Future<Recipe> createAiRecipe(Recipe recipe) async {
    try {
      final response =
          await _dio.post('/recipes/ai-generated/', data: recipe.toJson());
      return Recipe.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? 'Failed to create recipe.');
    }
  }

  Future<void> saveRecipe(int recipeId) async {
    try {
      // Expecting a 204 No Content response on success
      await _dio.post('/users/me/liked-recipes/$recipeId');
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? 'Failed to save recipe.');
    }
  }

  Future<void> unsaveRecipe(int recipeId) async {
    try {
      await _dio.delete('/users/me/liked-recipes/$recipeId');
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? 'Failed to unsave recipe.');
    }
  }

  Future<List<Recipe>> getSavedRecipes() async {
    try {
      final response = await _dio.get('/users/me/liked-recipes/');
      return (response.data as List)
          .map((recipeJson) => Recipe.fromJson(recipeJson))
          .toList();
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['detail'] ?? 'Failed to get saved recipes.');
    }
  }

  Future<List<Recipe>> getCreatedRecipes() async {
    try {
      final response = await _dio.get('/users/me/created-recipes/');
      return (response.data as List)
          .map((recipeJson) => Recipe.fromJson(recipeJson))
          .toList();
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['detail'] ?? 'Failed to get created recipes.');
    }
  }

  Future<void> updateLikedRecipesOrder(List<int> orderedRecipeIds) async {
    try {
      await _dio.put(
        '/users/me/liked-recipes/order',
        data: {'ordered_ids': orderedRecipeIds},
      );
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['detail'] ?? 'Failed to update recipe order.');
    }
  }

  Future<void> deleteRecipe(int recipeId) async {
    try {
      // Calls the new endpoint we created in the backend.
      await _dio.delete('/recipes/$recipeId');
    } on DioException catch (e) {
      // Provide a more specific error message.
      throw Exception(e.response?.data['detail'] ?? 'Failed to delete recipe.');
    }
  }
}
