// providers/package_provider.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cargo_nomade/models/package_model.dart';

class PackageProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<PackageModel> _userPackages = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<PackageModel> get userPackages => _userPackages;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Crée un nouveau colis
  Future<bool> createPackage(PackageModel package) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _db.collection('packages').add(package.toMap());
      _error = null;
      // Rafraîchir la liste des colis de l'utilisateur
      await fetchUserPackages(package.senderId);
      return true;
    } catch (e) {
      _error = "Erreur lors de la création du colis: ${e.toString()}";
      print(_error);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Récupère les colis d'un utilisateur spécifique
  Future<void> fetchUserPackages(String userId) async {
    if (userId.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      final querySnapshot = await _db
          .collection('packages')
          .where('senderId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      _userPackages = querySnapshot.docs
          .map(
            (doc) => PackageModel.fromFirestore(
              doc as DocumentSnapshot<Map<String, dynamic>>,
            ),
          )
          .toList();
      _error = null;
    } catch (e) {
      _error = "Erreur lors de la récupération de vos colis: ${e.toString()}";
      print(_error);
      _userPackages = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
