// models/trip_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'enums.dart'; // Fichier où vous avez défini les enums

class TripModel {
  final String id;
  final String travelerId;
  final String travelerName;
  final String? travelerPhotoUrl;
  final String departureLocation;
  final String arrivalLocation;
  final DateTime departureDate;
  final double availableWeightKg;
  final double pricePerKg;
  final bool isNegotiable;
  final TransportMode transportMode;
  final TripStatus status;
  final DateTime createdAt;

  TripModel({
    required this.id,
    required this.travelerId,
    required this.travelerName,
    this.travelerPhotoUrl,
    required this.departureLocation,
    required this.arrivalLocation,
    required this.departureDate,
    required this.availableWeightKg,
    required this.pricePerKg,
    required this.isNegotiable,
    required this.transportMode,
    this.status = TripStatus.available,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'travelerId': travelerId,
      'travelerName': travelerName,
      'travelerPhotoUrl': travelerPhotoUrl,
      'departureLocation': departureLocation,
      'arrivalLocation': arrivalLocation,
      'departureDate': Timestamp.fromDate(departureDate),
      'availableWeightKg': availableWeightKg,
      'pricePerKg': pricePerKg,
      'isNegotiable': isNegotiable,
      'transportMode': transportMode.name, // Convertit l'enum en String
      'status': status.name,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory TripModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return TripModel(
      id: doc.id,
      travelerId: data['travelerId'],
      travelerName: data['travelerName'],
      travelerPhotoUrl: data['travelerPhotoUrl'],
      departureLocation: data['departureLocation'],
      arrivalLocation: data['arrivalLocation'],
      departureDate: (data['departureDate'] as Timestamp).toDate(),
      availableWeightKg: (data['availableWeightKg'] ?? 0.0).toDouble(),
      pricePerKg: (data['pricePerKg'] ?? 0.0).toDouble(),
      isNegotiable: data['isNegotiable'] ?? false,
      transportMode: TransportMode.values.byName(
        data['transportMode'] ?? 'plane',
      ),
      status: TripStatus.values.byName(data['status'] ?? 'available'),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
