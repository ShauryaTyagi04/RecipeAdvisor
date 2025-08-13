import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_advisor_app/api/auth_api_service.dart';

import 'package:recipe_advisor_app/models/user_model.dart';
import 'package:recipe_advisor_app/widgets/blurred_container.dart';
import 'package:recipe_advisor_app/widgets/custom_button.dart';
import 'package:recipe_advisor_app/widgets/custom_input_field.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // 2. --- STATE MANAGEMENT & KEYS ---
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthApiService _authService = AuthApiService();
  bool _isLoading = false;

  File? _avatarImage;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cPasswordController = TextEditingController();

  // 3. --- LIFECYCLE MANAGEMENT ---
  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _cPasswordController.dispose();
    super.dispose();
  }

  // The _pickImage method remains unchanged.
  Future<void> _pickImage() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source != null) {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _avatarImage = File(pickedFile.path);
        });
      }
    }
  }

  // 4. --- API-INTEGRATED REGISTRATION LOGIC ---
  Future<void> _register() async {
    // Trigger validation and stop if the form is invalid.
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Create the UserCreate object from controller text.
      final newUser = UserCreate(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text,
      );

      final userResponse = await _authService.registerUser(
        newUser,
        avatarFile: _avatarImage,
      );

      // On success, show a confirmation message.
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Registration successful! Welcome, ${userResponse.username}.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pushNamed('/login');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration Failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      // Ensure the loading indicator is always turned off.
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/login_background.png',
                fit: BoxFit.cover),
          ),
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: screenHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.black.withOpacity(0.5),
                        backgroundImage: _avatarImage != null
                            ? FileImage(_avatarImage!)
                            : null,
                        child: _avatarImage == null
                            ? const Icon(Icons.person_add,
                                size: 60, color: Colors.white)
                            : null,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    const Spacer(),
                    BlurredContainer(
                      // 5. --- FORM WIDGET ---
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 18),
                            // 6. --- INPUT FIELDS WITH VALIDATORS ---
                            CustomInputField(
                              icon: Icons.person_outline,
                              labelText: 'First Name',
                              controller: _firstNameController,
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Please enter your first name.'
                                      : null,
                            ),
                            const SizedBox(height: 16),
                            CustomInputField(
                              icon: Icons.person_outline,
                              labelText: 'Last Name',
                              controller: _lastNameController,
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Please enter your last name.'
                                      : null,
                            ),
                            const SizedBox(height: 16),
                            CustomInputField(
                              icon: Icons.account_circle_outlined,
                              labelText: 'Username',
                              controller: _usernameController,
                              validator: (value) => value == null ||
                                      value.trim().length < 4
                                  ? 'Username must be at least 4 characters.'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            CustomInputField(
                              icon: Icons.email_outlined,
                              labelText: 'Email Address',
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) =>
                                  value == null || !value.contains('@')
                                      ? 'Please enter a valid email.'
                                      : null,
                            ),
                            const SizedBox(height: 16),
                            CustomInputField(
                              icon: Icons.phone_outlined,
                              labelText: 'Phone Number (Optional)',
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              // No validator for optional field
                            ),
                            const SizedBox(height: 16),
                            CustomInputField(
                              icon: Icons.lock_outline,
                              labelText: 'Password',
                              controller: _passwordController,
                              isPassword: true,
                              validator: (value) => value == null ||
                                      value.length < 8
                                  ? 'Password must be at least 8 characters.'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            CustomInputField(
                              icon: Icons.lock_outline,
                              labelText: 'Confirm Password',
                              controller: _cPasswordController,
                              isPassword: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a password.';
                                }
                                if (value.length < 8) {
                                  return 'Password must be at least 8 characters.';
                                }
                                if (!RegExp(r'[A-Z]').hasMatch(value)) {
                                  return 'Password must contain an uppercase letter.';
                                }
                                if (!RegExp(r'[a-z]').hasMatch(value)) {
                                  return 'Password must contain a lowercase letter.';
                                }
                                if (!RegExp(r'[0-9]').hasMatch(value)) {
                                  return 'Password must contain a number.';
                                }
                                if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                                    .hasMatch(value)) {
                                  return 'Password must contain a special character.';
                                }
                                return null; // Return null if the password is valid
                              },
                            ),
                            const SizedBox(height: 30),
                            // 7. --- BUTTON WITH LOADING STATE ---
                            CustomButton(
                              onTap: _register,
                              text: 'REGISTER',
                              fontSize: 25,
                              isLoading: _isLoading,
                            ),
                            const SizedBox(height: 18),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed('/login');
                              },
                              child: Text(
                                'Already have an account? Login',
                                style: GoogleFonts.livvic(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                            const SizedBox(height: 18),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
