part of 'models.dart';

class NotificationModel {
  final String? id;
  final String recipientId; // User who will receive the notification
  final String senderId; // User who triggered the notification
  final String
  type; // 'quote_submitted', 'quote_accepted', 'quote_rejected', 'booking_accepted', 'booking_rejected'
  final String title;
  final String message;
  final Map<String, dynamic>
  data; // Additional data like bookingId, quoteId, etc.
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    this.id,
    required this.recipientId,
    required this.senderId,
    required this.type,
    required this.title,
    required this.message,
    required this.data,
    this.isRead = false,
    required this.createdAt,
  });

  NotificationModel copyWith({
    String? id,
    String? recipientId,
    String? senderId,
    String? type,
    String? title,
    String? message,
    Map<String, dynamic>? data,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      recipientId: recipientId ?? this.recipientId,
      senderId: senderId ?? this.senderId,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      data: data ?? this.data,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'recipientId': recipientId,
      'senderId': senderId,
      'type': type,
      'title': title,
      'message': message,
      'data': data,
      'isRead': isRead,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  static NotificationModel fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NotificationModel(
      id: doc.id,
      recipientId: data['recipientId'] ?? '',
      senderId: data['senderId'] ?? '',
      type: data['type'] ?? '',
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      data: Map<String, dynamic>.from(data['data'] ?? {}),
      isRead: data['isRead'] ?? false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(data['createdAt'] ?? 0),
    );
  }

  static NotificationModel fromMap(Map<String, dynamic> data) {
    return NotificationModel(
      id: data['id'],
      recipientId: data['recipientId'] ?? '',
      senderId: data['senderId'] ?? '',
      type: data['type'] ?? '',
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      data: Map<String, dynamic>.from(data['data'] ?? {}),
      isRead: data['isRead'] ?? false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(data['createdAt'] ?? 0),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'recipientId': recipientId,
      'senderId': senderId,
      'type': type,
      'title': title,
      'message': message,
      'data': data,
      'isRead': isRead,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }
}
