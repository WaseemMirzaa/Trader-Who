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

  // Add this method to manually refresh data
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

      // Set values from Firestore or fallback to auth data
      if (doc.exists) {
        final data = doc.data();
        name.value = data?['name'] ?? authUser.displayName ?? 'User';
        email.value = data?['email'] ?? authUser.email ?? 'No email';
      } else {
        // Document doesn't exist, use auth data
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
      // First, sign out from Firebase
      await FirebaseAuth.instance.signOut();

      // Add a small delay to ensure Firebase operations complete
      await Future.delayed(const Duration(milliseconds: 100));

      // Use Get.offAll instead of Get.offAllNamed for more reliable navigation
      Get.offAll(
        () => const OnBoardingPage(),
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 300),
      );
    } catch (e) {
      debugPrint('Logout error: $e');
      // If there's an error, still try to navigate to onboarding
      Get.offAll(() => const OnBoardingPage());
    }
  }
}
