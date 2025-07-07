// FILE: lib/widgets/trip_card.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart'; // Keep if you use it for navigation
import '../models/trip_model.dart';
import '../models/enums.dart'; // Pour TransportMode

class TripCard extends StatelessWidget {
  final TripModel trip;

  TripCard({super.key, required this.trip});

  // Define your theme colors for consistency
  final Color _primaryColor = const Color(
    0xFF0D5159,
  ); // Dark Teal from your app theme
  final Color _darkTextColor =
      Colors.black87; // General dark text color for values
  final Color _lightTextColor =
      Colors.grey[600]!; // Lighter text color for labels

  @override
  Widget build(BuildContext context) {
    // Formatter for the date including the year for clarity
    final formattedDate = DateFormat(
      'dd MMM yyyy', // Added year
      'fr_FR', // Ensure French locale for month abbreviation
    ).format(trip.departureDate);

    return Card(
      elevation: 6, // Slightly increased elevation for a more prominent card
      shadowColor: _primaryColor.withOpacity(
        0.1,
      ), // Shadow with primary color tint
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ), // Slightly more rounded corners
      margin: const EdgeInsets.symmetric(
        horizontal: 0,
        vertical: 8,
      ), // Provide external margin if placed in a list
      child: InkWell(
        onTap: () {
          // Naviguer vers les détails du trajet (à implémenter)
          // context.go('/trip-details/${trip.id}');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Afficher les détails du trajet...')),
          );
        },
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(
            20.0,
          ), // Increased padding for more breathing room
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20), // More spacing
              _buildRouteInfo(),
              const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 20.0,
                ), // Spacing around divider
                child: Divider(
                  height: 1,
                  thickness: 0.8,
                  color: Colors.black12,
                ), // Lighter, thinner divider
              ),
              _buildFooter(context, formattedDate),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 28, // Slightly larger avatar
          backgroundColor: _primaryColor.withOpacity(
            0.1,
          ), // Lighter background for the initial
          backgroundImage: trip.travelerPhotoUrl != null
              ? NetworkImage(trip.travelerPhotoUrl!)
              : null,
          child: trip.travelerPhotoUrl == null
              ? Text(
                  trip.travelerName.isNotEmpty
                      ? trip.travelerName[0].toUpperCase()
                      : 'U', // Ensure uppercase initial
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: _primaryColor, // Use primary color for initial
                    fontSize: 20, // Larger initial
                  ),
                )
              : null,
        ),
        const SizedBox(width: 15), // More spacing
        Expanded(
          child: Text(
            trip.travelerName,
            style: GoogleFonts.poppins(
              fontSize: 18, // Slightly larger font for name
              fontWeight: FontWeight.w700, // Bolder
              color: _darkTextColor, // Black for the name
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // Optional: Add a verified icon or rating here
        // Icon(Icons.verified_user, color: Colors.blueAccent, size: 20),
      ],
    );
  }

  Widget _buildRouteInfo() {
    return Row(
      children: [
        _buildLocationColumn(
          'Départ',
          trip.departureLocation,
          Icons.flight_takeoff, // Good icon choice
        ),
        const Spacer(), // Flexible space
        Column(
          children: [
            Icon(
              trip.transportMode == TransportMode.plane
                  ? Icons.airplanemode_active
                  : Icons.local_shipping, // Good icon choice
              color: _primaryColor, // Primary color for the main icon
              size: 32, // Slightly larger icon
            ),
            const SizedBox(height: 6), // More spacing
            Text(
              '${trip.availableWeightKg.toStringAsFixed(0)} kg',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700, // Bolder weight
                color: _primaryColor, // Primary color for weight
                fontSize: 16, // Slightly larger font for weight
              ),
            ),
          ],
        ),
        const Spacer(), // Flexible space
        _buildLocationColumn(
          'Arrivée',
          trip.arrivalLocation,
          Icons.flight_land, // Good icon choice
        ),
      ],
    );
  }

  Widget _buildLocationColumn(String title, String location, IconData icon) {
    return Expanded(
      flex: 5,
      child: Column(
        crossAxisAlignment: title == 'Départ'
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              color: _lightTextColor,
              fontSize: 13,
            ), // Use light text color for labels
          ),
          const SizedBox(height: 6), // More spacing
          Text(
            location,
            style: GoogleFonts.poppins(
              fontSize: 17, // Slightly larger font for locations
              fontWeight: FontWeight.w600, // Good weight
              color: _darkTextColor, // Black for location names
            ),
            textAlign: title == 'Départ' ? TextAlign.start : TextAlign.end,
            overflow: TextOverflow.ellipsis,
            maxLines: 2, // Allow up to 2 lines for long location names
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, String formattedDate) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date de départ',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: _lightTextColor,
              ), // Use light text color
            ),
            const SizedBox(height: 4),
            Text(
              formattedDate,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700, // Bolder date
                color: _darkTextColor, // Black for the date
                fontSize: 15,
              ),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () {
            // Logique pour initier une discussion ou une demande
            // Idéalement, on passe l'ID du trajet et l'ID du voyageur
            // context.go('/chat/${trip.travelerId}?tripId=${trip.id}');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Fonctionnalité de chat à venir !')),
            );
          },
          icon: const Icon(
            Icons.chat_bubble_outline,
            size: 18,
          ), // Changed icon to chat for more direct meaning
          label: Text(
            'Discuter',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ), // Text style for button
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: _primaryColor, // Primary color for the button
            foregroundColor: Colors.white, // White text/icon on button
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                30,
              ), // More rounded "pill" shape
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ), // More padding
            elevation: 4, // Add slight elevation to button
          ),
        ),
      ],
    );
  }
}
