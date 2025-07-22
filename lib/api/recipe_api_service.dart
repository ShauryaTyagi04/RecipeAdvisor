import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/recipe_model.dart';

class RecipeApiService {
  final String _baseUrl = dotenv.env['API_BASE_URL'] ?? 'http://localhost:8000';
  final String _apiKey = dotenv.env['RECIPE_API_KEY'] ?? '';

  Future<Recipe> queryAgent(String query) async {
    final Uri url = Uri.parse('$_baseUrl/query/');

    // Add logging to see what's happening
    debugPrint('[API Call] Attempting to POST to: $url');
    debugPrint('[API Call] Sending query: $query');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'X-API-Key': _apiKey,
        },
        body: jsonEncode(<String, String>{
          'query': query,
        }),
      );

      debugPrint('[API Call] Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        debugPrint('[API Call] Success! Response body: ${response.body}');
        return Recipe.fromJson(jsonDecode(response.body));
      } else {
        debugPrint('[API Call] Failed! Server returned error.');
        throw Exception(
            'Failed to load recipe. Status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('[API Call] Error caught: $e');
      throw Exception('Failed to connect to the recipe service.');
    }
  }
}
