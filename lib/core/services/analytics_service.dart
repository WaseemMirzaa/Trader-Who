// part of 'services.dart';

// /// A [AnalyticsService] for logging analytics events using Firebase Analytics.
// class AnalyticsService {
//   final FirebaseAnalytics _analytics;
//   final LoggerUtils _logger;

//   static const String _tag = 'AnalyticsService';

//   /// instance of [AnalyticsService] for logging analytics events.
//   AnalyticsService({
//     required FirebaseAnalytics analytics,
//     required LoggerUtils loggerUtils,
//   }) : _analytics = analytics,
//        _logger = loggerUtils {
//     _init();
//   }

//   Future<void> _init() async {
//     try {
//       _logger.log(_tag, 'Firebase Analytics initialized');
//     } on Exception catch (e, stack) {
//       _logger.logError('Firebase Analytics init failed', '$e\n$stack');
//     }
//   }

//   /// Logs an event when a user signs in with email/password.
//   Future<void> logSignInWithEmailPassword({required String email}) async {
//     try {
//       await _analytics.logLogin(
//         loginMethod: 'email', // Specifies the login method
//         parameters: {
//           'email': email, // Optional custom parameter
//         },
//       );
//     } on Exception catch (e) {
//       _logger.logError('logSignInWithEmailPassword failed', '$e');
//     }
//   }

//   /// Logs an event when a user signs up with email/password.
//   Future<void> logSignUpWithEmailPassword({required String email}) async {
//     try {
//       await _analytics.logSignUp(
//         signUpMethod: 'email', // Specifies the sign-up method
//         parameters: {
//           'email': email, // Optional custom parameter
//         },
//       );
//     } on Exception catch (e) {
//       _logger.logError('logSignUpWithEmailPassword failed', '$e');
//     }
//   }

//   /// Logs a custom event with a given [name] and optional [parameters].
//   ///
//   /// Parameters:
//   /// - [name]: The name of the custom event.
//   /// - [parameters]: A map of key-value pairs containing event parameters.
//   Future<void> logCustomEvent({
//     required String name,
//     Map<String, dynamic>? parameters,
//   }) async {
//     final data = parameters ?? <String, dynamic>{};
//     try {
//       await _analytics.logEvent(
//         name: name, // Event name as defined by you
//         parameters: Map<String, Object>.from(data), // Event parameters
//       );
//     } on Exception catch (e) {
//       _logger.logError('logCustomEvent failed', '$e');
//     }
//   }

//   /// Logs a predefined event for tracking a user's view of a specific screen.
//   ///
//   /// Parameters:
//   /// - [screenName]: The name of the screen viewed.
//   /// - [screenClass]: The class name of the screen (optional).
//   Future<void> logScreenView({
//     required String screenName,
//     String? screenClass,
//   }) async {
//     try {
//       await _analytics.logScreenView(
//         screenName: screenName, // Name of the screen
//         screenClass: screenClass, // Class name of the screen
//       );
//     } on Exception catch (e) {
//       _logger.logError('logScreenView failed', '$e');
//     }
//   }

//   /// Sets a user ID for the analytics session.
//   ///
//   /// Parameters:
//   /// - [userId]: The user ID to set.
//   Future<void> setUserId(String userId) async {
//     try {
//       await _analytics.setUserId(id: userId); // Sets the user ID
//     } on Exception catch (e) {
//       _logger.logError('setUserId failed', '$e');
//     }
//   }

//   /// Sets a user property for the analytics session.
//   ///
//   /// Parameters:
//   /// - [name]: The name of the user property.
//   /// - [value]: The value of the user property.
//   Future<void> setUserProperty(String name, String value) async {
//     try {
//       await _analytics.setUserProperty(
//         name: name, // User property name
//         value: value, // User property value
//       );
//     } on Exception catch (e) {
//       _logger.logError('setUserProperty failed', '$e');
//     }
//   }
// }
