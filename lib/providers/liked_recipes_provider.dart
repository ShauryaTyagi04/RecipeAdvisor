import 'package:flutter/foundation.dart';
import 'package:recipe_advisor_app/api/auth_api_service.dart';
import 'package:recipe_advisor_app/api/recipe_api_service.dart';
import 'package:recipe_advisor_app/models/recipe_model.dart';
import 'dart:collection';

class LikedRecipesProvider with ChangeNotifier {
  final RecipeApiService _recipeApiService = RecipeApiService(AuthApiService());

  Set<int> _likedRecipeIds = {};
  Map<int, Recipe> _likedRecipesMap = {};
  List<Recipe> _createdRecipes = [];

  UnmodifiableSetView<int> get likedRecipeIds =>
      UnmodifiableSetView(_likedRecipeIds);
  UnmodifiableMapView<int, Recipe> get likedRecipesMap =>
      UnmodifiableMapView(_likedRecipesMap);
  List<Recipe> get createdRecipes => _createdRecipes;

  bool isLiked(int recipeId) {
    return _likedRecipeIds.contains(recipeId);
  }

  Future<void> fetchAllCookbookData() async {
    try {
      final results = await Future.wait([
        _recipeApiService.getSavedRecipes(),
        _recipeApiService.getCreatedRecipes(),
      ]);

      final List<Recipe> likedRecipes = results[0];
      final List<Recipe> createdRecipes = results[1];

      // Process the liked recipes list
      _likedRecipeIds.clear();
      _likedRecipesMap.clear();
      for (var recipe in likedRecipes) {
        if (recipe.id != null) {
          _likedRecipeIds.add(recipe.id!);
          _likedRecipesMap[recipe.id!] = recipe;
        }
      }

      // Assign the created recipes list
      _createdRecipes = createdRecipes;

      // Notify listeners that both lists have been updated.
      notifyListeners();
    } catch (e) {
      // The error message you are seeing is being caught and printed here.
      debugPrint("Failed to fetch cookbook data: $e");
    }
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

      await fetchAllCookbookData();
    } catch (e) {
      debugPrint("Failed to toggle like status: $e");
      rethrow;
    }
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

  Future<Recipe> addNewUserRecipe(Recipe newRecipe) async {
    try {
      // Have the API service create the recipe and return the saved instance
      // with its new ID and source from the database.
      final savedRecipe = await _recipeApiService.createRecipe(newRecipe);

      // --- THIS IS THE FIX ---
      // Manually add the newly created recipe to the beginning of the local list.
      _createdRecipes.insert(0, savedRecipe);

      // Notify all listening widgets that the data has changed.
      notifyListeners();

      return savedRecipe;
    } catch (e) {
      debugPrint("Error in addNewUserRecipe: $e");
      rethrow;
    }
  }
}
