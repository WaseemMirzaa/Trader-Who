// part of 'services.dart';

// /// This [NotificationServices] handles the notification services for the app.
// class NotificationServices {
//   ///messaging instance
//   FirebaseMessaging messaging = FirebaseMessaging.instance;

//   ///flutterLocalNotifications instance
//   final FlutterLocalNotificationsPlugin flutterLocalNotifications =
//       FlutterLocalNotificationsPlugin();

//   ///requests permission for notifications
//   Future<void> requestNotificationsPermissions() async {
//     try {
//       final messaging = FirebaseMessaging.instance;
//       final NotificationSettings settings = await messaging.requestPermission();
//       debugPrint(
//         'Notification Permission Status: ${settings.authorizationStatus}',
//       );
//       if (settings.authorizationStatus == AuthorizationStatus.denied &&
//           !kIsWeb) {
//         debugPrint('Opening app settings...');
//         await setting.openAppSettings();
//       } else if (settings.authorizationStatus ==
//           AuthorizationStatus.authorized) {
//         debugPrint('Notifications authorized');
//       } else if (settings.authorizationStatus ==
//           AuthorizationStatus.provisional) {
//         debugPrint('Provisional notifications enabled');
//       }
//     } on Exception catch (e) {
//       debugPrint('Error requesting notification permissions: $e');
//     }
//   }

//   ///gets the device token
//   Future<String> getDeviceToken() async {
//     if (kIsWeb) {
//       final String? deviceToken = await messaging.getToken(
//         vapidKey:
//             'BFBAdSd2CjkiIhmk-4SGf3XV3n_6YXPrQjQPI9XGsvIHaqn6W6YOlbyRiQ5GVB8jWyD7LBbb80N7GBM7ifNTAac',
//       );
//       debugPrint('For web device token: $deviceToken');
//       return deviceToken ?? '';
//     } else if (Platform.isIOS) {
//       final String? deviceToken =
//           await FirebaseMessaging.instance.getAPNSToken();
//       debugPrint('APNs Token: $deviceToken');
//       return deviceToken ?? '';
//     }
//     final String? deviceToken = await messaging.getToken();
//     debugPrint('device token: $deviceToken');
//     return deviceToken ?? '';
//   }

//   ///checks if the device token is valid
//   void isDeviceTokenValid() async {
//     messaging.onTokenRefresh.listen((event) {
//       debugPrint('Token refreshed: $event');
//     });
//   }

//   ///sets the foreground notification presentation options
//   Future<void> initLocalNotifications(
//     BuildContext context,
//     RemoteMessage message,
//   ) async {
//     if (kIsWeb) return;

//     const androidInitializationSettings = AndroidInitializationSettings(
//       '@mipmap/launcher_icon',
//     );

//     const iosInitializationSettings = DarwinInitializationSettings();

//     const initializationSetting = InitializationSettings(
//       android: androidInitializationSettings,
//       iOS: iosInitializationSettings,
//     );

//     try {
//       await flutterLocalNotifications.initialize(
//         initializationSetting,
//         onDidReceiveNotificationResponse: (notificationPayload) {
//           handleMessage(context, message);
//         },
//       );

//       debugPrint('Local notifications initialized');
//     } on Exception catch (e) {
//       debugPrint('Error initializing local notifications: $e');
//     }
//   }

//   /// shows the notification
//   Future<void> showNotification(RemoteMessage remoteMessage) async {
//     // if (kIsWeb) {
//     //   try {
//     //     debugPrint(
//     //       'web notification: ${remoteMessage.notification?.title}',
//     //     );

//     //     if (html.Notification.permission == 'granted') {
//     //       html.Notification(
//     //         remoteMessage.notification?.title ?? 'No Title',
//     //         body: remoteMessage.notification?.body ?? 'No Body',
//     //         icon: '/icons/Icon-192.png',
//     //       );
//     //     } else {
//     //       final permission = await html.Notification.requestPermission();

//     //       if (permission == 'granted') {
//     //         html.Notification(
//     //           remoteMessage.notification?.title ?? 'No Title',
//     //           body: remoteMessage.notification?.body ?? 'No Body',
//     //           icon: '/icons/Icon-192.png',
//     //         );
//     //       } else {
//     //         debugPrint('Notification permission denied');
//     //       }
//     //     }
//     //   } on Exception catch (e) {
//     //     debugPrint('Error showing web notification: $e');
//     //   }
//     //   return;
//     // }

//     final AndroidNotificationChannel channel = AndroidNotificationChannel(
//       remoteMessage.messageId ?? 'default_channel',
//       'High Importance Notification',
//       importance: Importance.max,
//     );

//     final AndroidNotificationDetails androidNormalNotificationDetails =
//         AndroidNotificationDetails(
//           channel.id,
//           channel.name,
//           channelDescription: 'channel description',
//           importance: Importance.high,
//           priority: Priority.high,
//           ticker: 'ticker',
//         );

//     const DarwinNotificationDetails iosNotificationDetails =
//         DarwinNotificationDetails(
//           presentAlert: true,
//           presentBadge: true,
//           presentSound: true,
//         );

//     final NotificationDetails notificationDetails = NotificationDetails(
//       android: androidNormalNotificationDetails,
//       iOS: iosNotificationDetails,
//     );

//     try {
//       await flutterLocalNotifications.show(
//         remoteMessage.messageId.hashCode,
//         remoteMessage.notification?.title ?? 'No Title',
//         remoteMessage.notification?.body ?? 'No Body',
//         notificationDetails,
//       );
//       debugPrint('Notification shown: ${remoteMessage.notification?.title}');
//     } on Exception catch (e) {
//       debugPrint('Error showing notification: $e');
//     }
//   }

//   /// initializes the firebase notifications
//   void firebaseNotificationsInitialization(BuildContext context) {
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       if (context.mounted) {
//         handleMessage(context, message);
//       }
//     });
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//       debugPrint('Message received: ${message.notification?.title}');
//       if (context.mounted) {
//         await initLocalNotifications(context, message);
//       }
//       showNotification(message);
//     });
//   }

//   /// sets up the interact message
//   Future<void> setUpInteractMessage({required BuildContext context}) async {
//     final RemoteMessage? initialMessage =
//         await FirebaseMessaging.instance.getInitialMessage();
//     if (initialMessage != null && context.mounted) {
//       handleMessage(context, initialMessage);
//     }

//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       if (context.mounted) {
//         handleMessage(context, message);
//       }
//     });
//   }

//   /// handles the message when the app is in the background
//   void handleMessage(BuildContext context, RemoteMessage message) {
//     if (!message.notification!.body!.startsWith(
//       'Dear user, we apologize for the inconvenience, but we require the following information to verify your account and continue providing our services',
//     )) {
//       debugPrint('Navigate to notifications: ${message.notification?.title}');
//     }
//   }

//   /// sets the foreground notification presentation options
//   Future<void> foregroundMessage() async {
//     if (kIsWeb) return;
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//           alert: true,
//           badge: true,
//           sound: true,
//         );
//   }
// }
