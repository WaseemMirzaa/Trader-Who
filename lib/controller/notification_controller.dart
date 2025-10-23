import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../models/models.dart';
import '../core/services/notification_service.dart';

class NotificationController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var notifications = <QuoteNotification>[].obs;
  var systemNotifications = <NotificationModel>[].obs;
  var isLoading = false.obs;
  var unreadCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
    fetchSystemNotifications();
    listenToNotifications();
  }

  /// Listen to real-time notification updates
  void listenToNotifications() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    _firestore
        .collection('notifications')
        .where('recipientId', isEqualTo: currentUser.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
          systemNotifications.value =
              snapshot.docs
                  .map((doc) => NotificationModel.fromFirestore(doc))
                  .toList();

          // Update unread count
          unreadCount.value =
              systemNotifications
                  .where((notification) => !notification.isRead)
                  .length;
        });
  }

  /// Fetch system notifications from NotificationService
  Future<void> fetchSystemNotifications() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return;

      final notifications = await NotificationService.getUserNotifications(
        currentUser.uid,
      );
      systemNotifications.value = notifications;

      // Calculate unread count
      unreadCount.value =
          notifications.where((notification) => !notification.isRead).length;
    } catch (e) {
      print('❌ Error fetching system notifications: $e');
    }
  }

  /// Mark a notification as read
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await NotificationService.markAsRead(notificationId);

      // Update local state
      final index = systemNotifications.indexWhere(
        (n) => n.id == notificationId,
      );
      if (index != -1) {
        systemNotifications[index] = systemNotifications[index].copyWith(
          isRead: true,
        );
        systemNotifications.refresh();

        // Update unread count
        unreadCount.value =
            systemNotifications
                .where((notification) => !notification.isRead)
                .length;
      }
    } catch (e) {
      print('❌ Error marking notification as read: $e');
    }
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    try {
      for (var notification in systemNotifications) {
        if (!notification.isRead && notification.id != null) {
          await NotificationService.markAsRead(notification.id!);
        }
      }

      // Update local state
      systemNotifications.value =
          systemNotifications.map((n) => n.copyWith(isRead: true)).toList();
      unreadCount.value = 0;
    } catch (e) {
      print('❌ Error marking all as read: $e');
    }
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;

      final currentUser = _auth.currentUser;
      if (currentUser == null) return;

      // Check user type to determine notification types
      final userDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();
      final userData = userDoc.data() ?? {};
      final isCustomer =
          userData['user_type'] == null || userData['user_type'] == 'customer';

      List<QuoteNotification> allNotifications = [];

      if (isCustomer) {
        // For customers: Show quotes received for their bookings
        await _fetchCustomerNotifications(currentUser.uid, allNotifications);
      } else {
        // For traders: Show quote acceptance/rejection notifications
        await _fetchTraderNotifications(currentUser.uid, allNotifications);
      }

      // Sort by timestamp (newest first)
      allNotifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      notifications.value = allNotifications;
    } catch (e) {
      print('❌ Error fetching notifications: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchCustomerNotifications(
    String customerId,
    List<QuoteNotification> notifications,
  ) async {
    try {
      // Get quotes for customer's bookings
      final quotesQuery =
          await _firestore
              .collection('quotes')
              .where('customerId', isEqualTo: customerId)
              .orderBy('createdAt', descending: true)
              .limit(20)
              .get();

      for (var quoteDoc in quotesQuery.docs) {
        final quote = QuoteModel.fromFirestore(quoteDoc);

        // Get trader info
        final traderDoc =
            await _firestore.collection('users').doc(quote.traderId).get();
        final traderData = traderDoc.data() ?? {};
        final traderName = traderData['name'] ?? 'Unknown Trader';
        final traderImage = traderData['image'] ?? '';

        // Get booking info for context
        final bookingDoc =
            await _firestore.collection('bookings').doc(quote.bookingId).get();
        final bookingData = bookingDoc.data() ?? {};
        final jobTitle = bookingData['title'] ?? 'Job';

        String description;
        String actionType = '';

        switch (quote.status) {
          case 'pending':
            description =
                'New quote received for $jobTitle - £${quote.quotedPrice.toStringAsFixed(2)}';
            actionType = 'quote_received';
            break;
          case 'accepted':
            description = 'Quote accepted for $jobTitle';
            actionType = 'quote_accepted';
            break;
          case 'rejected':
            description = 'Quote rejected for $jobTitle';
            actionType = 'quote_rejected';
            break;
          case 'expired':
            description = 'Quote expired for $jobTitle';
            actionType = 'quote_expired';
            break;
          default:
            description = 'Quote update for $jobTitle';
            actionType = 'quote_update';
        }

        notifications.add(
          QuoteNotification(
            id: quote.id ?? '',
            title: traderName,
            description: description,
            timestamp: quote.createdAt ?? DateTime.now(),
            avatarImage: traderImage,
            actionType: actionType,
            quote: quote,
          ),
        );
      }
    } catch (e) {
      print('❌ Error fetching customer notifications: $e');
    }
  }

  Future<void> _fetchTraderNotifications(
    String traderId,
    List<QuoteNotification> notifications,
  ) async {
    try {
      // Get quotes submitted by this trader
      final quotesQuery =
          await _firestore
              .collection('quotes')
              .where('traderId', isEqualTo: traderId)
              .where('status', whereIn: ['accepted', 'rejected'])
              .orderBy('updatedAt', descending: true)
              .limit(20)
              .get();

      for (var quoteDoc in quotesQuery.docs) {
        final quote = QuoteModel.fromFirestore(quoteDoc);

        // Get customer info
        final customerDoc =
            await _firestore.collection('users').doc(quote.customerId).get();
        final customerData = customerDoc.data() ?? {};
        final customerName = customerData['name'] ?? 'Customer';
        final customerImage = customerData['image'] ?? '';

        // Get booking info for context
        final bookingDoc =
            await _firestore.collection('bookings').doc(quote.bookingId).get();
        final bookingData = bookingDoc.data() ?? {};
        final jobTitle = bookingData['title'] ?? 'Job';

        String description;
        String actionType;

        if (quote.status == 'accepted') {
          description = 'Your quote for $jobTitle was accepted!';
          actionType = 'quote_accepted_by_customer';
        } else {
          description = 'Your quote for $jobTitle was rejected';
          actionType = 'quote_rejected_by_customer';
        }

        notifications.add(
          QuoteNotification(
            id: quote.id ?? '',
            title: customerName,
            description: description,
            timestamp: quote.updatedAt ?? quote.createdAt ?? DateTime.now(),
            avatarImage: customerImage,
            actionType: actionType,
            quote: quote,
          ),
        );
      }
    } catch (e) {
      print('❌ Error fetching trader notifications: $e');
    }
  }

  void markAsRead(String notificationId) {
    // Implementation for marking notification as read
    // This could update a separate notifications collection in Firestore
  }
}

class QuoteNotification {
  final String id;
  final String title;
  final String description;
  final DateTime timestamp;
  final String avatarImage;
  final String actionType;
  final QuoteModel quote;

  QuoteNotification({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.avatarImage,
    required this.actionType,
    required this.quote,
  });

  String get formattedTime {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
