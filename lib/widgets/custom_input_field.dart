// lib/widgets/custom_input_field.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomInputField extends StatefulWidget {
  final IconData icon;
  final String labelText;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final int? maxLines;

  const CustomInputField(
      {super.key,
      required this.icon,
      required this.labelText,
      this.isPassword = false,
      this.controller,
      this.keyboardType = TextInputType.text,
      this.validator,
      this.maxLines});

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // NOTE: TextFormField is required for validation
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscureText : false,
      keyboardType: widget.keyboardType,
      validator: widget.validator, // 3. PASS VALIDATOR TO THE WIDGET
      maxLines: widget.isPassword ? 1 : widget.maxLines,
      autovalidateMode:
          AutovalidateMode.onUserInteraction, // Validate as user types
      style: GoogleFonts.livvic(
          color: Colors.white, fontWeight: FontWeight.w300, fontSize: 18),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
        filled: true,
        fillColor: Colors.black.withOpacity(0.5),
        prefixIcon: Icon(widget.icon, color: Colors.white, size: 22),
        labelText: widget.labelText,
        labelStyle: GoogleFonts.livvic(color: Colors.white70),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.white, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.white, width: 2.5),
        ),
        // 4. ADD ERROR BORDER AND STYLE FOR VISUAL FEEDBACK
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2.5),
        ),
        errorStyle: GoogleFonts.livvic(
            color: Colors.redAccent, fontWeight: FontWeight.bold),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white70,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
    );
  }
}
