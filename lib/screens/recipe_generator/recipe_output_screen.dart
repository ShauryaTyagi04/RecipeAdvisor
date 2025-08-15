import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe_advisor_app/models/recipe_model.dart';
import 'package:recipe_advisor_app/widgets/custom_app_bar.dart';
import 'package:recipe_advisor_app/widgets/custom_button.dart';
import 'package:recipe_advisor_app/widgets/info_card.dart';
import 'package:recipe_advisor_app/widgets/ingredients_panel.dart';
import 'package:recipe_advisor_app/widgets/stroked_text.dart';

class RecipeOutputScreen extends StatelessWidget {
  const RecipeOutputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Recipe? recipe =
        ModalRoute.of(context)?.settings.arguments as Recipe?;

    if (recipe == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: const Center(
          child: Text("Could not load recipe data. Please go back."),
        ),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        hasPrefixIcon: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StrokedText(
              text: recipe.name,
            ),
            const SizedBox(height: 8),
            Text(
              recipe.description,
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
                    text: recipe.category, // DYNAMIC
                    icon: Icons.dinner_dining,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InfoCard(
                    heading: "Cook Time",
                    text: recipe.cookTime, // DYNAMIC
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
                        "${recipe.calories.toStringAsFixed(0)} kcal", // DYNAMIC
                    icon: Icons.local_fire_department_outlined,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 20),
              child:
                  IngredientsBody(ingredients: recipe.ingredients), // DYNAMIC
            ),
            InfoCard.fromList(
              icon: Icons.list_alt_rounded,
              heading: 'Instructions',
              steps: recipe.instructions, // DYNAMIC
              textFontSize: 18.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: CustomButton(
                onTap: () {
                  // Use pop to go back to the previous screen instead of pushing a new one
                  Navigator.pop(context);
                },
                text: 'BACK',
                fontSize: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
