import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traderou/controller/navigation_controller.dart';
import 'package:traderou/core/shared_widgets/custom_button.dart';
import 'package:traderou/core/shared_widgets/custom_text.dart';
import 'package:traderou/core/theme/app_color.dart';
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
      if (kDebugMode) {
        print('✅ Notification created: $type for $recipientId');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error creating notification: $e');
      }
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
      if (kDebugMode) {
        print('❌ Error fetching notifications: $e');
      }
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
      if (kDebugMode) {
        print('❌ Error marking notification as read: $e');
      }
    }
  }

  /// Delete notification
  static Future<void> deleteNotification(String notificationId) async {
    try {
      await _firestore.collection('notifications').doc(notificationId).delete();
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error deleting notification: $e');
      }
    }
  }

  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<bool?> _checkNotificationPermission() async {
    bool? accepted;
    try {
      NotificationSettings settings =
          await _messaging.getNotificationSettings();
      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        accepted = true;
      } else {
        accepted = false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error checking notification permission: $e');
      }
      accepted = false;
    }
    return accepted;
  }

  static Future<void> _subscribeToNotifications() async {
    try {
      await FirebaseMessaging.instance.subscribeToTopic(
        FirebaseAuth.instance.currentUser!.uid,
      );
      if (kDebugMode) {
        print('Subscribed to notifications');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error subscribing to notifications: $e');
      }
    }
  }

  static Future<void> _unsubscribeFromNotifications() async {
    try {
      await FirebaseMessaging.instance.unsubscribeFromTopic(
        FirebaseAuth.instance.currentUser!.uid,
      );
      if (kDebugMode) {
        print('Unsubscribed from notifications');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error unsubscribing from notifications: $e');
      }
    }
  }

  static Future<bool?> showNotificationPermissionDialog() async {
    return await Get.dialog<bool>(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.notifications_outlined,
                size: 48,
                color: AppColor.primaryText,
              ),
              SizedBox(height: 16),
              CustomText(
                text: "Stay Updated",
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColor.primaryText,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              CustomText(
                text:
                    "Get notified about new events, special offers, and important updates from Traderou.",
                fontSize: 14,
                textAlign: TextAlign.center,
                color: Colors.grey.shade600,
                maxLines: 3,
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: "Not Now",
                      onTap: () => Get.back(result: false),
                      color: Colors.grey.shade200,
                      textColor: Colors.grey.shade700,
                      height: 40,
                      radius: 8,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      text: "Allow",
                      onTap: () => Get.back(result: true),
                      color: AppColor.primaryButton,
                      textColor: Colors.white,
                      height: 40,
                      radius: 8,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static Future<void> requestNotificationPermission() async {
    try {
      final box = await SharedPreferences.getInstance();
      final hasAskedBefore =
          box.getBool('hasAskedNotificationPermission') ?? false;

      if (!hasAskedBefore) {
        // Show explanation dialog first
        bool? shouldRequest = await showNotificationPermissionDialog();

        if (shouldRequest == true) {
          NotificationSettings settings = await _messaging.requestPermission(
            alert: true,
            announcement: false,
            badge: true,
            carPlay: false,
            criticalAlert: false,
            provisional: false,
            sound: true,
          );

          // Mark that we've asked for permission
          await box.setBool('hasAskedNotificationPermission', true);

          if (settings.authorizationStatus == AuthorizationStatus.authorized ||
              settings.authorizationStatus == AuthorizationStatus.provisional) {
            if (kDebugMode) {
              print('User granted permission on app start');
            }
            await box.setBool('notificationEnabled', true);
            await _subscribeToNotifications();
          } else {
            if (kDebugMode) {
              print('User denied permission on app start');
            }
            await box.setBool('notificationEnabled', false);
          }
        } else {
          // User chose not to enable notifications from dialog
          await box.setBool('hasAskedNotificationPermission', true);
          await box.setBool('notificationEnabled', false);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error requesting notification permission: $e');
      }
    }
  }

  static Future<void> initializeNotificationState() async {
    try {
      final box = await SharedPreferences.getInstance();
      final savedPreference = box.getBool('notificationEnabled') ?? false;

      // Check current permission status and sync
      if (savedPreference) {
        final bool? hasPermission = await _checkNotificationPermission();
        if (hasPermission != null && hasPermission) {
          // Permission is still valid, keep notifications enabled
          await _subscribeToNotifications();
        } else {
          // Permission was revoked, disable notifications
          await box.setBool('notificationEnabled', false);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing notification state: $e');
      }
    }
  }

  // Method for handling toggle from drawer
  static Future<bool> handleNotificationToggle() async {
    try {
      final box = await SharedPreferences.getInstance();
      final currentPreference = box.getBool('notificationEnabled') ?? false;

      if (!currentPreference) {
        // User wants to enable notifications - check permission first
        final bool? hasPermission = await _checkNotificationPermission();

        if (hasPermission != null && hasPermission) {
          // Permission already granted
          await box.setBool('notificationEnabled', true);
          await _subscribeToNotifications();

          Get.snackbar(
            'Notifications',
            'Notifications enabled',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColor.primaryText.withOpacity(0.8),
            colorText: Colors.white,
            duration: Duration(seconds: 2),
          );
          return true;
        } else {
          // Request permission with dialog
          bool? shouldRequest = await showNotificationPermissionDialog();

          if (shouldRequest == true) {
            NotificationSettings settings = await _messaging.requestPermission(
              alert: true,
              announcement: false,
              badge: true,
              carPlay: false,
              criticalAlert: false,
              provisional: false,
              sound: true,
            );

            if (settings.authorizationStatus ==
                    AuthorizationStatus.authorized ||
                settings.authorizationStatus ==
                    AuthorizationStatus.provisional) {
              await box.setBool('notificationEnabled', true);
              await _subscribeToNotifications();

              Get.snackbar(
                'Notifications',
                'Notifications enabled',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: AppColor.primaryText.withOpacity(0.8),
                colorText: Colors.white,
                duration: Duration(seconds: 2),
              );
              return true;
            } else {
              await box.setBool('notificationEnabled', false);

              Get.snackbar(
                'Permission Required',
                'Notification permission denied. Please enable it in device Settings.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.orange.withOpacity(0.8),
                colorText: Colors.white,
                duration: Duration(seconds: 4),
              );
              return false;
            }
          }
          return false;
        }
      } else {
        // User wants to disable notifications
        await box.setBool('notificationEnabled', false);
        await _unsubscribeFromNotifications();

        Get.snackbar(
          'Notifications',
          'Notifications disabled',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColor.primaryText.withOpacity(0.8),
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error toggling notifications: $e');
      }
      Get.snackbar(
        'Error',
        'Failed to update notification settings',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return false;
    }
  }

  static Future<bool> getNotificationState() async {
    try {
      final box = await SharedPreferences.getInstance();
      return box.getBool('notificationEnabled') ?? false;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting notification state: $e');
      }
      return false;
    }
  }

  // Initialize Firebase Push Notification listeners
  static Future<void> initFirebasePushNotification(BuildContext context) async {
    try {
      // Get initial message if app was opened from a notification
      RemoteMessage? initialMessage = await _messaging.getInitialMessage();
      if (kDebugMode) {
        print('Initial message: $initialMessage');
      }
      if (initialMessage != null) {
        if (kDebugMode) {
          print('App opened from notification (terminated state)');
        }
        await handleMessageReceived(initialMessage, 'terminated_state');
        await handleNotificationOpened(initialMessage, 'terminated_state');
        await _handleNotificationTap(context, initialMessage);
      }

      // Listen for foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        if (kDebugMode) {
          print('Foreground message received: ${message.data}');
          print('Notification title: ${message.notification?.title}');
          print('Notification body: ${message.notification?.body}');
        }

        // Track message receipt
        await handleMessageReceived(message, 'foreground');

        // Show the notification dialog - this counts as an impression
        await _showForegroundNotificationDialog(context, message);
      });

      // Listen for background message taps
      FirebaseMessaging.onMessageOpenedApp.listen((
        RemoteMessage message,
      ) async {
        if (kDebugMode) {
          print('Background message opened: ${message.data}');
          print('App opened from notification (background state)');
        }

        await handleNotificationOpened(message, 'background_state');
        await _handleNotificationTap(context, message);
      });

      if (kDebugMode) {
        print('Firebase Push Notification listeners initialized');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing Firebase Push Notification: $e');
      }
    }
  }

  // Handle notification tap (from background or terminated state)
  static Future<void> _handleNotificationTap(
    BuildContext context,
    RemoteMessage message,
  ) async {
    try {
      if (kDebugMode) {
        print('Handling notification tap: ${message.data}');
      }

      // Check if message data contains navigation type
      if (message.data['type'] == 'navigation') {
        String navigateTo = message.data['navigateTo'];
        if (kDebugMode) {
          print('Navigating to: $navigateTo');
        }

        // Navigate to the specified screen using switch statement
        switch (navigateTo) {
          default:
            await _showNotificationDetails(context, message);
            if (kDebugMode) {
              print('Unknown navigation target: $navigateTo');
            }
            // Fallback to showing notification details for unknown targets

            break;
        }
      } else {
        // For other types or if no navigation data, show notification details
        await _showNotificationDetails(context, message);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error handling notification tap: $e');
      }
    }
  }

  // Show foreground notification dialog when app is active
  static Future<void> _showForegroundNotificationDialog(
    BuildContext context,
    RemoteMessage message,
  ) async {
    try {
      Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with icon and close button
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColor.primaryText.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.notifications_active,
                        color: AppColor.primaryText,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: CustomText(
                        text: message.notification?.title ?? 'New Notification',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primaryText,
                        maxLines: 2,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(
                        Icons.close,
                        color: Colors.grey.shade600,
                        size: 20,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                  ],
                ),

                if (message.notification?.body != null) ...[
                  SizedBox(height: 16),
                  CustomText(
                    text: message.notification!.body!,
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    maxLines: 4,
                    textAlign: TextAlign.start,
                  ),
                ],

                SizedBox(height: 20),

                // Action button - Open or Got it based on notification type
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text:
                        message.data['type'] == 'navigation'
                            ? "Open"
                            : "Got it",
                    onTap: () async {
                      Get.back(); // Close the dialog first
                      if (message.data['type'] == 'navigation') {
                        // Call the notification tap handler for navigation
                        await _handleNotificationTap(context, message);
                      }
                    },
                    color: AppColor.primaryButton,
                    textColor: Colors.white,
                    height: 44,
                    radius: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: true,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error showing foreground notification dialog: $e');
      }
    }
  }

  // Show detailed notification content
  static Future<void> _showNotificationDetails(
    BuildContext context,
    RemoteMessage message,
  ) async {
    try {
      Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          child: Container(
            width: Get.width * 0.9,
            constraints: BoxConstraints(maxHeight: Get.height * 0.7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header Section
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColor.primaryText.withOpacity(0.05),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColor.primaryText,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.notifications_active,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: CustomText(
                          text:
                              message.notification?.title ??
                              'Notification Details',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColor.primaryText,
                          maxLines: 2,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(
                          Icons.close,
                          color: Colors.grey.shade600,
                          size: 22,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                    ],
                  ),
                ),

                // Content Section
                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (message.notification?.body != null) ...[
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.message_outlined,
                                      size: 16,
                                      color: AppColor.darkBlue,
                                    ),
                                    SizedBox(width: 6),
                                    CustomText(
                                      text: 'Message',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.darkBlue,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                CustomText(
                                  text: message.notification!.body!,
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                  maxLines: 10,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16),
                        ],
                      ],
                    ),
                  ),
                ),

                // Footer Section
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: CustomButton(
                    text: 'Got it',
                    onTap: () => Get.back(),
                    color: AppColor.primaryButton,
                    textColor: Colors.white,
                    height: 48,
                    radius: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: true,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error showing notification details: $e');
      }
    }
  }

  /// Create notification when customer rejects job completion
  static Future<void> createCompletionRejectedNotification({
    required String traderId,
    required String bookingId,
    required String jobTitle,
    String? customerComment,
  }) async {
    await createNotification(
      recipientId: traderId,
      type: 'completion_rejected',
      title: 'Work Needs Revision',
      message:
          customerComment != null && customerComment.isNotEmpty
              ? 'Customer feedback on "$jobTitle": "$customerComment"'
              : 'Customer has requested revisions for "$jobTitle". Please check the job details.',
      data: {
        'bookingId': bookingId,
        'jobTitle': jobTitle,
        'customerComment': customerComment ?? '',
      },
    );
  }

  /// Create notification when customer approves job completion
  static Future<void> createCompletionApprovedNotification({
    required String traderId,
    required String bookingId,
    required String jobTitle,
  }) async {
    await createNotification(
      recipientId: traderId,
      type: 'completion_approved',
      title: 'Work Approved!',
      message: 'Customer has approved the completion of "$jobTitle"',
      data: {'bookingId': bookingId, 'jobTitle': jobTitle},
    );
  }

  /// Create notification when trader marks work as complete
  static Future<void> createWorkCompletedNotification({
    required String customerId,
    required String bookingId,
    required String jobTitle,
  }) async {
    await createNotification(
      recipientId: customerId,
      type: 'work_completed',
      title: 'Work Completed!',
      message:
          'The trader has marked "$jobTitle" as complete. Please review and verify the work.',
      data: {'bookingId': bookingId, 'jobTitle': jobTitle},
    );
  }

  // Get Firebase messaging token for debugging
  static Future<String?> getFirebaseToken() async {
    try {
      String? token = await _messaging.getToken();
      if (kDebugMode) {
        print('Firebase token: $token');
      }
      return token;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting Firebase token: $e');
      }
      return null;
    }
  }

  // Handle token refresh
  static void setupTokenRefreshListener() {
    _messaging.onTokenRefresh.listen((newToken) {
      if (kDebugMode) {
        print('Firebase token refreshed: $newToken');
      }
      // You can send the new token to your server here
    });
  }

  // Method to handle message receipt tracking for Firebase Console
  static Future<void> handleMessageReceived(
    RemoteMessage message,
    String source,
  ) async {
    // The key for Firebase tracking is just properly handling the message
    // No special code needed - Firebase tracks when this method is called
  }

  // Method to handle notification open tracking for Firebase Console
  static Future<void> handleNotificationOpened(
    RemoteMessage message,
    String source,
  ) async {
    // The key for Firebase tracking is just properly handling the notification tap
    // No special code needed - Firebase tracks when this method is called
  }
}
