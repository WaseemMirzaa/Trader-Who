import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traderwho/core/theme/app_color.dart';
import 'package:traderwho/models/user_model.dart';

class MyaccountController extends GetxController {
  // Text controllers for input fields
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final usernameController = TextEditingController();

  // Observables
  final RxBool showShimmer = true.obs;
  final RxString error = ''.obs;
  final Rx<UserModel?> user = Rx<UserModel?>(null);

  // Getter to check if user is a customer
  bool get isCustomer => user.value?.userType == 'customer';

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
    usernameController.dispose();
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
        print('MyAccount: No authenticated user');
        return;
      }

      print('MyAccount: Fetching data for user: ${authUser.uid}');
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(authUser.uid)
              .get();

      print('MyAccount: Document exists: ${doc.exists}');
      if (doc.exists) {
        print('MyAccount: Document data: ${doc.data()}');
        final userData = UserModel.fromFirestore(doc);
        user.value = userData;
        print(
          'MyAccount: UserModel created: ${userData.name}, type: ${userData.userType}',
        );

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

        // Set customer specific fields if user is a customer
        usernameController.text = userData.username ?? '';
      } else {
        // Document doesn't exist, use auth data
        print('MyAccount: Document does not exist, using auth data');
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
        usernameController.text = '';

        // Create a basic user model for display
        user.value = UserModel(
          id: authUser.uid,
          name: name,
          email: authUser.email ?? '',
          userType: 'customer', // Default to customer for myaccount page
        );
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

      // Update data in Firestore (only customer-relevant fields)
      await FirebaseFirestore.instance
          .collection('users')
          .doc(authUser.uid)
          .update({
            'name': fullName,
            'email': emailController.text,
            'phone': phoneController.text,
            'address': addressController.text,
            'username': usernameController.text,
            'updatedAt': DateTime.now().millisecondsSinceEpoch,
            // Explicitly remove tradesperson fields for customers
            'title': FieldValue.delete(),
            'bio': FieldValue.delete(),
            'status': FieldValue.delete(),
            'availability': FieldValue.delete(),
            'start_time': FieldValue.delete(),
            'end_time': FieldValue.delete(),
          });

      // Update display name in Firebase Auth
      await authUser.updateDisplayName(fullName);

      // If email changed, update it in Firebase Auth
      if (authUser.email != emailController.text) {
        await authUser.verifyBeforeUpdateEmail(emailController.text);
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
