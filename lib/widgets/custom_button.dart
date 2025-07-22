import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String text;

  final double? customWidth;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? fontSize;

  const CustomButton({
    super.key,
    required this.onTap,
    required this.text,
    this.customWidth,
    this.backgroundColor,
    this.foregroundColor,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the colors to use, falling back to defaults if not provided.
    final Color finalBgColor = backgroundColor ?? const Color(0xFFFF7700);
    final Color finalFgColor = foregroundColor ?? Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        // The width will be the customWidth if provided, otherwise it will spread.
        width: customWidth ?? double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          // Use the determined background color
          color: finalBgColor,
          // Set the corner radius
          borderRadius: BorderRadius.circular(10.0),
          // Set the border color and width
          border: Border.all(
            color: finalFgColor, // The border uses the foreground color
            width: 3.0,
          ),
          // Add the box shadow
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          text,
          style: GoogleFonts.kodeMono(
            color: finalFgColor, // Use the determined foreground color
            fontSize: fontSize ?? 18.0, // Use custom size or default to 18
            fontWeight: FontWeight.w600, // Semi-bold for better visibility
          ),
        ),
      ),
    );
  }
}
