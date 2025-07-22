// lib/widgets/ingredients_panel.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- WIDGET 1: THE HEADER ---
// This widget is now just the header portion of the panel.
class IngredientsHeader extends StatelessWidget {
  const IngredientsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200, // A fixed width for the heading
      height: 125,
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      decoration: const BoxDecoration(
        color: Color(0xFFFF7700),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
        // The separator line is a bottom border
        border: Border(
          bottom: BorderSide(color: Colors.white, width: 2.0),
        ),
      ),
      child: Text(
        'Ingredients',
        textAlign: TextAlign.center,
        style: GoogleFonts.kodeMono(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// --- WIDGET 2: THE BODY ---
// This widget contains the main ingredients grid.
class IngredientsBody extends StatelessWidget {
  final List<String> ingredients;

  const IngredientsBody({
    super.key,
    this.ingredients = const [
      'Chicken Breast',
      'Olive Oil',
      'Garlic',
      'Rosemary',
      'Salt',
      'Black Pepper',
      'Lemon',
      'Potatoes'
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFF7700),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10.0),
          bottomLeft: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 5.0,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: ingredients.length,
            itemBuilder: (context, index) {
              return Text(
                '• ${ingredients[index]}',
                style: GoogleFonts.livvic(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
