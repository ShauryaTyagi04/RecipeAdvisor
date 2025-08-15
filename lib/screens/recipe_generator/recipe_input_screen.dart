import 'package:flutter/material.dart';
import 'package:recipe_advisor_app/api/auth_api_service.dart';
import 'package:recipe_advisor_app/api/recipe_api_service.dart';
import 'package:recipe_advisor_app/widgets/custom_app_bar.dart';
import 'package:recipe_advisor_app/widgets/custom_button.dart';
import 'package:recipe_advisor_app/widgets/custom_input_field.dart';
import 'package:recipe_advisor_app/widgets/stroked_text.dart';

// 1. --- CREATE THE STATEFULWIDGET ---
class RecipeInputScreen extends StatefulWidget {
  const RecipeInputScreen({super.key});

  @override
  State<RecipeInputScreen> createState() => _RecipeInputScreenState();
}

class _RecipeInputScreenState extends State<RecipeInputScreen> {
  // 2. --- STATE MANAGEMENT ---
  final TextEditingController _recipeNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final RecipeApiService _recipeApiService;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize the API service, providing the required AuthApiService dependency.
    _recipeApiService = RecipeApiService(AuthApiService());
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _recipeNameController.dispose();
    super.dispose();
  }

  // 3. --- API INTEGRATION LOGIC ---
  Future<void> _handleGenerate() async {
    // Validate the input field.
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Call the API with the recipe name from the text field.
      final recipe =
          await _recipeApiService.queryAgent(_recipeNameController.text.trim());

      // On success, navigate to the output screen with the recipe data.
      if (mounted) {
        Navigator.of(context).pushNamed(
          '/RecipeOutputScreen',
          arguments: recipe,
        );
      }
    } catch (e) {
      // On failure, show an error message.
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error fetching recipe: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      // Always turn off the loading indicator.
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
      appBar: const CustomAppBar(
        hasPrefixIcon: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        // Use a Form widget for validation.
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const StrokedText(
                text: 'Find a Recipe',
                fontSize: 48,
              ),
              const SizedBox(height: 40),

              // 4. --- CUSTOM INPUT FIELD ---
              CustomInputField(
                controller: _recipeNameController,
                labelText: 'e.g., Classic Lasagna',
                icon: Icons.search,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a recipe name.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // 5. --- CUSTOM BUTTON ---
              CustomButton(
                onTap: _handleGenerate,
                text: 'GENERATE',
                isLoading: _isLoading,
                fontSize: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
