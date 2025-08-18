import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_advisor_app/models/recipe_model.dart';
import 'package:recipe_advisor_app/providers/liked_recipes_provider.dart';
import 'package:recipe_advisor_app/widgets/custom_button.dart';
import 'package:recipe_advisor_app/widgets/custom_input_field.dart';
import 'package:recipe_advisor_app/widgets/ingredients_input_widget.dart';
import 'package:recipe_advisor_app/widgets/instructions_input_widget.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  List<String> _instructionsList = [];
  List<String> _ingredientsList = [];

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _cookTimeController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _instructionsController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _cookTimeController.dispose();
    _caloriesController.dispose();
    _ingredientsController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  Future<void> _submitRecipe() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final newRecipe = Recipe(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _categoryController.text.trim(),
      cookTime: _cookTimeController.text.trim(),
      calories: num.tryParse(_caloriesController.text.trim()) ?? 0,
      ingredients: _ingredientsList,
      instructions: _instructionsList,
    );

    try {
      await Provider.of<LikedRecipesProvider>(context, listen: false)
          .addNewUserRecipe(newRecipe);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Recipe added to your cookbook!'),
            backgroundColor: Colors.green,
          ),
        );
        // Your navigation logic is correct.
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', (route) => false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding recipe: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomInputField(
                controller: _nameController,
                labelText: 'Recipe Name',
                icon: Icons.restaurant_menu, // <-- ADDED
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a name for your recipe.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomInputField(
                controller: _descriptionController,
                labelText: 'Description',
                icon: Icons.description,
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a description.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomInputField(
                      controller: _categoryController,
                      labelText: 'Category',
                      icon: Icons.category, // <-- ADDED
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomInputField(
                      controller: _cookTimeController,
                      labelText: 'Cook Time',
                      icon: Icons.timer_outlined, // <-- ADDED
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomInputField(
                controller: _caloriesController,
                labelText: 'Calories',
                icon: Icons.local_fire_department_outlined, // <-- ADDED
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              IngredientsInputWidget(
                onIngredientsChanged: (newIngredients) {
                  _ingredientsList = newIngredients;
                },
              ),
              const SizedBox(height: 16),
              InstructionsInputWidget(
                onInstructionsChanged: (newInstructions) {
                  _instructionsList = newInstructions;
                },
              ),
              const SizedBox(height: 32),
              CustomButton(
                onTap: _submitRecipe,
                text: 'ADD TO MY COOKBOOK',
                isLoading: _isLoading,
                fontSize: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
