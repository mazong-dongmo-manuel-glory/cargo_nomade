import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cargo_nomade/widgets/bottom_nav.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Bienvenue',
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 24),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Image.asset(
                        'assets/images/travel_illustration.png',
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Bouton "Mes colis"
                    _buildFullWidthButton(
                      context: context,
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

          ],
        ),

    );
  }

  /// Construit le bouton principal "Mes colis"
  Widget _buildFullWidthButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    required BuildContext context
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
              Icon(icon, color: Theme.of(context).primaryColor, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  text,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor,
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
            context: context,
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
            context: context,
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
    required BuildContext context
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
              Icon(icon, color: Theme.of(context).primaryColor, size: 36),
              const SizedBox(height: 12),
              Text(
                text,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
