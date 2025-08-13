import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe_advisor_app/api/auth_api_service.dart';
import 'package:recipe_advisor_app/widgets/blurred_container.dart';
import 'package:recipe_advisor_app/widgets/custom_button.dart';
import 'package:recipe_advisor_app/widgets/custom_input_field.dart';
import 'package:recipe_advisor_app/widgets/stroked_text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthApiService();
  bool _isLoading = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.loginUser(
        username: _usernameController.text.trim(),
        password: _passwordController.text,
      );

      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login Successful!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Login Failed: ${e.toString().replaceFirst("Exception: ", "")}'),
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
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      body: Stack(
        children: [
          // --- LAYER 1: STATIC BACKGROUND ---
          Positioned.fill(
            child: Image.asset('assets/images/login_background.png',
                fit: BoxFit.cover),
          ),

          // --- LAYER 2: STATIC HEADING ---
          // Positioned independently so it doesn't scroll.
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 80.0),
                child: StrokedText(
                  text: "LOGIN TO YOUR ACCOUNT",
                  fontSize: 48,
                ),
              ),
            ),
          ),

          // --- LAYER 3: ANCHORED, SCROLLABLE FORM ---
          // This container is fixed to the bottom of the screen.
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BlurredContainer(
              // The SingleChildScrollView is INSIDE, so only the form scrolls.
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Shrink-wraps content
                    children: [
                      const SizedBox(height: 18),
                      Text(
                        'Enter Your Login Information',
                        style: GoogleFonts.livvic(
                            color: Colors.white, fontSize: 30),
                      ),
                      const SizedBox(height: 36),
                      CustomInputField(
                        icon: Icons.person_outline,
                        labelText: 'Username or Email',
                        controller: _usernameController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Please enter your username or email.'
                                : null,
                      ),
                      const SizedBox(height: 16),
                      CustomInputField(
                        icon: Icons.lock_outline,
                        labelText: 'Password',
                        controller: _passwordController,
                        isPassword: true,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter your password.'
                            : null,
                      ),
                      const SizedBox(height: 30),
                      CustomButton(
                        onTap: _login,
                        text: 'LOGIN',
                        fontSize: 25,
                        isLoading: _isLoading,
                      ),
                      const SizedBox(height: 18),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/register');
                        },
                        child: Text(
                          '''Don't have an account? Sign Up''',
                          style: GoogleFonts.livvic(
                              color: Colors.white, fontSize: 16),
                        ),
                      ),
                      SizedBox(
                          height:
                              keyboardHeight > 0 ? keyboardHeight + 20 : 18),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
