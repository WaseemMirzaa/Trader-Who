import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traderwho/core/theme/app_color.dart';
import 'package:traderwho/models/user_model.dart';

class TradeMyaccountController extends GetxController {
  // Text controllers for input fields
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  // Observables
  final RxBool showShimmer = true.obs;
  final RxString error = ''.obs;
  final Rx<UserModel?> user = Rx<UserModel?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.onClose();
  }

  Future<void> fetchUserData() async {
    try {
      showShimmer(true);
      error('');

      final authUser = FirebaseAuth.instance.currentUser;
      if (authUser == null) {
        showShimmer(false);
        error('No authenticated user');
        return;
      }

      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(authUser.uid)
              .get();

      if (doc.exists) {
        final userData = UserModel.fromFirestore(doc);
        user.value = userData;

        // Split name into first and last name
        final nameParts = userData.name.split(' ');
        final firstName = nameParts.isNotEmpty ? nameParts[0] : '';
        final lastName =
            nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

        // Set text controllers
        firstNameController.text = firstName;
        lastNameController.text = lastName;
        emailController.text = userData.email;
        phoneController.text = userData.phone ?? '';
        addressController.text = userData.address ?? '';
      } else {
        // Document doesn't exist, use auth data
        final name = authUser.displayName ?? 'User';
        final nameParts = name.split(' ');
        final firstName = nameParts.isNotEmpty ? nameParts[0] : '';
        final lastName =
            nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

        firstNameController.text = firstName;
        lastNameController.text = lastName;
        emailController.text = authUser.email ?? '';
        phoneController.text = '';
        addressController.text = '';
      }
    } catch (e) {
      error('Failed to fetch user data: ${e.toString()}');
      Get.snackbar(
        'Error',
        'Failed to load profile data',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      showShimmer(false);
    }
  }

  Future<void> updateProfile() async {
    try {
      showShimmer(true);
      error('');

      final authUser = FirebaseAuth.instance.currentUser;
      if (authUser == null) {
        error('No authenticated user');
        return;
      }

      // Combine first and last name
      final fullName =
          '${firstNameController.text} ${lastNameController.text}'.trim();

      // Update data in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(authUser.uid)
          .update({
            'name': fullName,
            'email': emailController.text,
            'phone': phoneController.text,
            'address': addressController.text,
            'updatedAt': FieldValue.serverTimestamp(),
          });

      // Update display name in Firebase Auth
      await authUser.updateDisplayName(fullName);

      // If email changed, update it in Firebase Auth
      if (authUser.email != emailController.text) {
        await authUser.updateEmail(emailController.text);
      }

      Get.snackbar(
        backgroundColor: AppColor.darkerGray,
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      error('Failed to update profile: ${e.toString()}');
      Get.snackbar(
        'Error',
        'Failed to update profile: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      showShimmer(false);
    }
  }
}
