import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthApiService {
  final String _baseUrl =
      dotenv.env['API_BASE_URL'] ?? 'http://localhost:8000/api/v1';
  final String _apiKey = dotenv.env['RECIPE_API_KEY'] ?? '';
  final _secureStorage = const FlutterSecureStorage();

  // --- MODIFIED LOGIN METHOD ---
  Future<void> loginUser({
    required String username,
    required String password,
  }) async {
    final Uri url = Uri.parse('$_baseUrl/auth/login/');
    debugPrint('[API Call] POST to: $url');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'X-API-Key': _apiKey,
        },
        body: {'username': username, 'password': password},
      );

      debugPrint('[API Call] Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final accessToken = data['access_token'] as String?;
        final refreshToken = data['refresh_token'] as String?;

        if (accessToken == null || refreshToken == null) {
          throw Exception('Tokens not found in response.');
        }

        // --- STORE BOTH TOKENS SECURELY ---
        await _secureStorage.write(key: 'access_token', value: accessToken);
        await _secureStorage.write(key: 'refresh_token', value: refreshToken);
        debugPrint('Login successful. Both tokens stored.');
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['detail'] ?? 'Failed to login.');
      }
    } catch (e) {
      debugPrint('[API Call] Error during login: $e');
      rethrow;
    }
  }

  Future<bool> isLoggedIn() async {
    final refreshToken = await _secureStorage.read(key: 'refresh_token');
    // The user is considered logged in if the refresh token is present and not empty.
    return refreshToken != null && refreshToken.isNotEmpty;
  }

  // --- NEW REFRESH TOKEN METHOD ---
  Future<String?> refreshToken() async {
    final refreshToken = await _secureStorage.read(key: 'refresh_token');
    if (refreshToken == null) {
      // If there's no refresh token, the user must log in again.
      await logout(); // Clean up any lingering tokens
      return null;
    }

    final Uri url = Uri.parse('$_baseUrl/auth/refresh/');
    debugPrint('[API Call] Refreshing token at: $url');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'X-API-Key': _apiKey,
        },
        body: jsonEncode({'refresh_token': refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newAccessToken = data['access_token'] as String;

        // Store the new access token
        await _secureStorage.write(key: 'access_token', value: newAccessToken);
        debugPrint('Access token refreshed successfully.');
        return newAccessToken;
      } else {
        // If the refresh token is expired or invalid, log the user out.
        await logout();
        return null;
      }
    } catch (e) {
      debugPrint('[API Call] Error refreshing token: $e');
      await logout();
      return null;
    }
  }

  // --- UPDATED HELPER METHODS ---
  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: 'access_token');
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: 'access_token');
    await _secureStorage.delete(key: 'refresh_token');
  }

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
