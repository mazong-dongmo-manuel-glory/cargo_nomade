import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:go_router/go_router.dart'; // Assurez-vous d'importer go_router

Widget buildBottomNavBar(BuildContext context) {
  // Accéder au thème actuel via le contexte
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;

  return Container(
    // Un dégradé subtil pour le fond qui correspond à votre thème
    decoration: BoxDecoration(
      color: colorScheme.background, // Utilise la couleur de fond du thème
      boxShadow: [
        BoxShadow(
          blurRadius: 20,
          color: Colors.black.withOpacity(.1),
        )
      ],
    ),
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
        child: GNav(
          // Action de navigation
          onTabChange: (index) {
            if (index == 0) context.go('/home');
            if (index == 1) context.go('/find-trip');
            if (index == 2) context.go('/propose-trip');
            if (index == 3) context.go('/profile'); // Exemple pour le profil
          },

          // Style de la barre
          rippleColor: colorScheme.secondary.withOpacity(0.8),
          hoverColor: colorScheme.secondary.withOpacity(0.6),
          gap: 8, // Espace entre l'icône et le texte
          activeColor: colorScheme.onPrimary, // Couleur du texte et de l'icône actifs
          iconSize: 24,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          duration: const Duration(milliseconds: 400),
          tabBackgroundColor: colorScheme.primary, // Couleur de fond de l'onglet actif
          color: colorScheme.onSurface.withOpacity(0.7), // Couleur des icônes inactives

          // Définition des onglets
          tabs: [
            GButton(
              icon: Icons.home,
              text: 'Accueil',
              textStyle: theme.textTheme.labelLarge,
            ),
            GButton(
              icon: Icons.search, // Une icône plus appropriée pour "find-trip"
              text: 'Chercher',
              textStyle: theme.textTheme.labelLarge,
            ),
            GButton(
              icon: Icons.add_circle_outline, // Une icône plus appropriée pour "propose-trip"
              text: 'Proposer',
              textStyle: theme.textTheme.labelLarge,
            ),
            GButton(
              icon: Icons.person_outline,
              text: 'Profil',
              textStyle: theme.textTheme.labelLarge,
            ),
          ],
        ),
      ),
    ),
  );
}