import 'package:cargo_nomade/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/trip_model.dart';
import '../models/enums.dart'; // Fichier avec les Enums
import '../providers/auth_provider.dart';
import '../providers/trip_provider.dart';
import '../providers/user_provider.dart';

class ProposeTripScreen extends StatefulWidget {
  const ProposeTripScreen({super.key});

  @override
  State<ProposeTripScreen> createState() => _ProposeTripScreenState();
}

class _ProposeTripScreenState extends State<ProposeTripScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers pour les champs du formulaire
  final _departureController = TextEditingController();
  final _arrivalController = TextEditingController();
  final _dateController = TextEditingController();
  final _weightController = TextEditingController();
  final _priceController = TextEditingController();
  final Color _primaryColor = const Color(0xFF0D5159);

  // Variables d'état pour les autres champs
  DateTime? _selectedDate;
  TransportMode _selectedTransportMode = TransportMode.plane;
  bool _isNegotiable = false;

  @override
  void dispose() {
    // Nettoyer les controllers pour éviter les fuites de mémoire
    _departureController.dispose();
    _arrivalController.dispose();
    _dateController.dispose();
    _weightController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0D5159), // Couleur principale du picker
              onPrimary: Colors.white,
              onSurface: Colors.black, // Couleur du texte dans le calendrier
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.black),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _submitForm() async {
    // 1. Valider le formulaire
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // 2. Vérifier si l'utilisateur est connecté et a un profil
    final authProvider = context.read<AuthProvider>();
    final userProvider = context.read<UserProvider>();

    if (!authProvider.isAuthenticated || userProvider.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Erreur: Utilisateur non identifié. Veuillez vous reconnecter.",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final currentUser = userProvider.currentUser!;

    // 3. Créer l'objet TripModel
    final newTrip = TripModel(
      id: '', // Firestore générera l'ID
      travelerId: currentUser.id,
      travelerName: currentUser.name,
      travelerPhotoUrl: currentUser.profilePhotoUrl,
      departureLocation: _departureController.text.trim(),
      arrivalLocation: _arrivalController.text.trim(),
      departureDate: _selectedDate!,
      availableWeightKg: double.tryParse(_weightController.text) ?? 0.0,
      pricePerKg: double.tryParse(_priceController.text) ?? 0.0,
      isNegotiable: _isNegotiable,
      transportMode: _selectedTransportMode,
      status: TripStatus.available,
      createdAt: DateTime.now(),
    );

    // 4. Appeler le provider pour sauvegarder le trajet
    final tripProvider = context.read<TripProvider>();
    final success = await tripProvider.createTrip(newTrip);

    // 5. Afficher un retour à l'utilisateur
    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Votre trajet a été publié avec succès !"),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/'); // Retour à la page d'accueil ou précédente
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(tripProvider.error ?? "Une erreur est survenue."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tripProvider = context.watch<TripProvider>();

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white, // AppBar background white
        elevation: 0,
        shadowColor: Colors.transparent, // No shadow for a cleaner look
        toolbarHeight: 80, // Slightly taller app bar for better spacing
        title: Text(
          'Trouver un transporteur',
          style: GoogleFonts.poppins(
            color: _primaryColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 700),
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (context, double value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: SvgPicture.asset(
                    'assets/vectors/propose_trip.svg',
                    height: 250,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              _buildSectionTitle('Détails du voyage'),
              _buildTextField(
                controller: _departureController,
                label: 'Lieu de départ',
                hint: 'Ex: Paris, France',
                icon: Icons.flight_takeoff,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _arrivalController,
                label: 'Lieu d\'arrivée',
                hint: 'Ex: Dakar, Sénégal',
                icon: Icons.flight_land,
              ),
              const SizedBox(height: 16),
              _buildDatePicker(),
              const SizedBox(height: 32),

              _buildSectionTitle('Capacité et Prix'),
              _buildTextField(
                controller: _weightController,
                label: 'Poids disponible (kg)',
                hint: 'Ex: 23',
                icon: Icons.inventory_2_outlined,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _priceController,
                label: 'Prix par kg (€)',
                hint: 'Ex: 10',
                icon: Icons.euro_symbol,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildSwitchTile(),
              const SizedBox(height: 16),
              _buildTransportModeSelector(),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: tripProvider.isLoading ? null : _submitForm,
                  icon: tripProvider.isLoading
                      ? Container()
                      : const Icon(
                          Icons.check_circle_outline,
                          color: Colors.white,
                        ),
                  label: tripProvider.isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.white,
                          ),
                        )
                      : Text('Publier le trajet'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color(0xFF0D5159),
                    foregroundColor: Colors.white,
                    textStyle: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: buildBottomNavBar(context),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF0D5159),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      // MODIFICATION : Ajout du style pour le texte saisi par l'utilisateur
      style: GoogleFonts.poppins(
        color: Colors.black, // Le texte sera noir
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF0D5159), width: 2),
        ),
        labelStyle: GoogleFonts.poppins(color: Colors.black54),
        hintStyle: GoogleFonts.poppins(color: Colors.grey),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Ce champ est obligatoire';
        }
        if (keyboardType == TextInputType.number) {
          if (double.tryParse(value) == null || double.parse(value) <= 0) {
            return 'Veuillez entrer un nombre positif valide';
          }
        }
        return null;
      },
    );
  }

  Widget _buildDatePicker() {
    return TextFormField(
      controller: _dateController,
      readOnly: true,
      onTap: () => _selectDate(context),
      // MODIFICATION : Ajout du style pour la date affichée
      style: GoogleFonts.poppins(
        color: Colors.black, // La date sera en noir
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: 'Date de départ',
        hintText: 'Sélectionnez une date',
        prefixIcon: Icon(Icons.calendar_today, color: Colors.grey[600]),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF0D5159), width: 2),
        ),
        labelStyle: GoogleFonts.poppins(color: Colors.black54),
        hintStyle: GoogleFonts.poppins(color: Colors.grey),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez sélectionner une date';
        }
        return null;
      },
    );
  }

  Widget _buildSwitchTile() {
    return SwitchListTile(
      title: Text(
        'Prix négociable ?',
        // MODIFICATION : Style plus explicite pour la lisibilité
        style: GoogleFonts.poppins(
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      value: _isNegotiable,
      onChanged: (bool value) {
        setState(() {
          _isNegotiable = value;
        });
      },
      activeColor: const Color(0xFF0D5159),
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildTransportModeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mode de transport',
          style: GoogleFonts.poppins(color: Colors.black54, fontSize: 14),
        ),
        const SizedBox(height: 8),
        SegmentedButton<TransportMode>(
          segments: <ButtonSegment<TransportMode>>[
            ButtonSegment<TransportMode>(
              value: TransportMode.plane,
              label: Text('Avion', style: GoogleFonts.poppins()),
              icon: const Icon(Icons.airplanemode_active),
            ),
            ButtonSegment<TransportMode>(
              value: TransportMode.container,
              label: Text('Conteneur', style: GoogleFonts.poppins()),
              icon: const Icon(Icons.local_shipping),
            ),
          ],
          selected: {_selectedTransportMode},
          onSelectionChanged: (Set<TransportMode> newSelection) {
            setState(() {
              _selectedTransportMode = newSelection.first;
            });
          },
          style: SegmentedButton.styleFrom(
            backgroundColor: Colors.grey[200],
            selectedBackgroundColor: const Color(0xFF0D5159),
            selectedForegroundColor: Colors.white,
            foregroundColor: const Color(0xFF0D5159),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}
