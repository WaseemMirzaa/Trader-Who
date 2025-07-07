// main.dart
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:traderwho/firebase_options.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Firebase App Check
  await FirebaseAppCheck.instance.activate(
    // Use Play Integrity for Android
    androidProvider: AndroidProvider.playIntegrity,
    // Use DeviceCheck for iOS
    appleProvider: AppleProvider.deviceCheck,
    // Use reCAPTCHA v3 for web (replace 'recaptcha-site-key' with your actual key)
    // webProvider: ReCaptchaV3Provider('recaptcha-site-key'),
  );

  runApp(const App());
}
