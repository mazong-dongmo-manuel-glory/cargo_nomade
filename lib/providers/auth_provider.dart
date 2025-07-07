// FILE: lib/providers/auth_provider.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../models/user_model.dart'; // Assurez-vous que le chemin est correct

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // État de l'UI
  String errorMsg = "";
  bool isLoading = false;
  bool codeIsSent = false;

  // État du formulaire
  bool isAccepted = false;
  bool isValidPhoneNumber = false;

  // Données de l'utilisateur
  User? _user;
  String? fullPhoneNumber;
  PhoneNumber? phoneNumber;

  // Données temporaires pour la création de profil
  String _tempName = "";
  // MODIFIÉ: On stocke le code ISO (ex: "FR", "US")
  String? _tempCountryIsoCode;

  // Getters publics
  User? get user => _user;
  bool get isAuthenticated => _user != null;

  // Méthodes pour mettre à jour l'état depuis l'UI
  void setIsAccepted(bool? value) {
    isAccepted = value ?? false;
    if (isAccepted) clearError();
    notifyListeners();
  }

  void setIsValidPhoneNumber(bool? value) {
    isValidPhoneNumber = value ?? false;
    if (isValidPhoneNumber) clearError();
    notifyListeners();
  }

  void setPhoneNumber(PhoneNumber number) {
    fullPhoneNumber = number.phoneNumber;
    phoneNumber = number;
    // NOUVEAU: On récupère et stocke le code ISO en même temps
    _tempCountryIsoCode = number.isoCode;
  }

  void clearError() {
    errorMsg = "";
    notifyListeners();
  }

  // Logique métier principale

  Future<void> verifyNumber({required String name}) async {
    if (!isAccepted) {
      errorMsg = "Veuillez accepter les conditions d'utilisation.";
      notifyListeners();
      return;
    }
    // MODIFIÉ: On vérifie que le code ISO a bien été récupéré
    if (!isValidPhoneNumber ||
        fullPhoneNumber == null ||
        _tempCountryIsoCode == null) {
      errorMsg = "Veuillez entrer un numéro de téléphone valide.";
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMsg = "";
    notifyListeners();

    _tempName = name;

    await _auth.verifyPhoneNumber(
      phoneNumber: fullPhoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _signInAndCreateUser(credential);
        isLoading = false;
        notifyListeners();
      },
      verificationFailed: (FirebaseAuthException e) {
        isLoading = false;
        _handleVerificationError(e);
        notifyListeners();
      },
      codeSent: (String verificationId, int? resendToken) {
        isLoading = false;
        codeIsSent = true;
        _verificationId = verificationId;
        notifyListeners();
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  String _verificationId = "";

  Future<void> verifyCode(String smsCode) async {
    // ... (le reste de la méthode ne change pas)
    if (smsCode.length != 6) {
      errorMsg = "Le code doit contenir 6 chiffres.";
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMsg = "";
    notifyListeners();

    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: smsCode,
    );

    await _signInAndCreateUser(credential);
    isLoading = false;
    notifyListeners();
  }

  Future<void> _signInAndCreateUser(PhoneAuthCredential credential) async {
    try {
      final userCredential = await _auth.signInWithCredential(credential);
      _user = userCredential.user;

      if (_user != null) {
        final userDoc = await _db.collection('users').doc(_user!.uid).get();

        if (!userDoc.exists) {
          // NOTE: Assurez-vous que votre UserModel peut stocker le code ISO.
          // Par exemple, en ayant un champ `countryOfResidenceIsoCode`
          final newUser = UserModel(
            id: _user!.uid,
            name: _tempName,
            phoneNumber: _user!.phoneNumber!,
            // MODIFIÉ: On utilise le code ISO stocké
            countryOfResidence: _tempCountryIsoCode!,
            createdAt: DateTime.now(),
          );
          await _db.collection('users').doc(newUser.id).set(newUser.toMap());
        }
        codeIsSent = false;
      }
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    }
  }

  void changePhoneNumber() {
    codeIsSent = false;
    clearError();
    _tempName = "";
    // MODIFIÉ: On réinitialise le code ISO
    _tempCountryIsoCode = null;
    phoneNumber = null;
    fullPhoneNumber = null;
    isValidPhoneNumber = false;
    isAccepted = false;
    notifyListeners();
  }

  void _handleVerificationError(FirebaseAuthException error) {
    if (error.code == 'invalid-phone-number') {
      errorMsg = "Le numéro de téléphone fourni n'est pas valide.";
    } else {
      errorMsg = "Une erreur est survenue. Code: ${error.code}";
    }
    notifyListeners();
  }

  void _handleAuthError(FirebaseAuthException error) {
    if (error.code == 'invalid-verification-code') {
      errorMsg = "Le code de vérification est invalide.";
    } else {
      errorMsg = "Code invalide ou expiré.";
    }
    notifyListeners();
  }
}
