import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe_advisor_app/widgets/ingredient_pill.dart';

class IngredientsInputWidget extends StatefulWidget {
  // A callback to notify the parent screen of changes to the list of ingredients.
  final Function(List<String> ingredients) onIngredientsChanged;

  const IngredientsInputWidget({
    super.key,
    required this.onIngredientsChanged,
  });

  @override
  State<IngredientsInputWidget> createState() => _IngredientsInputWidgetState();
}

class _IngredientsInputWidgetState extends State<IngredientsInputWidget> {
  final TextEditingController _textController = TextEditingController();
  final List<String> _ingredients = [];

  void _addIngredient() {
    final newIngredient = _textController.text.trim();
    if (newIngredient.isEmpty) {
      return;
    }

    setState(() {
      // Add the new ingredient to the list.
      _ingredients.add(newIngredient);
      _textController.clear();
      // Notify the parent widget of the change.
      widget.onIngredientsChanged(_ingredients);
    });
    // Keep focus on the text field for rapid entry.
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void _removeIngredient(int index) {
    setState(() {
      _ingredients.removeAt(index);
      // Notify the parent widget of the change.
      widget.onIngredientsChanged(_ingredients);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // --- Input Field and Add Button ---
        // This follows the same UI pattern as your InstructionsInputWidget.
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextFormField(
                controller: _textController,
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  labelText: 'Add an ingredient...',
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.5),
                  labelStyle: GoogleFonts.livvic(color: Colors.white70),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: Colors.white, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: Colors.white, width: 2.5),
                  ),
                ),
                style: GoogleFonts.livvic(color: Colors.white, fontSize: 18),
                onFieldSubmitted: (_) => _addIngredient(),
              ),
            ),
            const SizedBox(width: 12),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: ElevatedButton(
                onPressed: _addIngredient,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF7700),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // --- Container for the Ingredient Pills ---
        if (_ingredients.isNotEmpty)
          Wrap(
            // The Wrap widget automatically handles layout.
            spacing: 8.0, // Horizontal space between pills
            runSpacing: 8.0, // Vertical space between lines of pills
            children: List<Widget>.generate(_ingredients.length, (int index) {
              return IngredientPill(
                label: _ingredients[index],
                onDeleted: () => _removeIngredient(index),
              );
            }),
          ),
      ],
    );
  }
}
