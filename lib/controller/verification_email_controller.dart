import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traderwho/controller/navigation_controller.dart';
import 'package:traderwho/core/config/app_routes.dart';
import 'package:traderwho/core/theme/app_color.dart';
import 'package:traderwho/models/user_model.dart';

class EmailVerificationController extends GetxController {
  final String userEmail;
  final UserModel userModel;
  final String userId;
  final bool isTradesperson;

  EmailVerificationController({
    required this.userEmail,
    required this.userModel,
    required this.userId,
    required this.isTradesperson,
  });

  // Observable variables
  final RxBool isVerified = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool isResending = false.obs;

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    // Start polling for email verification status
    checkEmailVerificationStatus();
  }

  // Periodically check email verification status
  void checkEmailVerificationStatus() {
    ever(isVerified, (verified) {
      if (verified == true) {
        // Navigate when verified
        navigateToNextScreen();
      }
    });

    // Poll Firebase for verification status every 5 seconds
    Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (isVerified.value) {
        timer.cancel();
        return;
      }
      await _auth.currentUser?.reload();
      final user = _auth.currentUser;
      if (user != null && user.emailVerified) {
        isVerified.value = true;
        timer.cancel();
      }
    });
  }

  // Navigate to the appropriate screen
  Future<void> navigateToNextScreen() async {
    try {
      // Set user type in NavigationController
      NavigationController.to.setUserType(isTradesperson);
      debugPrint('User type set in NavigationController');

      // Show success message
      Get.snackbar(
        'Success',
        'Email verified successfully!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColor.white,
        colorText: AppColor.primaryText,
      );

      // Navigate to appropriate screen
      if (isTradesperson) {
        Get.offAllNamed(AppRoutes.tradeRate);
      } else {
        Get.offAllNamed(AppRoutes.mainPageWithNavBar);
      }
    } catch (e) {
      debugPrint('Error during navigation: $e');
      Get.snackbar(
        'Error',
        'Failed to navigate. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColor.red,
        colorText: AppColor.primaryText,
      );
    }
  }

  // Continue button handler
  Future<void> handleContinue() async {
    if (isLoading.value) return;

    isLoading.value = true;

    try {
      // Reload user to check verification status
      await _auth.currentUser?.reload();
      final user = _auth.currentUser;

      if (user != null && user.emailVerified) {
        isVerified.value = true;
        // Navigation handled by checkEmailVerificationStatus
      } else {
        Get.snackbar(
          'Error',
          'Please verify your email before continuing.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColor.red,
          colorText: AppColor.primaryText,
        );
      }
    } catch (e) {
      debugPrint('Error checking verification: $e');
      Get.snackbar(
        'Error',
        'An error occurred. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColor.red,
        colorText: AppColor.primaryText,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Resend email handler
  Future<void> handleResendEmail() async {
    if (isResending.value) return;

    isResending.value = true;

    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.sendEmailVerification();
        Get.snackbar(
          'Email Sent',
          'Verification email sent successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColor.primaryText,
          colorText: AppColor.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'No user found. Please try signing up again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColor.red,
          colorText: AppColor.primaryText,
        );
      }
    } catch (e) {
      debugPrint('Error resending email: $e');
      Get.snackbar(
        'Error',
        'Failed to send email. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColor.red,
        colorText: AppColor.primaryText,
      );
    } finally {
      isResending.value = false;
    }
  }

  @override
  void onClose() {
    // Cancel any timers or listeners if necessary
    super.onClose();
  }
}
