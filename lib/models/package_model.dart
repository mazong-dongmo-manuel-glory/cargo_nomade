// models/package_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'enums.dart';

class PackageModel {
  final String id;
  final String senderId;
  final String? tripId;
  final String description;
  final double weightKg;
  final PackageStatus status;
  final String trackingCode;
  final DateTime createdAt;

  PackageModel({
    required this.id,
    required this.senderId,
    this.tripId,
    required this.description,
    required this.weightKg,
    this.status = PackageStatus.pending_approval,
    required this.trackingCode,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'tripId': tripId,
      'description': description,
      'weightKg': weightKg,
      'status': status.name,
      'trackingCode': trackingCode,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory PackageModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return PackageModel(
      id: doc.id,
      senderId: data['senderId'],
      tripId: data['tripId'],
      description: data['description'],
      weightKg: (data['weightKg'] ?? 0.0).toDouble(),
      status: PackageStatus.values.byName(data['status'] ?? 'pending_approval'),
      trackingCode: data['trackingCode'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
