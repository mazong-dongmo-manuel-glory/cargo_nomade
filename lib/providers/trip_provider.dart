// providers/trip_provider.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/trip_model.dart'; // Assurez-vous que le chemin est correct

class TripProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<TripModel> _trips = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<TripModel> get trips => _trips;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Crée un nouveau trajet
  Future<bool> createTrip(TripModel trip) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _db.collection('trips').add(trip.toMap());
      _error = null;
      // Optionnel : rafraîchir la liste des trajets après la création
      await fetchAllTrips();
      return true;
    } catch (e) {
      _error = "Erreur lors de la publication du trajet: ${e.toString()}";
      print(_error);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Récupère tous les trajets disponibles
  Future<void> fetchAllTrips() async {
    _isLoading = true;
    notifyListeners();

    try {
      final querySnapshot = await _db
          .collection('trips')
          .where(
            'status',
            isEqualTo: 'available',
          ) // Ne récupère que les trajets disponibles
          .orderBy('departureDate', descending: true)
          .get();

      _trips = querySnapshot.docs
          .map(
            (doc) => TripModel.fromFirestore(
              doc as DocumentSnapshot<Map<String, dynamic>>,
            ),
          )
          .toList();
      _error = null;
    } catch (e) {
      _error = "Erreur lors de la récupération des trajets: ${e.toString()}";
      print(_error);
      _trips = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
