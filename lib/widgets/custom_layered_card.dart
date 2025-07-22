import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe_advisor_app/utils/image_sizing.dart';
import 'package:recipe_advisor_app/widgets/stroked_text.dart';

class CustomLayeredCard extends StatelessWidget {
  final String heading;
  final String description;
  final String imagePath;
  final ImageSizing imageSizing;
  final EdgeInsetsGeometry imageMargin;

  // 1. The new parameter for image opacity.
  final double imageOpacity;

  const CustomLayeredCard({
    super.key,
    required this.heading,
    required this.description,
    required this.imagePath,
    this.imageSizing = const ImageSizing(),
    this.imageMargin = EdgeInsets.zero,
    // 2. Set a default value and use an assertion to ensure it's valid (0.0 to 1.0).
    this.imageOpacity = 1.0,
  }) : assert(imageOpacity >= 0.0 && imageOpacity <= 1.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Base white layer
            Positioned.fill(
              child: Container(color: Colors.white),
            ),

            // The image layer, now with opacity control
            _buildImageLayer(),

            // Orange overlay
            Positioned.fill(
              child: Container(color: const Color(0x99FF7700)),
            ),

            // Blur effect
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
                child: Container(color: Colors.transparent),
              ),
            ),

            // Foreground content
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  StrokedText(
                    text: heading,
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    strokeWidth: 4,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    description,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.livvic(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // This method now wraps the image in an Opacity widget.
  Widget _buildImageLayer() {
    // 3. The image is now wrapped in an Opacity widget.
    final Widget imageWithOpacity = Opacity(
      opacity: imageOpacity,
      child: Image.asset(
        imagePath,
        fit: imageSizing.fit,
        errorBuilder: (context, error, stackTrace) {
          return const Center(
              child: Icon(Icons.broken_image, color: Colors.grey));
        },
      ),
    );

    // This logic correctly applies padding and sizing.
    if (imageSizing.fit == BoxFit.cover || imageSizing.fit == BoxFit.fill) {
      return Positioned.fill(
        child: Padding(
          padding: imageMargin,
          child: imageWithOpacity,
        ),
      );
    }

    return Padding(
      padding: imageMargin,
      child: SizedBox(
        width: imageSizing.width,
        height: imageSizing.height,
        child: imageWithOpacity,
      ),
    );
  }
}
