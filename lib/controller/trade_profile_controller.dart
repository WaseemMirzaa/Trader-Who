import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traderwho/views/auth/presentation/pages/pages.dart';

class TradeProfileController extends GetxController {
  final Rx<String> name = Rx<String>('');
  final Rx<String> email = Rx<String>('');
  final RxString profileImageUrl = RxString('');
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
      } else {
        name.value = authUser.displayName ?? 'User';
        email.value = authUser.email ?? 'No email';
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

      // Delete from Firestore first
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .delete();

      // Then delete the auth user
      await user.delete();

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
}
