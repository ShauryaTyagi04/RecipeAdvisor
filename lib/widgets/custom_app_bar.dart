import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:recipe_advisor_app/providers/user_provider.dart';
import 'package:recipe_advisor_app/widgets/stroked_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool hasPrefixIcon;
  final VoidCallback? onSettingsTap;
  final double avatarRadius;
  final double verticalPadding;

  const CustomAppBar({
    super.key,
    this.hasPrefixIcon = false,
    this.onSettingsTap,
    this.avatarRadius = 35.0,
    this.verticalPadding = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    // The Consumer widget listens to changes in UserProvider and rebuilds the UI.
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        // Get the user object from the provider. It's null while loading.
        final user = userProvider.user;

        // Combine firstName and lastName. Provide a fallback for the loading state.
        final String fullName = (user != null)
            ? '${user.firstName} ${user.lastName}'
            : 'Loading...';

        final String baseIp = dotenv.env["CURRENT_IP"] ?? '';

        final String? imageUrl =
            (user?.imageUrl != null && user!.imageUrl!.isNotEmpty)
                ? "$baseIp${user.imageUrl!}"
                : null;

        return Container(
          color: const Color(0xFFFFE4CC),
          child: SafeArea(
            child: Padding(
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
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: const Icon(
                            Icons.home_rounded,
                            color: Color(0xFFFF7700),
                            size: 30,
                          ),
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
                          // Use the fully constructed imageUrl.
                          backgroundImage: (imageUrl != null)
                              ? NetworkImage(imageUrl)
                              : null,
                          // --- OPTIONAL ICON RENDER ---
                          // If imageUrl is null, display the person icon.
                          child: (imageUrl == null)
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
                              fullName, // Use the combined full name.
                              style: GoogleFonts.livvic(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF333333),
                              ),
                            ),
                            StrokedText(
                              text: user?.username ??
                                  '', // Fallback to empty string.
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
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: const Icon(
                        Icons.settings,
                        color: Color(0xFFFF7700),
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize {
    // The height is based on the avatar's diameter plus vertical padding.
    final double totalHeight = (avatarRadius * 2) + (verticalPadding * 2);
    return Size.fromHeight(totalHeight);
  }
}
