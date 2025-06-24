import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traderwho/controller/navigation_controller.dart';
import 'package:traderwho/core/config/app_routes.dart';
import 'package:traderwho/core/theme/app_color.dart';
import 'package:traderwho/models/user_model.dart';

class SignupController extends GetxController {
  // Text controllers for input fields
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final passwordController = TextEditingController();
  final bioController = TextEditingController();
  final titleController = TextEditingController();

  // Observables
  var isLoading = false.obs;
  var isTradesperson = false.obs;
  var obscurePassword = true.obs;
  var availability = false.obs;
  var startTime = Rx<TimeOfDay?>(null);
  var endTime = Rx<TimeOfDay?>(null);

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
    String? bio,
    String? title,
  }) async {
    try {
      isLoading.value = true;
      debugPrint('Starting signup process for email: $email');

      // Validation
      if (name.isEmpty ||
          email.isEmpty ||
          phone.isEmpty ||
          address.isEmpty ||
          password.isEmpty) {
        debugPrint('Validation failed: All fields are required');
        Get.snackbar('Error', 'All fields are required.');
        return;
      }

      if (!GetUtils.isEmail(email)) {
        debugPrint('Validation failed: Invalid email format');
        Get.snackbar('Error', 'Invalid email format.');
        return;
      }

      if (!GetUtils.isPhoneNumber(phone)) {
        debugPrint('Validation failed: Invalid phone number');
        Get.snackbar('Error', 'Please enter a valid phone number.');
        return;
      }

      if (password.length < 8) {
        debugPrint('Validation failed: Password too short');
        Get.snackbar('Error', 'Password must be at least 8 characters.');
        return;
      }

      if (!password.contains(RegExp(r'[A-Z]'))) {
        debugPrint('Validation failed: No uppercase letter in password');
        Get.snackbar(
          'Error',
          'Password must contain at least one uppercase letter.',
        );
        return;
      }

      if (!password.contains(RegExp(r'[0-9]'))) {
        debugPrint('Validation failed: No number in password');
        Get.snackbar('Error', 'Password must contain at least one number.');
        return;
      }

      if (isTradesperson.value) {
        if (bio == null || bio.isEmpty) {
          debugPrint('Validation failed: Bio is empty');
          Get.snackbar('Error', 'Please enter your bio');
          return;
        }
        if (title == null || title.isEmpty) {
          debugPrint('Validation failed: Title is empty');
          Get.snackbar('Error', 'Please enter your professional title');
          return;
        }
        if (startTime.value == null || endTime.value == null) {
          debugPrint('Validation failed: Working hours not selected');
          Get.snackbar('Error', 'Please select your working hours');
          return;
        }
      }

      debugPrint('Validation passed, creating user...');
      // Create user with email and password
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );
      debugPrint('User created: ${userCredential.user?.uid}');

      // Update user profile with name
      await userCredential.user?.updateDisplayName(name.trim());
      debugPrint('Display name updated');

      // Send email verification
      await userCredential.user?.sendEmailVerification();
      debugPrint('Email verification sent');

      // Create user model with role-specific fields
      final now = DateTime.now();
      final startDateTime =
          isTradesperson.value && startTime.value != null
              ? DateTime(
                now.year,
                now.month,
                now.day,
                startTime.value!.hour,
                startTime.value!.minute,
              )
              : null;
      final endDateTime =
          isTradesperson.value && endTime.value != null
              ? DateTime(
                now.year,
                now.month,
                now.day,
                endTime.value!.hour,
                endTime.value!.minute,
              )
              : null;

      final userModel = UserModel(
        name: name.trim(),
        email: email.trim(),
        phone: phone.trim(),
        address: address.trim(),
        userType: isTradesperson.value ? 'tradesperson' : 'customer',
        createdAt: DateTime.now(),
        password: password.trim(),
        // Tradesperson specific fields (only set if tradesperson)
        title: isTradesperson.value ? title?.trim() : null,
        bio: isTradesperson.value ? bio?.trim() : null,
        status: isTradesperson.value ? 'pending' : null,
        availability: isTradesperson.value ? availability.value : null,
        startTime: isTradesperson.value ? startDateTime : null,
        endTime: isTradesperson.value ? endDateTime : null,
        // Customer specific fields (only set if customer)
        username: !isTradesperson.value ? name.trim() : null,
      );

      // Save all user data to single users collection
      await _firestore
          .collection('users')
          .doc(userCredential.user?.uid)
          .set(userModel.toMap());
      debugPrint('User data saved to Firestore with role-specific fields');

      isLoading.value = false;
      Get.snackbar(
        'Success',
        'Account created successfully! Please verify your email.',
        colorText: AppColor.primaryText,
      );
      debugPrint('Showing success snackbar');
      NavigationController.to.setUserType(isTradesperson.value);
      debugPrint('User type set in NavigationController');
      if (Get.context != null) {
        debugPrint('Navigating to mainPageWithNavBar');
        Get.offNamed(AppRoutes.mainPageWithNavBar);
      } else {
        debugPrint('Navigation context is null');
      }
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

  Future<void> selectStartTime(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      startTime.value = pickedTime;
    }
  }

  Future<void> selectEndTime(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      endTime.value = pickedTime;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    passwordController.dispose();
    bioController.dispose();
    titleController.dispose();
    super.onClose();
  }
}
