import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:recipe_advisor_app/api/image_service_api_service.dart';
import 'package:recipe_advisor_app/api/recipe_api_service.dart';
import 'package:recipe_advisor_app/widgets/custom_app_bar.dart';
import 'package:recipe_advisor_app/widgets/custom_button.dart';
import 'package:recipe_advisor_app/widgets/stroked_text.dart';
import 'package:recipe_advisor_app/api/auth_api_service.dart';

class ImageInputScreen extends StatefulWidget {
  const ImageInputScreen({super.key});

  @override
  State<ImageInputScreen> createState() => _ImageInputScreenState();
}

class _ImageInputScreenState extends State<ImageInputScreen> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  // 2. --- DECLARE NEW API SERVICES ---
  late final ImageRecipeApiService _imageRecipeApiService;
  late final RecipeApiService _recipeApiService;

  @override
  void initState() {
    super.initState();
    // Initialize services. Both depend on AuthApiService.
    final authService = AuthApiService();
    _imageRecipeApiService = ImageRecipeApiService(authService);
    _recipeApiService = RecipeApiService(authService);
  }

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
          _selectedImage = File(pickedFile.path);
        });
      }
    }
  }

  // 3. --- NEW GENERATE HANDLER WITH API CALLS ---
  Future<void> _handleGenerate() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an image first.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 1. Predict recipe name from image
      final predictedRecipeName =
          await _imageRecipeApiService.predictRecipeFromImage(_selectedImage!);

      // 2. Pass the predicted name to the recipe API
      final recipe = await _recipeApiService.queryAgent(predictedRecipeName);

      // 3. Navigate to RecipeOutputScreen with the result
      if (mounted) {
        Navigator.of(context).pushNamed(
          '/RecipeOutputScreen',
          arguments: recipe, // Pass the recipe object to the next screen
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
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
      appBar: const CustomAppBar(
        hasPrefixIcon: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const StrokedText(
              text: 'Cook What You See',
              fontSize: 48,
            ),
            const SizedBox(height: 30),
            Expanded(
              child: _selectedImage == null
                  ? GestureDetector(
                      onTap: _pickImage,
                      child: DottedBorder(
                        color: Colors.grey.shade600,
                        strokeWidth: 2,
                        dashPattern: const [10, 6],
                        radius: const Radius.circular(10),
                        borderType: BorderType.RRect,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_alt_outlined,
                                  size: 80,
                                  color: Colors.black54,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Tap to add an Image',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                        Positioned(
                          bottom: 16,
                          child: TextButton.icon(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.black.withOpacity(0.6),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                            ),
                            onPressed: _pickImage,
                            icon: const Icon(
                              Icons.refresh,
                              color: Color(0xFFFF7700), // Changed icon color
                            ),
                            label: const Text('Retake'),
                          ),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 30),
            CustomButton(
              onTap: _handleGenerate,
              text: 'GENERATE',
              isLoading: _isLoading,
              fontSize: 25,
            ),
          ],
        ),
      ),
    );
  }
}
