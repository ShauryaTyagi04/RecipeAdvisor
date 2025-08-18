import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// No change needed to the enum
enum StrokedTextStyle {
  primary, // Orange text with white stroke
  secondary, // White text with orange stroke
}

class StrokedText extends StatelessWidget {
  final String text;
  final StrokedTextStyle style;
  final double fontSize;
  final FontWeight fontWeight;
  final double strokeWidth;
  // --- 1. ADD THE NEW 'inverse' PROPERTY ---
  final bool inverse;
  final TextAlign textAlign;

  const StrokedText({
    super.key,
    required this.text,
    this.style = StrokedTextStyle.primary,
    this.fontSize = 32.0,
    this.fontWeight = FontWeight.w700,
    this.strokeWidth = 4.0,
    this.inverse = false, // Default to not inverted
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    // --- 2. UPDATE COLOR LOGIC ---
    // This logic determines the colors based on the style and the new inverse flag.
    final effectiveStyle = inverse
        ? (style == StrokedTextStyle.primary
            ? StrokedTextStyle.secondary
            : StrokedTextStyle.primary)
        : style;

    final Color primaryColor = effectiveStyle == StrokedTextStyle.primary
        ? const Color(0xFFFF7700)
        : Colors.white;
    final Color strokeColor = effectiveStyle == StrokedTextStyle.primary
        ? Colors.white
        : const Color(0xFFFF7700);

    return Stack(
      alignment: Alignment.center,
      children: [
        // Stroke (bottom layer)
        Text(
          text,
          textAlign: textAlign,
          style: GoogleFonts.kodeMono(
            fontSize: fontSize,
            fontWeight: fontWeight,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth
              ..color = strokeColor,
          ),
        ),
        // Fill (top layer)
        Text(
          text,
          textAlign: textAlign,
          style: GoogleFonts.kodeMono(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: primaryColor,
          ),
        ),
      ],
    );
  }
}
