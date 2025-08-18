import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:recipe_advisor_app/api/auth_api_service.dart';
import 'package:recipe_advisor_app/api/recipe_api_service.dart';
import 'package:recipe_advisor_app/models/recipe_model.dart';
import 'package:recipe_advisor_app/providers/liked_recipes_provider.dart';
import 'package:recipe_advisor_app/widgets/custom_app_bar.dart';
import 'package:recipe_advisor_app/widgets/custom_button.dart';
import 'package:recipe_advisor_app/widgets/info_card.dart';
import 'package:recipe_advisor_app/widgets/ingredients_panel.dart';
import 'package:recipe_advisor_app/widgets/like_button.dart';
import 'package:recipe_advisor_app/widgets/stroked_text.dart';

class RecipeOutputScreen extends StatefulWidget {
  const RecipeOutputScreen({super.key});

  @override
  State<RecipeOutputScreen> createState() => _RecipeOutputScreenState();
}

class _RecipeOutputScreenState extends State<RecipeOutputScreen> {
  late Recipe _recipe;
  bool _isInitialized = false;
  // --- 1. ADD API SERVICE AND LOADING STATE ---
  late final RecipeApiService _recipeApiService;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _recipeApiService = RecipeApiService(AuthApiService());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final initialRecipe =
          ModalRoute.of(context)?.settings.arguments as Recipe?;
      if (initialRecipe != null) {
        _recipe = initialRecipe;
      } else {
        _recipe = Recipe(
            name: "Error",
            description: "No recipe data.",
            category: "",
            cookTime: "",
            calories: 0,
            ingredients: [],
            instructions: [],
            source: 'USER_CREATED'); // Add a default source
      }
      _isInitialized = true;
    }
  }

  // --- 2. ADD THE DELETE HANDLER ---
  Future<void> _handleDelete() async {
    if (_recipe.id == null) return;

    // Show a confirmation dialog before deleting.
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text(
            'Are you sure you want to permanently delete this recipe? This cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (shouldDelete != true) {
      return; // User canceled the deletion.
    }

    setState(() {
      _isDeleting = true;
    });

    try {
      await _recipeApiService.deleteRecipe(_recipe.id!);
      // After deleting, refresh the liked recipes provider to remove it from the list.
      if (mounted) {
        await Provider.of<LikedRecipesProvider>(context, listen: false)
            .fetchLikedRecipes();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Recipe deleted successfully.'),
              backgroundColor: Colors.green),
        );
        // Pop twice: once for the dialog, once to leave the screen.
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // --- 3. DETERMINE WHICH BUTTONS TO SHOW ---
    final bool isAiGenerated = _recipe.source == 'AI_GENERATED';
    final bool isUserCreated = _recipe.source == 'USER_CREATED';

    return Scaffold(
      appBar: const CustomAppBar(hasPrefixIcon: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // --- 4. CONDITIONAL LIKE BUTTON ---
                SizedBox(
                  width: 48,
                  height: 48,
                  // Only show the LikeButton if the recipe is AI-generated.
                  child: isAiGenerated
                      ? LikeButton(
                          recipe: _recipe,
                          onRecipeUpdated: (updatedRecipe) {
                            setState(() {
                              _recipe = updatedRecipe;
                            });
                          },
                          source: RecipeSource.ai,
                        )
                      : null, // Otherwise, show nothing, maintaining the space.
                ),
                Expanded(child: StrokedText(text: _recipe.name)),
                const SizedBox(width: 48),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _recipe.description,
              textAlign: TextAlign.center,
              style: GoogleFonts.livvic(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: InfoCard(
                    heading: "Category",
                    text: _recipe.category, // DYNAMIC
                    icon: Icons.dinner_dining,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InfoCard(
                    heading: "Cook Time",
                    text: _recipe.cookTime, // DYNAMIC
                    icon: Icons.timer_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const IngredientsHeader(),
                const SizedBox(width: 16),
                Expanded(
                  child: InfoCard(
                    heading: "Calories",
                    text:
                        "${_recipe.calories.toStringAsFixed(0)} kcal", // DYNAMIC
                    icon: Icons.local_fire_department_outlined,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 20),
              child:
                  IngredientsBody(ingredients: _recipe.ingredients), // DYNAMIC
            ),
            InfoCard.fromList(
              icon: Icons.list_alt_rounded,
              heading: 'Instructions',
              steps: _recipe.instructions, // DYNAMIC
              textFontSize: 18.0,
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                // --- 5. BACK AND DELETE BUTTONS ---
                Expanded(
                  child: CustomButton(
                    onTap: () => Navigator.pop(context),
                    text: 'BACK',
                    fontSize: 20,
                  ),
                ),
                // Only show the delete button if the recipe was created by a user.
                if (isUserCreated) ...[
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomButton(
                      onTap: _handleDelete,
                      text: 'DELETE',
                      fontSize: 20,
                      isLoading: _isDeleting,
                      backgroundColor:
                          Colors.red.shade800, // Use the new parameter
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
