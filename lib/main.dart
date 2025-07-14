// main.dart
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:traderwho/firebase_options.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  try {
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.playIntegrity,
      appleProvider: AppleProvider.deviceCheck,
      // webProvider: ReCaptchaV3Provider('recaptcha-site-key'),
    );

    // Optional: Get token for debugging
    final token = await FirebaseAppCheck.instance.getToken();
    debugPrint('App Check token: $token');
  } catch (e) {
    debugPrint('Error initializing App Check: $e');
  }

  runApp(const App());
}
