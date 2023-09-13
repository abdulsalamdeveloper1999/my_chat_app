import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderEmail;

  final String message;

  final String receiverId;
  final Timestamp timeStamp;

  Message({
    required this.message,
    required this.senderId,
    required this.senderEmail,
    required this.receiverId,
    required this.timeStamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': this.senderId,
      'message': this.message,
      'senderEmail': this.senderEmail,
      'receiverId': this.receiverId,
      'timeStamp': this.timeStamp,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'] as String,
      message: map['message'] as String,
      senderEmail: map['senderEmail'] as String,
      receiverId: map['receiverId'] as String,
      timeStamp: map['timeStamp'] as Timestamp,
    );
  }
}
