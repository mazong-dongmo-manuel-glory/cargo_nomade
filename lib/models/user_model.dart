// models/user_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String phoneNumber;
  final String countryOfResidence;
  final String? profilePhotoUrl;
  final double averageRating;
  final int ratingCount;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.countryOfResidence,
    this.profilePhotoUrl,
    this.averageRating = 0.0,
    this.ratingCount = 0,
    required this.createdAt,
  });

  // Convertit un UserModel en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'countryOfResidence': countryOfResidence,
      'profilePhotoUrl': profilePhotoUrl,
      'averageRating': averageRating,
      'ratingCount': ratingCount,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Crée un UserModel à partir d'un DocumentSnapshot de Firestore
  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return UserModel(
      id: doc.id,
      name: data['name'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      countryOfResidence: data['countryOfResidence'] ?? '',
      profilePhotoUrl: data['profilePhotoUrl'],
      averageRating: (data['averageRating'] ?? 0.0).toDouble(),
      ratingCount: data['ratingCount'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
