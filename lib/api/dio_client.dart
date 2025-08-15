import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:recipe_advisor_app/api/auth_api_service.dart';

class DioClient {
  final String _baseUrl =
      dotenv.env['API_BASE_URL'] ?? 'http://localhost:8000/api/v1';
  final String _apiKey = dotenv.env['RECIPE_API_KEY'] ?? '';

  late final Dio _dio;
  final AuthApiService _authService;

  DioClient(this._authService) {
    _dio = Dio(BaseOptions(baseUrl: _baseUrl));
    _dio.interceptors.add(
      InterceptorsWrapper(
        // This function runs before every request is sent.
        onRequest: (options, handler) async {
          options.headers['X-API-Key'] = _apiKey;
          final accessToken = await _authService.getAccessToken();
          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          return handler.next(options);
        },

        // This function runs only when an error occurs.
        onError: (DioException e, handler) async {
          // Check if it's a 401 error and not from the refresh endpoint.
          if (e.response?.statusCode == 401 &&
              !e.requestOptions.path.endsWith('/refresh/')) {
            debugPrint('Access token expired. Refreshing...');
            try {
              // Attempt to get a new access token.
              final newAccessToken = await _authService.refreshToken();
              if (newAccessToken != null) {
                // Update the failed request's header with the new token.
                e.requestOptions.headers['Authorization'] =
                    'Bearer $newAccessToken';
                // Retry the request. Dio will handle this for you.
                final response = await _dio.fetch(e.requestOptions);
                return handler.resolve(response);
              }
            } catch (_) {
              // If refresh fails, log out the user.
              await _authService.logout();
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  // A public getter to access the configured Dio instance.
  Dio get instance => _dio;
}
