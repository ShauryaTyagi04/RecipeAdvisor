// lib/widgets/loading_overlay.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:recipe_advisor_app/widgets/stroked_text.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Your main screen content
        child,

        // The overlay, only shown when isLoading is true
        if (isLoading)
          const ModalBarrier(dismissible: false, color: Colors.transparent),

        if (isLoading)
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Center(
              // --- THE FIX IS HERE ---
              // Wrap the Column with a transparent Material widget.
              // This provides the necessary context for the Text widgets.
              child: Material(
                color: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFFFF7700)),
                    ),
                    const SizedBox(height: 24),
                    // The StrokedText widget will no longer show a yellow line.
                    const StrokedText(
                      text: 'Generating Recipe...',
                      fontSize: 25,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
