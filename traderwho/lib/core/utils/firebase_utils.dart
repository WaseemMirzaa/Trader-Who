// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:flutter/foundation.dart';

// import '../di/core_injection.dart';

// class FirebaseUtils {
//   // firebase fatal + ANR  + crashes catcher
//   static Future<void> recordFireBaseError({
//     required String error,
//     StackTrace? stack,
//     bool isCrash = false,
//     String? reason,
//   }) async {
//     final FirebaseCrashlytics fbInstance = sl<FirebaseCrashlytics>();
//     reason ??= 'SOMETHING WENT WRONG';
//     //
//     if (isCrash) {
//       fbInstance.recordError(
//         error,
//         stack,
//         reason: StackTrace.fromString(reason),
//         fatal: true,
//         printDetails: true,
//       );

//       await fbInstance.sendUnsentReports();

//       return;
//     }
//     fbInstance.recordFlutterError(
//       FlutterErrorDetails(
//         exception: error,
//         stack: stack,
//         silent: true,
//         context: DiagnosticsNode.message(
//           reason,
//           level: DiagnosticLevel.error,
//           style: DiagnosticsTreeStyle.errorProperty,
//         ),
//       ),
//     );
//   }
// }
