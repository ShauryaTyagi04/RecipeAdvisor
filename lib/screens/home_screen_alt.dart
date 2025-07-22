import 'package:flutter/material.dart';
import 'package:recipe_advisor_app/utils/image_sizing.dart';
import 'package:recipe_advisor_app/widgets/custom_layered_card.dart';

class HomeScreenAlt extends StatelessWidget {
  const HomeScreenAlt({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/IngredientsInputScreen');
              },
              child: CustomLayeredCard(
                heading: '''What's in Your Pantry?''',
                description:
                    'List the ingredients you have on hand, and our AI will instantly create a unique recipe for you.',
                imagePath: 'assets/images/first_model.png',
                imageSizing: ImageSizing.custom(
                  height: 150,
                  width: 150,
                ),
                imageOpacity: 0.7,
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/ImageInputScreen');
              },
              child: CustomLayeredCard(
                heading: 'Cook What You See',
                description:
                    'Ever see a meal and wish you could make it? Just use a picture to unlock the name and recipe instantly.',
                imagePath: 'assets/images/second_model_alt.png',
                imageSizing: ImageSizing.stretch,
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/RecipeInputScreen');
              },
              child: CustomLayeredCard(
                heading: 'Name It, Make It',
                description:
                    '''Know exactly what you want to cook but don't have a recipe? Just type in the name of the dish, and our AI will instantly generate the complete instructions for you.''',
                imagePath: 'assets/images/third_model.png',
                imageSizing: ImageSizing.stretch,
                imageOpacity: 0.7,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
