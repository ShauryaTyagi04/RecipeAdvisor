import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_advisor_app/models/recipe_model.dart';
import 'package:recipe_advisor_app/providers/liked_recipes_provider.dart';

enum RecipeSource { user, ai }

class LikeButton extends StatefulWidget {
  final Recipe recipe;
  final Function(Recipe) onRecipeUpdated;
  final RecipeSource source;

  const LikeButton({
    super.key,
    required this.recipe,
    required this.onRecipeUpdated,
    this.source = RecipeSource.user,
  });

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  Future<void> _onLikePressed() async {
    final provider = Provider.of<LikedRecipesProvider>(context, listen: false);

    try {
      if (widget.recipe.id == null) {
        final Future<Recipe> saveFuture = widget.source == RecipeSource.ai
            ? provider.saveAndLikeAiRecipe(widget.recipe)
            : provider.saveAndLikeNewRecipe(widget.recipe);

        final updatedRecipe = await saveFuture;
        widget.onRecipeUpdated(updatedRecipe);
        widget.onRecipeUpdated(updatedRecipe);
      } else {
        await provider.toggleLikeStatus(widget.recipe.id!);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error: Could not update status. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LikedRecipesProvider>(
      builder: (context, provider, child) {
        final bool isLiked = widget.recipe.id != null
            ? provider.isLiked(widget.recipe.id!)
            : false;

        return IconButton(
          icon: Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            color: isLiked ? Colors.red : Colors.grey.shade700,
            size: 36,
          ),
          onPressed: _onLikePressed,
        );
      },
    );
  }
}
