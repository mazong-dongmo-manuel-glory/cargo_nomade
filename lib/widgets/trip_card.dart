// lib/widgets/trip_card.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Ajoutez intl: ^0.18.1 (ou plus récent) à votre pubspec.yaml
import '../models/trip_model.dart';
import '../models/enums.dart'; // Assurez-vous que le chemin est correct

class TripCard extends StatelessWidget {
  final TripModel trip;
  final VoidCallback? onTap;

  const TripCard({super.key, required this.trip, this.onTap});

  // Helper pour obtenir une icône basée sur le mode de transport
  IconData _getTransportIcon(TransportMode mode) {

    switch (mode) {
      case TransportMode.plane:
        return Icons.airplanemode_active;
      default:
        return Icons.public;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Card(
      // La Card utilise automatiquement le CardTheme de votre thème principal
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      clipBehavior: Clip.antiAlias, // Assure que l'InkWell respecte les coins arrondis
      child: InkWell(
        onTap: onTap,
        splashColor: colorScheme.secondary.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ligne 1: Informations sur le voyageur
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: trip.travelerPhotoUrl != null
                        ? NetworkImage(trip.travelerPhotoUrl!)
                        : null,
                    child: trip.travelerPhotoUrl == null
                        ? Icon(Icons.person, color: colorScheme.primary)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Text(trip.travelerName, style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
                  const Spacer(),
                  Icon(_getTransportIcon(trip.transportMode), color: colorScheme.primary, size: 24),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),

              // Ligne 2: Itinéraire
              Row(
                children: [
                  _buildLocationEndpoint(Icons.flight_takeoff, trip.departureLocation, textTheme, colorScheme),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(Icons.arrow_forward, color: Colors.grey, size: 20),
                  ),
                  _buildLocationEndpoint(Icons.flight_land, trip.arrivalLocation, textTheme, colorScheme),
                ],
              ),
              const SizedBox(height: 16),

              // Ligne 3: Détails
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDetailItem(Icons.calendar_today, "Départ", DateFormat('d MMM yyyy', 'fr_FR').format(trip.departureDate), textTheme, colorScheme),
                    _buildDetailItem(Icons.workspaces, "Dispo.", "${trip.availableWeightKg} kg", textTheme, colorScheme),
                    _buildDetailItem(Icons.sell, "Prix", "${trip.pricePerKg}€/kg", textTheme, colorScheme),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget pour un point de départ ou d'arrivée
  Widget _buildLocationEndpoint(IconData icon, String location, TextTheme textTheme, ColorScheme colorScheme) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, color: colorScheme.primary, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              location,
              style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600, color: colorScheme.onSurface),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Widget pour un détail (date, poids, prix)
  Widget _buildDetailItem(IconData icon, String label, String value, TextTheme textTheme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textTheme.bodySmall?.copyWith(color: colorScheme.primary)),
        const SizedBox(height: 4),
        Text(value, style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
      ],
    );
  }
}