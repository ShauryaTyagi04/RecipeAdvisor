import 'package:flutter/material.dart';
import 'package:recipe_advisor_app/widgets/custom_app_bar.dart';
import 'package:recipe_advisor_app/widgets/custom_button.dart';
import 'package:recipe_advisor_app/widgets/info_card.dart';
import 'package:recipe_advisor_app/widgets/ingredients_panel.dart';

class RecipeOutputScreen extends StatelessWidget {
  const RecipeOutputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const List<String> recipeSteps = [
      'Preheat the oven to 200°C.',
      'Season the chicken with salt, pepper, and herbs.',
      'Place in the oven and roast for 25 minutes, or until cooked through.',
      'Let it rest for 5 minutes before serving.',
    ];

    return Scaffold(
      appBar: CustomAppBar(
        fullname: "Full Name",
        username: "USERNAME",
        hasPrefixIcon: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // The first row of info cards remains unchanged.
            const Row(
              children: [
                Expanded(
                  child: InfoCard(
                    heading: "Category",
                    text: "Dinner",
                    icon: Icons.dinner_dining,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: InfoCard(
                    heading: "Cook Time",
                    text: "30 Minutes",
                    icon: Icons.timer_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // --- THE NEW LAYOUT ---
            // A Row holds the header and the last card.
            const Row(
              // Align items to the bottom for a clean look.
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IngredientsHeader(),
                SizedBox(width: 16),
                // The InfoCard expands to fill the remaining space on the right.
                Expanded(
                  child: InfoCard(
                    heading: "Calories",
                    text: "450 kcal",
                    icon: Icons.local_fire_department_outlined,
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 20),
              child: const IngredientsBody(),
            ),
            InfoCard.fromList(
              icon: Icons.list_alt_rounded,
              heading: 'Instructions',
              steps: recipeSteps,
              textFontSize: 18.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: CustomButton(
                onTap: () {
                  Navigator.pushNamed(context, '/IngredientsInputScreen');
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
