import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:traderwho/core/config/app_routes.dart';

class LoginController extends GetxController {
  // Text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final RxBool rememberMe = false.obs;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  // Observables
  var isLoading = false.obs;
  var obscurePassword = true.obs;

  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // Add this method to load saved credentials when the controller initializes
  Future<void> loadSavedCredentials() async {
    try {
      // Check if remember me was enabled
      final remembered = await _secureStorage.read(key: 'rememberMe');
      rememberMe.value = remembered == 'true';

      if (rememberMe.value) {
        // Load saved email and password
        emailController.text =
            await _secureStorage.read(key: 'savedEmail') ?? '';
        passwordController.text =
            await _secureStorage.read(key: 'savedPassword') ?? '';
      }
    } catch (e) {
      debugPrint('Error loading saved credentials: $e');
    }
  } // Add this method to save/clear credentials based on rememberMe value

  Future<void> handleCredentials() async {
    try {
      if (rememberMe.value) {
        // Save credentials
        await _secureStorage.write(key: 'rememberMe', value: 'true');
        await _secureStorage.write(
          key: 'savedEmail',
          value: emailController.text.trim(),
        );
        await _secureStorage.write(
          key: 'savedPassword',
          value: passwordController.text.trim(),
        );
      } else {
        // Clear saved credentials
        await _secureStorage.delete(key: 'rememberMe');
        await _secureStorage.delete(key: 'savedEmail');
        await _secureStorage.delete(key: 'savedPassword');
      }
    } catch (e) {
      print('Error handling credentials: $e');
    }
  }

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields');
      return;
    }

    if (!GetUtils.isEmail(emailController.text)) {
      Get.snackbar('Error', 'Please enter a valid email');
      return;
    }

    try {
      isLoading.value = true;
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!userCredential.user!.emailVerified) {
        Get.snackbar(
          'Email Not Verified',
          'Please verify your email before logging in',
          duration: const Duration(seconds: 5),
        );
        await _auth.signOut();
        isLoading.value = false;
        return;
      }

      // Handle credentials storage based on rememberMe value
      await handleCredentials();

      isLoading.value = false;
      Get.offAllNamed(AppRoutes.mainPageWithNavBar);
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      Get.snackbar('Login Failed', _getAuthErrorMessage(e.code));
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'An unexpected error occurred');
    }
  }

  // Google Sign-In
  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        isLoading.value = false;
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);

      isLoading.value = false;
      Get.offAllNamed(AppRoutes.mainPageWithNavBar);
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Google Sign-In failed: ${e.toString()}');
    }
  }

  // Apple Sign-In
  Future<void> signInWithApple() async {
    try {
      isLoading.value = true;

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      await _auth.signInWithCredential(oauthCredential);

      isLoading.value = false;
      Get.offAllNamed(AppRoutes.mainPageWithNavBar);
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Apple Sign-In failed: ${e.toString()}');
    }
  }

  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'too-many-requests':
        return 'Too many attempts. Try again later';
      case 'user-disabled':
        return 'This account has been disabled';
      default:
        return 'Login failed. Please try again';
    }
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> resetPassword() async {
    if (emailController.text.isEmpty ||
        !GetUtils.isEmail(emailController.text)) {
      Get.snackbar('Error', 'Please enter a valid email');
      return;
    }

    try {
      isLoading.value = true;
      await _auth.sendPasswordResetEmail(email: emailController.text.trim());
      Get.snackbar(
        'Password Reset',
        'A password reset link has been sent to your email',
        duration: const Duration(seconds: 5),
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to send password reset email');
    } finally {
      isLoading.value = false;
    }
  }
}
