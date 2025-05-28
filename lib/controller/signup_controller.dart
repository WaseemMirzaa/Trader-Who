import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traderwho/core/config/app_routes.dart';

class SignupController extends GetxController {
  // Text controllers for input fields
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final passwordController = TextEditingController();

  // Observables
  var isLoading = false.obs;
  var isTradesperson = false.obs;
  var obscurePassword = true.obs;

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    isTradesperson.value = Get.arguments ?? false;
  }

  Future<void> signup({
    required String name,
    required String email,
    required String phone,
    required String address,
    required String password,
  }) async {
    // Enhanced validation
    if (name.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        address.isEmpty ||
        password.isEmpty) {
      Get.snackbar('Error', 'All fields are required.');
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar('Error', 'Invalid email format.');
      return;
    }

    if (!GetUtils.isPhoneNumber(phone)) {
      Get.snackbar('Error', 'Please enter a valid phone number.');
      return;
    }

    if (password.length < 8) {
      Get.snackbar('Error', 'Password must be at least 8 characters.');
      return;
    }

    if (!password.contains(RegExp(r'[A-Z]'))) {
      Get.snackbar(
        'Error',
        'Password must contain at least one uppercase letter.',
      );
      return;
    }

    if (!password.contains(RegExp(r'[0-9]'))) {
      Get.snackbar('Error', 'Password must contain at least one number.');
      return;
    }

    try {
      isLoading.value = true;

      // Create user with email and password
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );

      // Update user profile with name
      await userCredential.user?.updateDisplayName(name.trim());

      // Send email verification
      await userCredential.user?.sendEmailVerification();

      // Save user data to Firestore
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'name': name.trim(),
        'email': email.trim(),
        'phone': phone.trim(),
        'address': address.trim(),
        'userType': isTradesperson.value ? 'Tradesperson' : 'Customer',
        'emailVerified': false,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      isLoading.value = false;
      Get.snackbar(
        'Success',
        'Account created successfully! Please verify your email.',
      );
      Get.offNamed(AppRoutes.mainPageWithNavBar);
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      String message = _getAuthErrorMessage(e.code);
      Get.snackbar('Error', message);
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'An unexpected error occurred: ${e.toString()}');
    }
  }

  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'The email is already in use.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      default:
        return 'An authentication error occurred.';
    }
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
