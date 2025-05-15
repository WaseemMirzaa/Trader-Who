// part of 'services.dart';

// /// A [CrashlyticsService] to handle Crashlytics functionality.
// class CrashlyticsService {
//   final FirebaseCrashlytics _crashlytics;
//   final LoggerUtils _logger;

//   static const String _tag = 'CrashlyticsService';

//   /// The constructor for [CrashlyticsService].
//   CrashlyticsService({
//     required FirebaseCrashlytics crashlytics,
//     required LoggerUtils loggerUtils,
//   }) : _crashlytics = crashlytics,
//        _logger = loggerUtils {
//     _init();
//   }

//   Future<void> _init() async {
//     try {
//       if (kIsWeb) {
//         _logger.log(_tag, 'Crashlytics is not supported on Web.');
//         return;
//       }

//       if (kDebugMode) {
//         await _crashlytics.setCrashlyticsCollectionEnabled(true);
//       } else {
//         await _crashlytics.setCrashlyticsCollectionEnabled(true);
//       }

//       await setCustomKey('platform', Platform.operatingSystem);
//       await Future.wait([
//         setCustomKey('platformVersion', Platform.operatingSystemVersion),
//         setCustomKey('platformLocale', Platform.localeName),
//       ]);

//       FlutterError.onError = (details) async {
//         _crashlytics.recordFlutterFatalError(details);
//       };

//       PlatformDispatcher.instance.onError = (error, stack) {
//         _crashlytics.recordError(error, stack, fatal: true);
//         return true;
//       };

//       _logger.log(_tag, 'Crashlytics initialized');
//     } on Exception catch (e, stack) {
//       _logger.logError('Crashlytics init failed', '$e\n$stack');
//     }
//   }

//   /// Records an error to Crashlytics.
//   Future<void> recordError(
//     Object exception,
//     StackTrace? stack, {
//     bool fatal = false,
//     String? reason,
//     Iterable<Object> information = const <Object>[],
//     Map<String, dynamic>? additionalData,
//   }) async {
//     if (kIsWeb) return;

//     try {
//       final List<Object> allInformation = <Object>[
//         ...information,
//         if (additionalData != null)
//           ...additionalData.entries.map(
//             (MapEntry<String, dynamic> e) => '${e.key}: ${e.value}',
//           ),
//       ];

//       await _crashlytics.recordError(
//         exception,
//         stack,
//         fatal: fatal,
//         reason: reason,
//         information: allInformation,
//       );

//       if (kDebugMode) await _crashlytics.sendUnsentReports();

//       _logger.logError(_tag, '$exception\n${stack ?? StackTrace.current}');
//     } on Exception catch (error) {
//       _logger.logError('Failed to record error to Crashlytics', '$error');
//     }
//   }

//   /// Records a non-fatal error to Crashlytics.
//   Future<void> setUserIdentifier(String? userId) async {
//     if (kIsWeb) return;

//     try {
//       await _crashlytics.setUserIdentifier(
//         (userId?.isNotEmpty ?? false) ? userId! : 'anonymous',
//       );
//     } on Exception catch (error) {
//       _logger.logError('Failed to set user identifier', '$error');
//     }
//   }

//   /// Sets a custom key-value pair in Crashlytics.
//   Future<void> setCustomKey(String key, String value) async {
//     if (kIsWeb) return;

//     try {
//       await _crashlytics.setCustomKey(key, value);
//     } on Exception catch (error) {
//       _logger.logError('Failed to set custom key', '$error');
//     }
//   }

//   /// Sets a custom attribute in Crashlytics.
//   Future<void> log(String message) async {
//     if (kIsWeb) return;

//     try {
//       await _crashlytics.log(message);
//     } on Exception catch (error) {
//       _logger.logError('Failed to log message', '$error');
//     }
//   }
// }
