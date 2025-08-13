import 'package:flutter/material.dart';
// 1. --- IMPORT YOUR AUTH SERVICE ---
import 'package:recipe_advisor_app/api/auth_api_service.dart';
import 'package:recipe_advisor_app/screens/main_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:recipe_advisor_app/screens/recipe_generator/image_input_screen.dart';
import 'package:recipe_advisor_app/screens/recipe_generator/ingredients_input_screen.dart';
import 'package:recipe_advisor_app/screens/recipe_generator/recipe_input_screen.dart';
import 'package:recipe_advisor_app/screens/recipe_generator/recipe_output_screen.dart';
import 'package:recipe_advisor_app/screens/user/login_screen.dart';
import 'package:recipe_advisor_app/screens/user/registration_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  final authService = AuthApiService();
  final bool isLoggedIn = await authService.isLoggedIn();

  runApp(RecipeAdvisorApp(isLoggedIn: isLoggedIn));
}

class RecipeAdvisorApp extends StatelessWidget {
  final bool isLoggedIn;

  const RecipeAdvisorApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Advisor',
      theme: ThemeData(
          primarySwatch: Colors.orange,
          scaffoldBackgroundColor: const Color(0xFFFFE4CC)),
      initialRoute: isLoggedIn ? '/home' : '/login',
      routes: {
        '/home': (context) => const MainScreen(),
        '/register': (context) => const RegistrationScreen(),
        '/login': (context) => const LoginScreen(),
        '/IngredientsInputScreen': (context) => const IngredientsInputScreen(),
        '/ImageInputScreen': (context) => const ImageInputScreen(),
        '/RecipeInputScreen': (context) => const RecipeInputScreen(),
        '/RecipeOutputScreen': (context) => const RecipeOutputScreen(),
      },
    );
  }
}
