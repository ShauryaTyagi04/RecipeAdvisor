import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe_advisor_app/widgets/custom_app_bar.dart';
import 'package:recipe_advisor_app/widgets/custom_button.dart';
import 'package:recipe_advisor_app/widgets/ingredient_pill.dart';
import 'package:recipe_advisor_app/widgets/stroked_text.dart';

class IngredientsInputScreen extends StatefulWidget {
  const IngredientsInputScreen({super.key});

  @override
  State<IngredientsInputScreen> createState() =>
      _IngredientsFeatureScreenState();
}

class _IngredientsFeatureScreenState extends State<IngredientsInputScreen> {
  final TextEditingController _ingredientController = TextEditingController();
  final List<String> _ingredients = [];

  void _addIngredient() {
    final String text = _ingredientController.text.trim();
    if (text.isNotEmpty && !_ingredients.contains(text)) {
      setState(() {
        _ingredients.add(text);
      });
      _ingredientController.clear();
    }
  }

  void _removeIngredient(String ingredientToRemove) {
    setState(() {
      _ingredients.remove(ingredientToRemove);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        fullname: "Full Name",
        username: "USERNAME",
        hasPrefixIcon: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StrokedText(
              text: '''What's in Your Pantry?''',
              fontSize: 35,
              strokeWidth: 5,
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _ingredientController,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    hintText: 'Type your ingredient...',
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.shopping_cart_outlined,
                        color: Colors.grey),
                    suffixIcon: TextButton.icon(
                      onPressed: _addIngredient,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFFFF7700),
                        padding: const EdgeInsets.only(right: 16, left: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      icon: const Icon(
                        Icons.add,
                        size: 25,
                        color: Colors.white,
                      ),
                      label: Text(
                        'ADD',
                        style: GoogleFonts.kodeMono(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    // Border styling
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Color(0xFFFF7700),
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 12.0,
                  children: _ingredients.map((ingredient) {
                    return IngredientPill(
                      label: ingredient,
                      onDeleted: () => _removeIngredient(ingredient),
                    );
                  }).toList(),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: CustomButton(
                onTap: () {
                  Navigator.pushNamed(context, '/RecipeOutputScreen');
                },
                text: 'GENERATE',
                fontSize: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ingredientController.dispose();
    super.dispose();
  }
}
