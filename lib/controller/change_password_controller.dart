import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traderou/core/theme/app_color.dart';

class ChangePasswordController extends GetxController {
  // Text controllers for input fields
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Observables
  var isLoading = false.obs;
  var obscureOldPassword = true.obs;
  var obscureNewPassword = true.obs;
  var obscureConfirmPassword = true.obs;

  // Firebase instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onClose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      isLoading.value = true;
      debugPrint('Starting password change process');

      // Validation
      if (oldPassword.isEmpty ||
          newPassword.isEmpty ||
          confirmPassword.isEmpty) {
        debugPrint('Validation failed: All fields are required');
        Get.snackbar('Error', 'All fields are required.');
        isLoading.value = false;
        return;
      }

      if (newPassword.length < 8) {
        debugPrint('Validation failed: New password too short');
        Get.snackbar('Error', 'New password must be at least 8 characters.');
        isLoading.value = false;
        return;
      }

      if (!RegExp(
        r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*?&]{8,}$',
      ).hasMatch(newPassword)) {
        debugPrint('Validation failed: Password doesn\'t meet requirements');
        Get.snackbar(
          'Error',
          'Password must contain at least one letter and one number.',
        );
        isLoading.value = false;
        return;
      }

      if (newPassword != confirmPassword) {
        debugPrint('Validation failed: Passwords do not match');
        Get.snackbar(
          'Error',
          'New password and confirm password do not match.',
        );
        isLoading.value = false;
        return;
      }

      // Get the current user
      User? user = _auth.currentUser;
      if (user == null) {
        debugPrint('Validation failed: No user is signed in');
        Get.snackbar('Error', 'No user is signed in.');
        isLoading.value = false;
        return;
      }

      // Re-authenticate the user
      debugPrint('Attempting re-authentication for user: ${user.email}');
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword,
      );

      try {
        await user.reauthenticateWithCredential(credential);
        debugPrint('Re-authentication successful');
      } catch (e) {
        debugPrint('Re-authentication failed: $e');
        if (e is FirebaseAuthException) {
          switch (e.code) {
            case 'wrong-password':
            case 'invalid-credential':
              Get.snackbar('Error', 'Incorrect old password.');
              break;
            case 'too-many-requests':
              Get.snackbar(
                'Error',
                'Too many attempts. Please try again later.',
              );
              break;
            case 'user-disabled':
              Get.snackbar('Error', 'This account has been disabled.');
              break;
            case 'user-not-found':
              Get.snackbar('Error', 'User account not found.');
              break;
            default:
              Get.snackbar('Error', 'Re-authentication failed: ${e.message}');
          }
        } else {
          Get.snackbar('Error', 'Re-authentication failed. Please try again.');
        }
        isLoading.value = false;
        return;
      }

      // Update password
      debugPrint('Attempting to update password');
      await user.updatePassword(newPassword);
      debugPrint('Password updated successfully');

      isLoading.value = false;
      Get.showSnackbar(
        GetSnackBar(
          title: "Success",
          message: "Password changed successfully!",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green, // Changed to more visible color
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(10),
          borderRadius: 8,
        ),
      );
      debugPrint('Password change completed successfully');

      // Clear the form
      oldPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();

      // Navigate back
      await Future.delayed(const Duration(seconds: 2)); // Small delay
      debugPrint('Calling Get.back() after password change success');
      Get.back();
      debugPrint('Get.back() called, should have navigated back');
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      String message = _getAuthErrorMessage(e.code);
      debugPrint('FirebaseAuthException: ${e.code} - $message');
      Get.snackbar(
        'Error',
        message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColor.red,
        colorText: AppColor.primaryText,
      );
    } catch (e) {
      isLoading.value = false;
      debugPrint('Unexpected error: $e');
      Get.snackbar(
        'Error',
        'An unexpected error occurred: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColor.red,
        colorText: AppColor.primaryText,
      );
    }
  }

  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'wrong-password':
        return 'Incorrect old password.';
      case 'weak-password':
        return 'The new password is too weak.';
      case 'requires-recent-login':
        return 'Please log in again to change your password.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
        return 'User account not found.';
      case 'invalid-email':
        return 'Invalid email address.';
      default:
        return 'An authentication error occurred. Please try again.';
    }
  }

  void toggleOldPasswordVisibility() {
    obscureOldPassword.value = !obscureOldPassword.value;
  }

  void toggleNewPasswordVisibility() {
    obscureNewPassword.value = !obscureNewPassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }
}
