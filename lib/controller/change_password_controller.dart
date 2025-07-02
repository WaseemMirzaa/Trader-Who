import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traderwho/core/theme/app_color.dart';

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

      if (!RegExp(r'[A-Z]').hasMatch(newPassword)) {
        debugPrint('Validation failed: No uppercase letter in new password');
        Get.snackbar(
          'Error',
          'New password must contain at least one uppercase letter.',
        );
        isLoading.value = false;
        return;
      }

      if (!RegExp(r'[0-9]').hasMatch(newPassword)) {
        debugPrint('Validation failed: No number in new password');
        Get.snackbar('Error', 'New password must contain at least one number.');
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

      // Re-authenticate the user with the old password
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword,
      );

      try {
        await user.reauthenticateWithCredential(credential);
        debugPrint('User re-authenticated successfully');
      } catch (e) {
        debugPrint('Re-authentication failed: $e');
        Get.snackbar('Error', 'Incorrect old password.');
        isLoading.value = false;
        return;
      }

      // Update the password
      await user.updatePassword(newPassword);
      debugPrint('Password updated successfully');

      // Optionally update Firestore if you're storing the password there
      // Note: Storing passwords in Firestore is not recommended
      // await FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(user.uid)
      //     .update({'password': newPassword.trim()});

      isLoading.value = false;
      Get.snackbar(
        'Success',
        'Password changed successfully!',
        colorText: AppColor.primaryText,
      );
      debugPrint('Showing success snackbar');

      // Navigate back to the previous screen
      Get.back();
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      String message = _getAuthErrorMessage(e.code);
      debugPrint('FirebaseAuthException: $message');
      Get.snackbar('Error', message);
    } catch (e) {
      isLoading.value = false;
      debugPrint('Unexpected error: $e');
      Get.snackbar('Error', 'An unexpected error occurred: ${e.toString()}');
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
      default:
        return 'An authentication error occurred.';
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
