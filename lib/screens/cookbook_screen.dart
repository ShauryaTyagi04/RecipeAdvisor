import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_advisor_app/api/auth_api_service.dart';
import 'package:recipe_advisor_app/api/recipe_api_service.dart';
import 'package:recipe_advisor_app/models/recipe_model.dart';
import 'package:recipe_advisor_app/providers/liked_recipes_provider.dart';
import 'package:recipe_advisor_app/widgets/cookbook_container.dart';

class CookbookScreen extends StatefulWidget {
  const CookbookScreen({super.key});

  @override
  State<CookbookScreen> createState() => _CookbookScreenState();
}

class _CookbookScreenState extends State<CookbookScreen> {
  late final RecipeApiService _recipeApiService;

  @override
  void initState() {
    super.initState();
    _recipeApiService = RecipeApiService(AuthApiService());
  }

  Future<void> _handleReorder(
      int oldIndex, int newIndex, List<Recipe> recipes) async {
    // This is the list currently being displayed by the builder.
    final List<Recipe> reorderedList = List.of(recipes);

    // Update the list order locally for the immediate UI change.
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final Recipe item = reorderedList.removeAt(oldIndex);
    reorderedList.insert(newIndex, item);

    // Update the provider's state, which will trigger a rebuild with the correct new order.
    // This prevents the "snap back" effect.
    Provider.of<LikedRecipesProvider>(context, listen: false)
        .updateLocalRecipeOrder(reorderedList);

    // Now, send the new order to the backend to persist it.
    final orderedIds = reorderedList.map((recipe) => recipe.id!).toList();
    try {
      await _recipeApiService.updateLikedRecipesOrder(orderedIds);
    } catch (e) {
      // If the API call fails, show an error. The UI will still reflect the new order
      // temporarily, which is often acceptable. You could optionally revert here.
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error: Could not save new order to the server.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<LikedRecipesProvider>(
        builder: (context, likedProvider, child) {
          final recipes = likedProvider.getLikedRecipes();

          if (recipes.isEmpty) {
            return const Center(
              child: Text(
                'Your cookbook is empty.\nGo find some recipes to like!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          // --- Reorderable List ---
          return ReorderableListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return CookbookContainer(
                // Use the recipe's ID as a stable key for reordering.
                key: ValueKey(recipe.id!),
                index: index,
                recipe: recipe,
                onTap: () {
                  Navigator.of(context).pushNamed(
                    '/RecipeOutputScreen',
                    arguments: recipe,
                  );
                },
                onRecipeUpdated: (updatedRecipe) {
                  // This callback is required by LikeButton but we don't need to do anything
                  // here since the provider handles state changes automatically.
                },
              );
            },
            onReorder: (oldIndex, newIndex) =>
                _handleReorder(oldIndex, newIndex, recipes),
            proxyDecorator:
                (Widget child, int index, Animation<double> animation) {
              return Material(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFFFE4CC),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: child,
                ),
              );
            },
            clipBehavior: Clip.hardEdge,
          );
        },
      ),
    );
  }
}
