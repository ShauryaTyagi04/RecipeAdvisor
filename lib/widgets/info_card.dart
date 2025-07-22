// lib/widgets/info_card.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoCard extends StatelessWidget {
  final String heading;
  final String text; // This will hold the final, formatted text
  final IconData icon;

  final double headingFontSize;
  final double textFontSize;
  final TextAlign textAlign;

  // The default constructor remains the same.
  const InfoCard({
    super.key,
    required this.heading,
    required this.text,
    required this.icon,
    this.headingFontSize = 24.0,
    this.textFontSize = 20.0,
    this.textAlign = TextAlign.center,
  });

  // --- THE NEW FEATURE IS HERE ---
  // A new factory constructor to handle a list of steps.
  factory InfoCard.fromList({
    Key? key,
    required String heading,
    required IconData icon,
    required List<String> steps,
    double headingFontSize = 24.0,
    double textFontSize = 20.0,
    // Note: The default alignment for lists is now left, as it's more readable.
    TextAlign textAlign = TextAlign.left,
  }) {
    // This logic formats the list into a single, multi-line string.
    final String formattedText = steps.asMap().entries.map((entry) {
      final int stepNumber = entry.key + 1;
      final String stepText = entry.value;
      return 'Step - $stepNumber: $stepText';
    }).join('\n\n'); // Adds a blank line between each step for clarity.

    // It then returns a standard InfoCard with the formatted text.
    return InfoCard(
      key: key,
      heading: heading,
      icon: icon,
      text: formattedText,
      headingFontSize: headingFontSize,
      textFontSize: textFontSize,
      textAlign: textAlign,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
        color: const Color(0xFFFF7700),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Heading Section ---
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                children: [
                  Icon(icon, color: Colors.white, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    heading,
                    style: GoogleFonts.kodeMono(
                      color: Colors.white,
                      fontSize: headingFontSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            // --- Separator Line ---
            Container(height: 2.0, color: Colors.white),
            // --- Content Text Section ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                text, // The build method simply renders the text.
                textAlign: textAlign,
                style: GoogleFonts.livvic(
                  color: Colors.white,
                  fontSize: textFontSize,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
