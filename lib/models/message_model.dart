// models/message_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String senderId;
  final String text;
  final DateTime timestamp;

  MessageModel({
    required this.senderId,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'text': text,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  factory MessageModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return MessageModel(
      senderId: data['senderId'],
      text: data['text'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}
