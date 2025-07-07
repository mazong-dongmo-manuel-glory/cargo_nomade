import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

const Color primaryTextColor = Color(0xFF0D5159);
const Color secondaryTextColor = Colors.black54;
const Color inactiveIconColor = Colors.grey;

Widget buildBottomNavBar(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildNavItem(
          icon: Icons.home_outlined, // Home icon
          label: 'Accueil',
          onTap: () {
            context.go('/home');
          },
        ),
        _buildNavItem(
          icon: Icons.search, // Search for trips
          label: 'Trouver un trajet',
          onTap: () {
            context.go('/find-trip');
          },
        ),
        _buildNavItem(
          icon: Icons.add_box_outlined, // Icon for offering/posting a trip
          label: 'Proposer',
          onTap: () {
            context.go('/propose-trip');
          },
        ),
        _buildNavItem(
          icon: Icons.chat_bubble_outline, // Chat/Messages
          label: 'Messages',
          onTap: () {
            context.go('/home');
          },
        ),
        _buildNavItem(
          icon: Icons.person_outline, // Profile/Account
          label: 'Profil',
          isActive: false,
          onTap: () {
            context.go('/home');
          },
        ),
      ],
    ),
  );
}

Widget _buildNavItem({
  required IconData icon,
  required String label,
  required Function() onTap,
  bool isActive = false,
}) {
  var primaryTextColor;
  final color = isActive ? primaryTextColor : inactiveIconColor;
  return InkWell(
    onTap: onTap,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            color: color,
          ),
        ),
      ],
    ),
  );
}
