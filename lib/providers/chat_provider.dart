// providers/chat_provider.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message_model.dart'; // Assurez-vous que le chemin est correct

class ChatProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  StreamSubscription? _messageSubscription;

  List<MessageModel> _messages = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<MessageModel> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Écoute en temps réel les messages d'une conversation
  void getChatMessages(String chatId) {
    _isLoading = true;
    notifyListeners();

    _messageSubscription?.cancel(); // Annule l'écoute précédente
    _messageSubscription = _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen(
          (snapshot) {
            _messages = snapshot.docs
                .map(
                  (doc) => MessageModel.fromFirestore(
                    doc as DocumentSnapshot<Map<String, dynamic>>,
                  ),
                )
                .toList();
            _error = null;
            _isLoading = false;
            notifyListeners();
          },
          onError: (e) {
            _error = "Erreur de chargement des messages: ${e.toString()}";
            _isLoading = false;
            notifyListeners();
          },
        );
  }

  // Envoie un message
  Future<void> sendMessage(String chatId, String text, String senderId) async {
    if (text.trim().isEmpty) return;

    try {
      final message = MessageModel(
        senderId: senderId,
        text: text,
        timestamp: DateTime.now(),
      );

      // Ajoute le message à la sous-collection
      await _db
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add(message.toMap());

      // Met à jour le dernier message sur le document principal du chat pour l'aperçu
      await _db.collection('chats').doc(chatId).update({
        'lastMessage': text,
        'lastMessageTimestamp': message.timestamp,
      });
    } catch (e) {
      print("Erreur d'envoi du message: ${e.toString()}");
      // Gérer l'erreur, peut-être avec une variable d'état
    }
  }

  // Très important : Nettoyer le StreamSubscription pour éviter les fuites de mémoire
  @override
  void dispose() {
    _messageSubscription?.cancel();
    super.dispose();
  }
}
