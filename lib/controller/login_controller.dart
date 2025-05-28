import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traderwho/core/config/app_routes.dart';

class LoginController extends GetxController {
  // Text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Observables
  var isLoading = false.obs;
  var obscurePassword = true.obs;

  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    // Validation
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

      // Sign in with email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Check if email is verified
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

      isLoading.value = false;
      Get.offAllNamed(AppRoutes.mainPageWithNavBar); // Navigate to main page
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      String message = _getAuthErrorMessage(e.code);
      Get.snackbar('Login Failed', message);
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'An unexpected error occurred');
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
      isLoading.value = false;
      Get.snackbar(
        'Password Reset',
        'A password reset link has been sent to your email',
        duration: const Duration(seconds: 5),
      );
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to send password reset email');
    }
  }
}
