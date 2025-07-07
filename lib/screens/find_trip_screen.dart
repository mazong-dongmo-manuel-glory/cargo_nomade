import 'package:cargo_nomade/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // Keep if you use it in TripCard or elsewhere
import 'package:go_router/go_router.dart'; // Keep if you use it for navigation

import '../models/trip_model.dart';
import '../models/enums.dart'; // Keep if you use it
import '../providers/trip_provider.dart';
import '../widgets/trip_card.dart'; // Make sure TripCard is styled appropriately

class FindTripScreen extends StatefulWidget {
  const FindTripScreen({super.key});

  @override
  State<FindTripScreen> createState() => _FindTripScreenState();
}

class _FindTripScreenState extends State<FindTripScreen> {
  final _searchController = TextEditingController();
  bool _showResults =
      false; // Renamed from _showFilters to be more semantically correct
  List<TripModel> _filteredTrips = [];

  // Define your theme colors for consistency
  final Color _primaryColor = const Color(
    0xFF0D5159,
  ); // Dark Teal from your images
  final Color _backgroundColor = const Color(
    0xFFF0F5F5,
  ); // Light beige/off-white from second image

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch all trips initially to populate if search is empty
      final tripProvider = Provider.of<TripProvider>(context, listen: false);
      tripProvider.fetchAllTrips().then((_) {
        if (mounted) {
          setState(() {
            _filteredTrips = tripProvider.trips; // Initialize with all trips
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterTrips(String query) {
    final allTrips = Provider.of<TripProvider>(context, listen: false).trips;
    final filtered = allTrips
        .where(
          (trip) =>
              trip.departureLocation.toLowerCase().contains(
                query.toLowerCase(),
              ) ||
              trip.arrivalLocation.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    setState(() {
      _filteredTrips = filtered;
      _showResults = true; // Show results as soon as filtering happens
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor, // Use the new background color
      appBar: AppBar(
        backgroundColor: Colors.white, // AppBar background white
        elevation: 0, // No shadow for a cleaner look
        toolbarHeight: 80, // Slightly taller app bar for better spacing
        title: Text(
          'Trouver un transporteur',
          style: GoogleFonts.poppins(
            color: _primaryColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false, // Align title to the left
        // If you need a back button, it's automatically added by GoRouter or you can add IconButton
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back_ios, color: _primaryColor),
        //   onPressed: () => context.pop(),
        // ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(
            60.0,
          ), // Height for the search bar
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 8.0,
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (query) {
                _filterTrips(query);
                if (query.isEmpty) {
                  setState(() {
                    _showResults = false; // Hide results if search bar is empty
                  });
                }
              },
              onTap: () {
                // Show results even if search is empty, but clicked
                setState(() => _showResults = true);
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[100], // A very light grey for the fill
                prefixIcon: Icon(
                  Icons.search,
                  color: _primaryColor.withOpacity(0.7),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey[500]),
                        onPressed: () {
                          _searchController.clear();
                          _filterTrips(''); // Clear filter
                          setState(() {
                            _showResults = false; // Go back to initial state
                          });
                        },
                      )
                    : null,
                hintText: 'Rechercher un lieu...',
                hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none, // No border line
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14.0,
                  horizontal: 16.0,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: _showResults
            ? (_filteredTrips.isEmpty
                  ? _buildEmptyState()
                  : Padding(
                      padding: const EdgeInsets.only(
                        top: 16.0,
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: ListView.builder(
                        itemCount: _filteredTrips.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: TripCard(trip: _filteredTrips[index]),
                          );
                        },
                      ),
                    ))
            : _buildInitialState(), // Show initial state when no search is performed
      ),
      bottomNavigationBar: buildBottomNavBar(context),
    );
  }

  Widget _buildInitialState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/vectors/find_trip.svg',
          height: 250, // Slightly larger SVG
          width: 250,
        ),
        const SizedBox(height: 30),
        Text(
          'Prêt à envoyer un colis ?',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: _primaryColor.withOpacity(0.9),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Text(
            'Recherchez un transporteur pour trouver le meilleur itinéraire pour votre colis.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
        const SizedBox(height: 16),
        Text(
          'Aucun trajet trouvé',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Text(
            'Essayez un autre lieu de départ ou d’arrivée.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(color: Colors.grey[500]),
          ),
        ),
      ],
    );
  }
}
