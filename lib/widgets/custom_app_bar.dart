import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe_advisor_app/widgets/stroked_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String fullname;
  final String username;
  final String? avatarUrl;
  final bool hasPrefixIcon;
  final VoidCallback? onSettingsTap;

  final double avatarRadius;
  final double verticalPadding;

  const CustomAppBar({
    super.key,
    required this.fullname,
    required this.username,
    this.avatarUrl,
    this.hasPrefixIcon = false,
    this.onSettingsTap,
    this.avatarRadius = 35.0,
    this.verticalPadding = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    // FIX 1: Instead of an AppBar, we use a Container for full layout control.
    return Container(
      color: const Color(0xFFFFE4CC),
      // Use SafeArea to avoid content overlapping with the status bar (time, battery, etc.)
      child: SafeArea(
        child: Padding(
          // Horizontal padding for the entire app bar content
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // --- Optional Prefix Home Icon ---
              if (hasPrefixIcon)
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/home');
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      // FIX 2: Use borderRadius for a rounded square.
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: const Icon(Icons.home_rounded,
                          color: Color(0xFFFF7700)),
                    ),
                  ),
                ),

              // --- Avatar, Name, and Username (Takes up the available space) ---
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: avatarRadius,
                      backgroundColor: Colors.white,
                      backgroundImage:
                          (avatarUrl != null && avatarUrl!.isNotEmpty)
                              ? NetworkImage(avatarUrl!)
                              : null,
                      child: (avatarUrl == null || avatarUrl!.isEmpty)
                          ? Icon(
                              Icons.person,
                              size: avatarRadius,
                              color: Colors.grey,
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          fullname,
                          style: GoogleFonts.livvic(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF333333),
                          ),
                        ),
                        StrokedText(
                          text: username,
                          style: StrokedTextStyle.secondary,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          strokeWidth: 2.5,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // --- Settings Icon (Aligned to the right) ---
              GestureDetector(
                onTap: onSettingsTap,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.settings, color: Color(0xFFFF7700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // The preferredSize calculation remains correct.
  @override
  Size get preferredSize {
    final double totalHeight = (avatarRadius * 2) + verticalPadding;
    return Size.fromHeight(totalHeight);
  }
}
