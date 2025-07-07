// FILE: lib/providers/user_provider.dart (VERSION MISE À JOUR ET COMPLÈTE)

import 'dart:async'; // <-- N'oubliez pas cet import !
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // <-- N'oubliez pas cet import !
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart'; // Assurez-vous que le chemin est correct

class UserProvider extends ChangeNotifier {
  // On ajoute les instances de Firebase Auth et Firestore ici
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // On garde cet écouteur pour la magie en arrière-plan
  StreamSubscription? _authStateSubscription;

  UserModel? _currentUser;
  // MODIFIÉ : Commence à true pour gérer le chargement initial de l'état d'auth
  bool _isLoading = true;
  String? _error;

  // --- GETTERS ---
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // NOUVEAU GETTER : C'est ce qui manquait pour votre GoRouter !
  // La source de vérité pour l'authentification.
  bool get isAuthenticated => _currentUser != null;

  // --- CONSTRUCTEUR ---
  UserProvider() {
    // Dès que le provider est créé, il commence à écouter les changements d'état
    _authStateSubscription = _auth.authStateChanges().listen(
      _onAuthStateChanged,
    );
  }

  // --- LOGIQUE D'ÉCOUTE D'AUTHENTIFICATION ---
  // Cette méthode est appelée AUTOMATIQUEMENT par Firebase Auth
  // chaque fois qu'un utilisateur se connecte ou se déconnecte.
  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    // Si on n'est pas déjà en train de charger, on indique qu'on commence
    if (!_isLoading) {
      _isLoading = true;
      notifyListeners();
    }

    if (firebaseUser == null) {
      // L'utilisateur s'est déconnecté
      _currentUser = null;
    } else {
      // L'utilisateur est connecté, on va chercher son profil dans Firestore
      await fetchCurrentUser(firebaseUser.uid);
    }

    // On a fini de charger l'état
    _isLoading = false;
    notifyListeners();
  }

  // --- MÉTHODES EXISTANTES (légèrement ajustées) ---

  // Récupère les informations de l'utilisateur depuis Firestore par son UID
  Future<void> fetchCurrentUser(String uid) async {
    // Pas besoin de gérer isLoading ici, c'est fait dans _onAuthStateChanged
    try {
      final doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        _currentUser = UserModel.fromFirestore(
          doc as DocumentSnapshot<Map<String, dynamic>>,
        );
      } else {
        // Cas rare : l'utilisateur est authentifié dans Firebase
        // mais son document n'existe pas dans Firestore.
        _error = "Profil utilisateur non trouvé dans la base de données.";
        _currentUser = null;
        // On pourrait vouloir le déconnecter pour forcer une recréation propre
        // await signOut();
      }
      _error = null;
    } catch (e) {
      _error = "Erreur lors de la récupération du profil: ${e.toString()}";
      print(_error);
      _currentUser = null;
    }
    // On notifie les listeners car les données ont changé
    notifyListeners();
  }

  // Cette méthode reste utile si vous créez le profil séparément de l'auth
  Future<bool> createUserProfile(UserModel user) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _db.collection('users').doc(user.id).set(user.toMap());
      _currentUser = user; // On met à jour l'état local immédiatement
      _error = null;
      return true;
    } catch (e) {
      _error = "Erreur lors de la création du profil: ${e.toString()}";
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Méthode pour se déconnecter proprement
  Future<void> signOut() async {
    await _auth.signOut();
    // Le listener _onAuthStateChanged s'occupera de mettre _currentUser à null
  }

  // N'oubliez jamais de nettoyer l'écouteur !
  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }

  // Votre méthode updateUserProfile reste ici
  Future<void> updateUserProfile(UserModel user) async {
    // Logique pour mettre à jour le profil
    // ...
    notifyListeners();
  }

  // Cette méthode n'est plus nécessaire car _onAuthStateChanged s'en occupe
  // void clearUser() {
  //   _currentUser = null;
  //   notifyListeners();
  // }
}
