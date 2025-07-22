import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IngredientPill extends StatelessWidget {
  final String label;
  final VoidCallback onDeleted;

  const IngredientPill({
    super.key,
    required this.label,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
        color: const Color(0xFFFF7700), // Background color
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Ingredient text
          Text(
            label,
            style: GoogleFonts.livvic(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onDeleted,
            child: const Icon(
              Icons.close,
              color: Colors.white,
              size: 18.0,
            ),
          ),
        ],
      ),
    );
  }
}
