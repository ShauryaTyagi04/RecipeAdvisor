import 'package:flutter/material.dart';
import 'package:recipe_advisor_app/api/auth_api_service.dart';
import 'package:recipe_advisor_app/models/user_model.dart';

class UserProvider with ChangeNotifier {
  final AuthApiService _authService = AuthApiService();

  UserResponse? _user;
  UserResponse? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Fetches the current user's data from the API and updates the state.
  Future<void> fetchCurrentUser() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      _user = await _authService.getCurrentUser();
    } catch (e) {
      // If fetching fails (e.g., token expired), clear the user data.
      debugPrint("Error fetching user: $e");
      _user = null;
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify UI that loading is complete.
    }
  }
}
