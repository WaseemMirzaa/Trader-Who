import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String id; // senderId_receiverId
  final String senderId;
  final String receiverId;
  final String lastMessage;
  final String lastMessageSentBy;
  final Timestamp lastMessageTime;
  final int senderUnreadCount;
  final int receiverUnreadCount;
  final bool isOrderChat;
  final String? orderId;

  ChatModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.lastMessage,
    required this.lastMessageSentBy,
    required this.lastMessageTime,
    required this.senderUnreadCount,
    required this.receiverUnreadCount,
    required this.isOrderChat,
    this.orderId,
  });

  factory ChatModel.fromMap(Map<String, dynamic> map, String docId) {
    return ChatModel(
      id: docId,
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      lastMessage: map['lastMessage'] ?? '',
      lastMessageSentBy: map['lastMessageSentBy'] ?? '',
      lastMessageTime: map['lastMessageTime'] ?? Timestamp.now(),
      senderUnreadCount: map['senderUnreadCount'] ?? 0,
      receiverUnreadCount: map['receiverUnreadCount'] ?? 0,
      isOrderChat: map['isOrderChat'] ?? false,
      orderId: map['orderId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'lastMessage': lastMessage,
      'lastMessageSentBy': lastMessageSentBy,
      'lastMessageTime': lastMessageTime,
      'senderUnreadCount': senderUnreadCount,
      'receiverUnreadCount': receiverUnreadCount,
      'isOrderChat': isOrderChat,
      'orderId': orderId,
    };
  }
}
