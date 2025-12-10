import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traderou/views/auth/presentation/pages/pages.dart';

class TradeProfileController extends GetxController {
  final Rx<String> name = Rx<String>('');
  final Rx<String> email = Rx<String>('');
  final RxString profileImageUrl = RxString('');
  final RxDouble rating = 0.0.obs;
  final RxInt totalRatings = 0.obs;
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfileData();
  }

  Future<void> refreshProfile() async {
    await fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    try {
      isLoading(true);
      error('');

      final authUser = FirebaseAuth.instance.currentUser;
      if (authUser == null) {
        error('No authenticated user');
        return;
      }

      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(authUser.uid)
              .get();

      if (doc.exists) {
        final data = doc.data();
        name.value = data?['name'] ?? authUser.displayName ?? 'User';
        email.value = data?['email'] ?? authUser.email ?? 'No email';

        // Get rating from Firebase (calculated from bookings)
        rating.value = (data?['rating'] ?? 0.0).toDouble();
        totalRatings.value = data?['totalRatings'] ?? 0;
      } else {
        name.value = authUser.displayName ?? 'User';
        email.value = authUser.email ?? 'No email';
        rating.value = 0.0;
        totalRatings.value = 0;
      }
    } catch (e) {
      error('Failed to fetch profile: ${e.toString()}');
      Get.snackbar(
        'Error',
        'Failed to load profile',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      await Future.delayed(const Duration(milliseconds: 100));
      Get.offAll(
        () => const OnBoardingPage(),
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 300),
      );
    } catch (e) {
      debugPrint('Logout error: $e');
      Get.offAll(() => const OnBoardingPage());
    }
  }

  Future<void> deleteAccount() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Show loading dialog
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Try to delete the auth user first
      try {
        await user.delete();
        debugPrint('Auth user deleted successfully');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'requires-recent-login') {
          Get.back(); // Close loading dialog
          debugPrint('Requires recent login, prompting for password');
          // Prompt for password
          String? password = await _promptForPassword();
          if (password != null && password.isNotEmpty) {
            try {
              AuthCredential credential = EmailAuthProvider.credential(
                email: user.email!,
                password: password,
              );
              await user.reauthenticateWithCredential(credential);
              Get.dialog(
                const Center(child: CircularProgressIndicator()),
                barrierDismissible: false,
              );
              final freshUser = FirebaseAuth.instance.currentUser;
              await freshUser?.delete();
              debugPrint('Auth user deleted after re-authentication');
            } catch (reauthError) {
              Get.back();
              debugPrint('Re-authentication failed: $reauthError');
              Get.snackbar(
                'Error',
                'Re-authentication failed. Account not deleted.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
              return;
            }
          } else {
            debugPrint('Account deletion cancelled by user');
            Get.snackbar(
              'Cancelled',
              'Account deletion cancelled.',
              snackPosition: SnackPosition.BOTTOM,
            );
            return;
          }
        } else {
          Get.back();
          debugPrint('Auth deletion error: $e');
          Get.snackbar(
            'Error',
            'Failed to delete account: ${e.message}',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }
      }

      // Now delete from Firestore
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .delete();
        debugPrint('Firestore user document deleted successfully');
      } catch (firestoreError) {
        debugPrint('Firestore deletion error: $firestoreError');
        // Optionally, show a snackbar or log
      }

      // Close loading dialog
      Get.back();

      // Navigate to onboarding
      Get.offAll(
        () => const OnBoardingPage(),
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 300),
      );

      // Show success message
      Get.snackbar(
        'Success',
        'Your account has been deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } on FirebaseAuthException catch (e) {
      Get.back();
      debugPrint('Error deleting account: $e');
      Get.snackbar(
        'Error',
        'Failed to delete account: ${e.message}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.back();
      debugPrint('Error deleting account: $e');
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Helper to prompt for password using a dialog
  Future<String?> _promptForPassword() async {
    TextEditingController passwordController = TextEditingController();
    String? result = await Get.dialog<String>(
      AlertDialog(
        title: const Text('Re-authenticate'),
        content: TextField(
          controller: passwordController,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Enter your password'),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: null),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: passwordController.text),
            child: const Text('Confirm'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
    return result;
  }
}
