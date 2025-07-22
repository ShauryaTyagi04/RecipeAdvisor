import 'package:flutter/material.dart';
import 'package:recipe_advisor_app/screens/main_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:recipe_advisor_app/screens/recipe_generator/image_input_screen.dart';
import 'package:recipe_advisor_app/screens/recipe_generator/ingredients_input_screen.dart';
import 'package:recipe_advisor_app/screens/recipe_generator/recipe_input_screen.dart';
import 'package:recipe_advisor_app/screens/recipe_generator/recipe_output_screen.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const RecipeAdvisorApp());
}

class RecipeAdvisorApp extends StatelessWidget {
  const RecipeAdvisorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Advisor',
      theme: ThemeData(
          primarySwatch: Colors.orange,
          scaffoldBackgroundColor: const Color(0xFFFFE4CC)),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainScreen(),
        '/IngredientsInputScreen': (context) => const IngredientsInputScreen(),
        '/ImageInputScreen': (context) => const ImageInputScreen(),
        '/RecipeInputScreen': (context) => const RecipeInputScreen(),
        '/RecipeOutputScreen': (context) => const RecipeOutputScreen(),
      },
    );
  }
}
