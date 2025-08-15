import 'dart:io';
import 'package:dio/dio.dart'; // Use Dio
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:recipe_advisor_app/api/dio_client.dart';
import '../models/user_model.dart';

class AuthApiService {
  final _secureStorage = const FlutterSecureStorage();
  late final Dio _dio;
  // Separate Dio instance for the refresh token call to avoid interceptor loops.
  late final Dio _dioForRefresh;

  AuthApiService() {
    _dio = DioClient(this).instance;
    // This is a clean Dio instance without interceptors.
    _dioForRefresh = Dio(BaseOptions(
      baseUrl: dotenv.env['API_BASE_URL'] ?? 'http://localhost:8000/api/v1',
    ));
    _dioForRefresh.options.headers['X-API-Key'] =
        dotenv.env['RECIPE_API_KEY'] ?? '';
  }

  /// Fetches the user's profile. The interceptor handles auth.
  Future<UserResponse> getCurrentUser() async {
    try {
      final response = await _dio.get('/users/me/');
      return UserResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['detail'] ?? 'Failed to fetch user data.');
    }
  }

  /// Logs in a user and stores tokens.
  Future<void> loginUser(
      {required String username, required String password}) async {
    try {
      final response = await _dio.post(
        '/auth/login/',
        data: {'username': username, 'password': password},
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      await _secureStorage.write(
          key: 'access_token', value: response.data['access_token']);
      await _secureStorage.write(
          key: 'refresh_token', value: response.data['refresh_token']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? 'Failed to login.');
    }
  }

  /// Registers a user, with an optional avatar.
  Future<UserResponse> registerUser(UserCreate user, {File? avatarFile}) async {
    try {
      final formData = FormData.fromMap({
        ...user.toJson(), // Spread the user data as form fields
        if (avatarFile != null)
          'avatar': await MultipartFile.fromFile(avatarFile.path),
      });

      final response = await _dio.post('/users/register/', data: formData);
      return UserResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? 'Failed to register.');
    }
  }

  /// Refreshes the access token using a clean Dio instance.
  Future<String?> refreshToken() async {
    final refreshToken = await _secureStorage.read(key: 'refresh_token');
    if (refreshToken == null) {
      await logout();
      return null;
    }
    try {
      final response = await _dioForRefresh.post(
        '/auth/refresh/',
        data: {'refresh_token': refreshToken},
      );
      final newAccessToken = response.data['access_token'] as String;
      await _secureStorage.write(key: 'access_token', value: newAccessToken);
      return newAccessToken;
    } catch (_) {
      await logout();
      return null;
    }
  }

  // --- TOKEN HELPER METHODS (NO CHANGES NEEDED) ---
  Future<String?> getAccessToken() => _secureStorage.read(key: 'access_token');
  Future<bool> isLoggedIn() async =>
      (await _secureStorage.read(key: 'refresh_token')) != null;
  Future<void> logout() async {
    await _secureStorage.delete(key: 'access_token');
    await _secureStorage.delete(key: 'refresh_token');
  }
}
