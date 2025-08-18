import 'package:flutter/foundation.dart';
import 'package:recipe_advisor_app/api/auth_api_service.dart';
import 'package:recipe_advisor_app/api/recipe_api_service.dart';
import 'package:recipe_advisor_app/models/recipe_model.dart';
import 'dart:collection';

class LikedRecipesProvider with ChangeNotifier {
  final RecipeApiService _recipeApiService = RecipeApiService(AuthApiService());

  Set<int> _likedRecipeIds = {};
  final Map<int, Recipe> _likedRecipesMap = {};

  UnmodifiableSetView<int> get likedRecipeIds =>
      UnmodifiableSetView(_likedRecipeIds);
  UnmodifiableMapView<int, Recipe> get likedRecipesMap =>
      UnmodifiableMapView(_likedRecipesMap);

  bool isLiked(int recipeId) {
    return _likedRecipeIds.contains(recipeId);
  }

  Future<void> fetchLikedRecipes() async {
    try {
      final likedRecipes = await _recipeApiService.getSavedRecipes();
      _likedRecipeIds.clear();
      _likedRecipesMap.clear();
      for (var recipe in likedRecipes) {
        if (recipe.id != null) {
          _likedRecipeIds.add(recipe.id!);
          _likedRecipesMap[recipe.id!] = recipe;
        }
      }
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to fetch liked recipes: $e");
    }
  }

  // --- 1. THE FIRST FIX: Update the map when saving a new recipe ---
  Future<Recipe> saveAndLikeNewRecipe(Recipe newRecipe) async {
    try {
      final savedRecipe = await _recipeApiService.createRecipe(newRecipe);
      if (savedRecipe.id == null) {
        throw Exception("Failed to get an ID for the newly saved recipe.");
      }
      await _recipeApiService.saveRecipe(savedRecipe.id!);

      // Add to both the set and the map to maintain consistency.
      _likedRecipeIds.add(savedRecipe.id!);
      _likedRecipesMap[savedRecipe.id!] = savedRecipe; // This line was missing.

      notifyListeners();
      return savedRecipe;
    } catch (e) {
      debugPrint("Error in saveAndLikeNewRecipe: $e");
      rethrow;
    }
  }

  Future<Recipe> saveAndLikeAiRecipe(Recipe aiRecipe) async {
    try {
      final savedRecipe = await _recipeApiService.createAiRecipe(aiRecipe);
      if (savedRecipe.id == null) {
        throw Exception("Failed to get an ID for the newly saved AI recipe.");
      }
      // Like the recipe immediately after creation
      await toggleLikeStatus(savedRecipe.id!);
      return savedRecipe;
    } catch (e) {
      debugPrint("Error in saveAndLikeAiRecipe: $e");
      rethrow;
    }
  }

  // --- 2. THE SECOND FIX: Remove from the map when unliking ---
  Future<void> toggleLikeStatus(int recipeId) async {
    final currentlyLiked = isLiked(recipeId);

    try {
      if (currentlyLiked) {
        await _recipeApiService.unsaveRecipe(recipeId);
      } else {
        await _recipeApiService.saveRecipe(recipeId);
      }

      // After any successful like/unlike action, re-fetch the entire list.
      // This guarantees the local state perfectly matches the re-sequenced database state.
      await fetchLikedRecipes();
    } catch (e) {
      debugPrint("Failed to toggle like status: $e");
      // No need to revert UI optimistically anymore, as we fetch the source of truth.
      // Just re-throw or show an error.
      rethrow;
    }
    // The final notifyListeners() is now inside fetchLikedRecipes().
  }

  List<Recipe> getLikedRecipes() {
    final List<Recipe> orderedList = [];
    for (int id in _likedRecipeIds) {
      if (_likedRecipesMap.containsKey(id)) {
        orderedList.add(_likedRecipesMap[id]!);
      }
    }
    return orderedList;
  }

  void updateLocalRecipeOrder(List<Recipe> reorderedRecipes) {
    _likedRecipeIds = reorderedRecipes.map((r) => r.id!).toSet();
    _likedRecipesMap.clear();
    for (var recipe in reorderedRecipes) {
      _likedRecipesMap[recipe.id!] = recipe;
    }
    notifyListeners();
  }
}
