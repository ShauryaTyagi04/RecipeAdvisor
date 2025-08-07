import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/user_model.dart';

class AuthApiService {
  final String _baseUrl =
      dotenv.env['API_BASE_URL'] ?? 'http://localhost:8000/api/v1';
  final String _apiKey = dotenv.env['RECIPE_API_KEY'] ?? '';

  // --- UNIFIED REGISTRATION METHOD ---
  // This single method handles registration with or without an avatar.
  Future<UserResponse> registerUser(UserCreate user, {File? avatarFile}) async {
    final Uri url = Uri.parse('$_baseUrl/users/register/');
    debugPrint('[API Call] POST multipart request to: $url');

    try {
      // Always create a MultipartRequest.
      var request = http.MultipartRequest('POST', url);

      // Add the API key to the headers.
      request.headers['X-API-Key'] = _apiKey;

      // Add all text fields from the user model.
      request.fields.addAll(
        user.toJson().map((key, value) => MapEntry(key, value.toString())),
      );

      // --- OPTIONALLY ADD THE IMAGE FILE ---
      // If an avatar file is provided, add it to the request.
      // If not, this part is skipped, and no file is sent.
      if (avatarFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('avatar', avatarFile.path),
        );
      }

      // Send the request and handle the response.
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint('[API Call] Response status code: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserResponse.fromJson(jsonDecode(response.body));
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['detail'] ?? 'Failed to register.');
      }
    } catch (e) {
      debugPrint('[API Call] Error caught: $e');
      rethrow;
    }
  }
}
