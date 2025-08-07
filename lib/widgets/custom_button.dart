// lib/widgets/custom_button.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String text;
  final double? customWidth;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? fontSize;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.onTap,
    required this.text,
    this.customWidth,
    this.backgroundColor,
    this.foregroundColor,
    this.fontSize,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color finalBgColor = backgroundColor ?? const Color(0xFFFF7700);
    final Color finalFgColor = foregroundColor ?? Colors.white;

    return GestureDetector(
      // 3. DISABLE TAP WHEN LOADING
      onTap: isLoading ? null : onTap,
      child: Container(
        width: customWidth ?? double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: finalBgColor,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: finalFgColor,
            width: 3.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        // 4. CONDITIONALLY DISPLAY SPINNER OR TEXT
        child: isLoading
            ? const SizedBox(
                height: 28, // Match the approximate height of the text
                width: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 3.0,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                text,
                style: GoogleFonts.kodeMono(
                  color: finalFgColor,
                  fontSize: fontSize ?? 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
