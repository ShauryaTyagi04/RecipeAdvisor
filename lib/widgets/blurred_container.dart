import 'dart:ui';
import 'package:flutter/material.dart';

class BlurredContainer extends StatelessWidget {
  final Widget child;

  const BlurredContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(30.0)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.54),
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(30.0)),
            border: const Border(
              top: BorderSide(color: Colors.white, width: 2.0),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
