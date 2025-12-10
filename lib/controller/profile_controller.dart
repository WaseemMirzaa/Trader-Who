import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:traderou/core/config/app_routes.dart';

import 'login_controller.dart';

class ProfileController extends GetxController {
  final Rx<String> name = Rx<String>('');
  final Rx<String> email = Rx<String>('');
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  void onInit() {
    super.onInit();
    fetchProfileData();
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
      await FirebaseAuth.instance.signOut();

      await _secureStorage.delete(key: 'rememberMe');
      await _secureStorage.delete(key: 'email');
      await _secureStorage.delete(key: 'password');

      final loginController = Get.find<LoginController>();
      loginController.rememberMe.value = false;

      Get.offAllNamed(AppRoutes.onboarding);
    } catch (e) {
      debugPrint('Logout error: $e');
      Get.snackbar('Logout Failed', 'Something went wrong while logging out.');
    }
  }
}
