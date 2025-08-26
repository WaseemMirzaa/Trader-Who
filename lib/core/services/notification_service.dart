import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/models.dart';

class NotificationService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Create a notification in Firebase
  static Future<void> createNotification({
    required String recipientId,
    required String type,
    required String title,
    required String message,
    Map<String, dynamic>? data,
  }) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return;

      final notification = NotificationModel(
        recipientId: recipientId,
        senderId: currentUser.uid,
        type: type,
        title: title,
        message: message,
        data: data ?? {},
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection('notifications')
          .add(notification.toFirestore());
      print('✅ Notification created: $type for $recipientId');
    } catch (e) {
      print('❌ Error creating notification: $e');
    }
  }

  /// Create notification when trader submits a quote
  static Future<void> createQuoteSubmittedNotification({
    required String customerId,
    required String bookingId,
    required String quoteId,
    required double quotedPrice,
    required String jobTitle,
  }) async {
    await createNotification(
      recipientId: customerId,
      type: 'quote_submitted',
      title: 'New Quote Received',
      message:
          'You received a quote for £${quotedPrice.toStringAsFixed(2)} for "$jobTitle"',
      data: {
        'bookingId': bookingId,
        'quoteId': quoteId,
        'quotedPrice': quotedPrice,
        'jobTitle': jobTitle,
      },
    );
  }

  /// Create notification when customer accepts a quote
  static Future<void> createQuoteAcceptedNotification({
    required String traderId,
    required String bookingId,
    required String quoteId,
    required String jobTitle,
  }) async {
    await createNotification(
      recipientId: traderId,
      type: 'quote_accepted',
      title: 'Quote Accepted!',
      message: 'Your quote for "$jobTitle" has been accepted',
      data: {'bookingId': bookingId, 'quoteId': quoteId, 'jobTitle': jobTitle},
    );
  }

  /// Create notification when customer rejects a quote
  static Future<void> createQuoteRejectedNotification({
    required String traderId,
    required String bookingId,
    required String quoteId,
    required String jobTitle,
  }) async {
    await createNotification(
      recipientId: traderId,
      type: 'quote_rejected',
      title: 'Quote Rejected',
      message: 'Your quote for "$jobTitle" has been rejected',
      data: {'bookingId': bookingId, 'quoteId': quoteId, 'jobTitle': jobTitle},
    );
  }

  /// Create notification when trader accepts a booking (small job)
  static Future<void> createBookingAcceptedNotification({
    required String customerId,
    required String bookingId,
    required String jobTitle,
  }) async {
    await createNotification(
      recipientId: customerId,
      type: 'booking_accepted',
      title: 'Job Accepted!',
      message: 'A trader has accepted your "$jobTitle" job',
      data: {'bookingId': bookingId, 'jobTitle': jobTitle},
    );
  }

  /// Create notification when trader rejects a booking
  static Future<void> createBookingRejectedNotification({
    required String customerId,
    required String bookingId,
    required String jobTitle,
  }) async {
    await createNotification(
      recipientId: customerId,
      type: 'booking_rejected',
      title: 'Job Declined',
      message: 'A trader has declined your "$jobTitle" job',
      data: {'bookingId': bookingId, 'jobTitle': jobTitle},
    );
  }

  /// Get notifications for a user
  static Future<List<NotificationModel>> getUserNotifications(
    String userId,
  ) async {
    try {
      final querySnapshot =
          await _firestore
              .collection('notifications')
              .where('recipientId', isEqualTo: userId)
              .orderBy('createdAt', descending: true)
              .limit(50)
              .get();

      return querySnapshot.docs
          .map((doc) => NotificationModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('❌ Error fetching notifications: $e');
      return [];
    }
  }

  /// Mark notification as read
  static Future<void> markAsRead(String notificationId) async {
    try {
      await _firestore.collection('notifications').doc(notificationId).update({
        'isRead': true,
      });
    } catch (e) {
      print('❌ Error marking notification as read: $e');
    }
  }

  /// Delete notification
  static Future<void> deleteNotification(String notificationId) async {
    try {
      await _firestore.collection('notifications').doc(notificationId).delete();
    } catch (e) {
      print('❌ Error deleting notification: $e');
    }
  }
}
