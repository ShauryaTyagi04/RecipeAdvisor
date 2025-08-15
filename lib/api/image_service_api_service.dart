import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:recipe_advisor_app/api/auth_api_service.dart';
import 'package:recipe_advisor_app/api/dio_client.dart';

class ImageRecipeApiService {
  late final Dio _dio;

  ImageRecipeApiService(AuthApiService authService) {
    // This service also uses the DioClient to handle authentication and errors.
    _dio = DioClient(authService).instance;
  }

  /// Sends an image file to the backend for recipe prediction.
  Future<String> predictRecipeFromImage(File imageFile) async {
    try {
      // Create FormData to send the image as a multipart file.
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last, // Use original filename
        ),
      });

      debugPrint(
          '[API Call] Sending image for prediction to: /image-recipes/predict/');

      // Make the POST request.
      final response = await _dio.post(
        '/image-recipes/predict/',
        data: formData,
      );

      debugPrint('[API Call] Image prediction response: ${response.data}');

      // Extract the predicted recipe name from the response.
      if (response.data != null && response.data['predicted_recipe'] != null) {
        return response.data['predicted_recipe'] as String;
      } else {
        throw Exception('Predicted recipe not found in response.');
      }
    } on DioException catch (e) {
      debugPrint('[API Call] Error during image prediction: ${e.message}');
      throw Exception(
          e.response?.data['detail'] ?? 'Failed to predict recipe from image.');
    } catch (e) {
      debugPrint('[API Call] Unexpected error: $e');
      throw Exception('An unexpected error occurred during image prediction.');
    }
  }
}
