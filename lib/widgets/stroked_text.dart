import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum StrokedTextStyle {
  primary, // Orange text with white stroke
  secondary, // White text with orange stroke
}

class StrokedText extends StatelessWidget {
  // Required text content
  final String text;

  // Optional parameters for customization
  final StrokedTextStyle style;
  final double fontSize;
  final FontWeight fontWeight;
  final double strokeWidth;

  const StrokedText({
    super.key,
    required this.text,
    // Provide default values for all optional parameters
    this.style = StrokedTextStyle.primary,
    this.fontSize = 32.0,
    this.fontWeight = FontWeight.w700,
    this.strokeWidth = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the colors based on the selected style
    final Color primaryColor = style == StrokedTextStyle.primary
        ? const Color(0xFFFF7700)
        : Colors.white;
    final Color strokeColor = style == StrokedTextStyle.primary
        ? Colors.white
        : const Color(0xFFFF7700);

    return Stack(
      alignment: Alignment.center,
      children: [
        // The stroke text (bottom layer)
        Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.kodeMono(
            fontSize: fontSize,
            fontWeight: fontWeight,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth
              ..color = strokeColor, // Use the determined stroke color
          ),
        ),
        // The main text (top layer)
        Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.kodeMono(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: primaryColor, // Use the determined primary color
          ),
        ),
      ],
    );
  }
}
