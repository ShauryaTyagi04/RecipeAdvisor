import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFFFFE4CC),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavBarItem(
            icon: Icons.home_rounded,
            text: 'HOME',
            isSelected: selectedIndex == 0,
            onTap: () => onTap(0),
            iconSize: 30,
            fontSize: 20,
            maxLines: 1,
            gap: 15,
          ),
          _NavBarItem(
            icon: Icons.menu_book_rounded,
            text: 'COOK\nBOOK',
            isSelected: selectedIndex == 1,
            onTap: () => onTap(1),
            iconSize: 30,
            fontSize: 20,
            maxLines: 2,
            gap: 16,
          ),
          _NavBarItem(
            icon: Icons.add_circle_outline_rounded,
            text: 'ADD\nRECIPE',
            isSelected: selectedIndex == 2,
            onTap: () => onTap(2),
            iconSize: 30,
            fontSize: 20,
            maxLines: 2,
            gap: 8,
          ),
          _NavBarItem(
            icon: Icons.people_alt_rounded,
            text: 'CHEFS',
            isSelected: selectedIndex == 3,
            onTap: () => onTap(3),
            iconSize: 30,
            fontSize: 20,
            maxLines: 1,
            gap: 8,
          ),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  final double iconSize;
  final double fontSize;
  final int maxLines;
  final double gap;

  const _NavBarItem({
    required this.icon,
    required this.text,
    required this.isSelected,
    required this.onTap,
    required this.iconSize,
    required this.fontSize,
    required this.maxLines,
    required this.gap,
  });

  @override
  Widget build(BuildContext context) {
    const double buttonSize = 65.0;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: isSelected ? 140 : buttonSize,
        height: buttonSize,
        padding: isSelected
            ? const EdgeInsets.symmetric(horizontal: 12.0)
            : EdgeInsets.zero,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF7700) : Colors.white,
          borderRadius:
              BorderRadius.circular(isSelected ? 20.0 : buttonSize / 2),
          boxShadow: isSelected
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  )
                ],
        ),
        child: isSelected
            ? Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    icon,
                    size: iconSize,
                    color: Colors.white, // Color for selected state
                  ),
                  SizedBox(width: gap),
                  Expanded(
                    child: Text(
                      text,
                      style: GoogleFonts.kodeMono(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                      ),
                      textAlign: TextAlign.left,
                      maxLines: maxLines,
                      softWrap: true,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ],
              )
            : Icon(
                icon,
                size: iconSize,
                color: Colors.black54, // Color for unselected state
              ),
      ),
    );
  }
}
