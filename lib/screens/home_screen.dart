import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Définition des couleurs pour une maintenance facile
  static const Color primaryTextColor = Color(0xFF0D5159);
  static const Color secondaryTextColor = Colors.black54;
  static const Color inactiveIconColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Contenu principal qui peut défiler sur de petits écrans
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    // Message de bienvenue
                    Text(
                      'Bienvenue',
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Illustration
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      // Assurez-vous que le chemin de l'image est correct
                      child: Image.asset(
                        'assets/images/travel_illustration.png',
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Bouton "Mes colis"
                    _buildFullWidthButton(
                      icon: Icons.inventory_2_outlined,
                      text: 'Mes colis',
                      onTap: () {
                        print('Mes colis cliqué');
                        // Naviguez vers la page des colis ici
                      },
                    ),
                    const SizedBox(height: 16),

                    // Grille des actions
                    _buildActionGrid(context),
                  ],
                ),
              ),
            ),

            // Barre de navigation inférieure
            _buildBottomNavBar(),
          ],
        ),
      ),
    );
  }

  /// Construit le bouton principal "Mes colis"
  Widget _buildFullWidthButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!, width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
          child: Row(
            children: [
              Icon(icon, color: primaryTextColor, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  text,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: primaryTextColor,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  /// Construit la grille avec les deux boutons d'action
  Widget _buildActionGrid(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            // NOTE: L'icône dans l'image est personnalisée.
            // Icons.route_outlined est une bonne alternative.
            icon: Icons.route_outlined,
            text: 'Proposer un trajet',
            onTap: () {
              context.go("/propose-trip");
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildActionButton(
            // NOTE: Icons.person_search est une très bonne alternative pour l'icône de l'image.
            icon: Icons.person_search_outlined,
            text: 'Trouver un transporteur',
            onTap: () {
              context.go('/find-trip');
            },
          ),
        ),
      ],
    );
  }

  /// Construit une carte d'action individuelle
  Widget _buildActionButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!, width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: primaryTextColor, size: 36),
              const SizedBox(height: 12),
              Text(
                text,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: primaryTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Construit la barre de navigation en bas de l'écran
  Widget _buildBottomNavBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(icon: Icons.home, label: 'Home', isActive: true),
          _buildNavItem(icon: Icons.chat_bubble_outline, label: 'Messages'),
          _buildNavItem(icon: Icons.person_outline, label: 'Profile'),
        ],
      ),
    );
  }

  /// Construit un élément de la barre de navigation
  Widget _buildNavItem({
    required IconData icon,
    required String label,
    bool isActive = false,
  }) {
    final color = isActive ? primaryTextColor : inactiveIconColor;
    return Column(
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
    );
  }
}
