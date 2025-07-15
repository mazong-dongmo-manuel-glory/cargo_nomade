// lib/screens/find_trip_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/trip_provider.dart';
import '../widgets/trip_card.dart';
import '../models/trip_model.dart'; // Importez le modèle pour le typage

class FindTripScreen extends StatefulWidget {
  const FindTripScreen({super.key});

  @override
  State<FindTripScreen> createState() => _FindTripScreenState();
}

class _FindTripScreenState extends State<FindTripScreen> {
  // Contrôleurs et état pour les filtres
  final _departureController = TextEditingController();
  final _arrivalController = TextEditingController();
  DateTime? _selectedDate;
  bool _isFilterPanelVisible = false; // Contrôle la visibilité du panneau

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TripProvider>(context, listen: false).fetchAllTrips();
    });

    _departureController.addListener(() => setState(() {}));
    _arrivalController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _departureController.dispose();
    _arrivalController.dispose();
    super.dispose();
  }

  // Logique de filtrage
  List<TripModel> _getFilteredTrips(List<TripModel> allTrips) {
    if (_departureController.text.isEmpty &&
        _arrivalController.text.isEmpty &&
        _selectedDate == null) {
      return allTrips;
    }
    return allTrips.where((trip) {
      final departureMatch = _departureController.text.isEmpty ||
          trip.departureLocation
              .toLowerCase()
              .contains(_departureController.text.toLowerCase());
      final arrivalMatch = _arrivalController.text.isEmpty ||
          trip.arrivalLocation
              .toLowerCase()
              .contains(_arrivalController.text.toLowerCase());
      final dateMatch = _selectedDate == null ||
          DateUtils.isSameDay(trip.departureDate, _selectedDate);
      return departureMatch && arrivalMatch && dateMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Le corps principal est maintenant un Container avec un Column
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withOpacity(0.1),
            theme.colorScheme.background,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      // SafeArea pour éviter les superpositions avec la barre de statut
      child: SafeArea(
        child: Column(
          children: [
            // --- NOUVEAU : En-tête personnalisé remplaçant l'AppBar ---
            _buildHeader(context),

            // Panneau de filtre animé (inchangé)
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return SizeTransition(sizeFactor: animation, child: child);
              },
              child: _isFilterPanelVisible ? _buildFilterPanel() : const SizedBox.shrink(),
            ),

            // Le Consumer avec la liste des trajets prend l'espace restant
            Expanded(
              child: Consumer<TripProvider>(
                builder: (context, tripProvider, child) {
                  if (tripProvider.isLoading && tripProvider.trips.isEmpty) {
                    return Center(child: CircularProgressIndicator(color: theme.colorScheme.secondary));
                  }
                  if (tripProvider.error != null) {
                    return _buildErrorState(tripProvider);
                  }

                  final filteredTrips = _getFilteredTrips(tripProvider.trips);

                  if (filteredTrips.isEmpty && tripProvider.trips.isNotEmpty) {
                    return _buildNoResultsState();
                  }
                  if (tripProvider.trips.isEmpty) {
                    return _buildEmptyState();
                  }

                  return RefreshIndicator(
                    onRefresh: () => tripProvider.fetchAllTrips(),
                    backgroundColor: theme.colorScheme.primary,
                    color: theme.colorScheme.onPrimary,
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                      itemCount: filteredTrips.length,
                      itemBuilder: (context, index) {
                        final trip = filteredTrips[index];
                        return TripCard(
                          trip: trip,
                          onTap: () => print("Tapped on trip ${trip.id}"),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- NOUVEAU : Widget pour l'en-tête personnalisé ---
  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Trajets Disponibles',
            // Utilise un style de texte du thème pour la cohérence
            style: theme.textTheme.displaySmall?.copyWith(fontSize: 24),
          ),
          IconButton(
            icon: Icon(
              _isFilterPanelVisible ? Icons.filter_list_off : Icons.filter_list,
              color: theme.colorScheme.onSurface,
            ),
            onPressed: () {
              setState(() {
                _isFilterPanelVisible = !_isFilterPanelVisible;
              });
            },
          ),
        ],
      ),
    );
  }

  // --- Le reste des widgets est inchangé ---

  // Widget pour le panneau de filtres
  Widget _buildFilterPanel() {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: theme.colorScheme.primary.withOpacity(0.05),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _departureController,
                  decoration: const InputDecoration(hintText: 'Départ', prefixIcon: Icon(Icons.flight_takeoff)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _arrivalController,
                  decoration: const InputDecoration(hintText: 'Arrivée', prefixIcon: Icon(Icons.flight_land)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.calendar_today),
                  label: Text(_selectedDate == null
                      ? 'Choisir une date'
                      : DateFormat('d MMM yyyy', 'fr_FR').format(_selectedDate!)),
                  onPressed: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate ?? DateTime.now(),
                      firstDate: DateTime.now().subtract(const Duration(days: 30)),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _selectedDate = pickedDate;
                      });
                    }
                  },
                ),
              ),
              if (_selectedDate != null)
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _selectedDate = null;
                    });
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget pour l'état "aucun résultat de recherche"
  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey.shade600),
          const SizedBox(height: 16),
          Text(
            "Aucun résultat",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 8),
          Text(
            "Essayez d'ajuster vos filtres.",
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Widget pour l'état vide
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.map_outlined, size: 80, color: Colors.grey.shade600),
          const SizedBox(height: 16),
          Text(
            "Aucun trajet disponible",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 8),
          Text(
            "Revenez plus tard ou proposez le vôtre !",
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Widget pour l'état d'erreur
  Widget _buildErrorState(TripProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Theme.of(context).colorScheme.error),
          const SizedBox(height: 16),
          Text(
            "Oups, une erreur est survenue",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            provider.error!,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text("Réessayer"),
            onPressed: () => provider.fetchAllTrips(),
          ),
        ],
      ),
    );
  }
}