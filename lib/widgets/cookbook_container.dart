import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe_advisor_app/models/recipe_model.dart';
import 'package:recipe_advisor_app/widgets/like_button.dart';
import 'package:recipe_advisor_app/widgets/stroked_text.dart';

class CookbookContainer extends StatelessWidget {
  final int index;
  final Recipe recipe;
  final VoidCallback onTap;

  const CookbookContainer({
    super.key,
    required this.index,
    required this.recipe,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Colors.white,
                  child: Row(
                    children: [
                      // --- SIMPLIFY THE ROW ---
                      // We remove the LikeButton from here.
                      StrokedText(
                        text: "#${index + 1}",
                        style: StrokedTextStyle.secondary,
                        fontSize: 28,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: StrokedText(
                            text: recipe.name,
                            style: StrokedTextStyle.secondary,
                            fontSize: 28,
                          ),
                        ),
                      ),
                      // The spacer on the right ensures the title remains centered.
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  color: const Color(0xFFFF7700),
                  child: Text(
                    recipe.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.livvic(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
