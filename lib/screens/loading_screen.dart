// FILE: lib/screens/loading_screen_lottie.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class LoadingScreenLottie extends StatelessWidget {
  const LoadingScreenLottie({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // L'animation Lottie
            Lottie.asset(
              'assets/animations/world_tour.json', // Votre fichier d'animation
              width: 250,
              height: 250,
              fit: BoxFit.fill,
            ),
            const SizedBox(height: 20),
            Text(
              'Préparation de votre voyage...',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF0D5159),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
