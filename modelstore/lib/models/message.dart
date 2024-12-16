import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderEmail;
  final String recipientId;
  final String message;
  final Timestamp sentAt;

  Message({
    required this.senderId,
    required this.senderEmail,
    required this.recipientId,
    required this.message,
    required this.sentAt,
  });

  // Конвертация в JSON
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'recipientId': recipientId,
      'message': message,
      'sentAt': sentAt,
    };
  }
}
