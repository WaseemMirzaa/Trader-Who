import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:traderwho/core/theme/app_color.dart';
import 'package:traderwho/models/user_model.dart';

class TradeMyaccountController extends GetxController {
  // Text controllers for input fields
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final titleController = TextEditingController();
  final bioController = TextEditingController();

  // Observables
  final RxBool showShimmer = true.obs;
  final RxString error = ''.obs;
  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final Rx<File?> profileImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

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
    titleController.dispose();
    bioController.dispose();
    super.onClose();
  }

  Future<void> pickProfileImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        profileImage.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<String?> _uploadProfileImage() async {
    if (profileImage.value == null) return null;

    try {
      final authUser = FirebaseAuth.instance.currentUser;
      if (authUser == null) return null;

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('${authUser.uid}.jpg');

      await storageRef.putFile(profileImage.value!);
      return await storageRef.getDownloadURL();
    } catch (e) {
      error('Failed to upload image: ${e.toString()}');
      return null;
    }
  }

  Future<void> fetchUserData() async {
    try {
      showShimmer(true);
      error('');

      final authUser = FirebaseAuth.instance.currentUser;
      if (authUser == null) {
        showShimmer(false);
        error('No authenticated user');
        print('TradeMyAccount: No authenticated user');
        return;
      }

      print('TradeMyAccount: Fetching data for user: ${authUser.uid}');
      // Fetch user data from unified users collection
      final userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(authUser.uid)
              .get();

      print('TradeMyAccount: Document exists: ${userDoc.exists}');
      if (userDoc.exists) {
        print('TradeMyAccount: Document data: ${userDoc.data()}');
        final userData = UserModel.fromFirestore(userDoc);
        user.value = userData;
        print(
          'TradeMyAccount: UserModel created: ${userData.name}, type: ${userData.userType}',
        );

        // Split name into first and last name
        final nameParts = userData.name.split(' ');
        final firstName = nameParts.isNotEmpty ? nameParts[0] : '';
        final lastName =
            nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

        // Set all user data controllers
        firstNameController.text = firstName;
        lastNameController.text = lastName;
        emailController.text = userData.email;
        phoneController.text = userData.phone ?? '';
        addressController.text = userData.address ?? '';

        // Set tradesperson specific fields if user is a tradesperson
        titleController.text = userData.title ?? '';
        bioController.text = userData.bio ?? '';
      } else {
        // Document doesn't exist, use auth data
        print('TradeMyAccount: Document does not exist, using auth data');
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
        titleController.text = '';
        bioController.text = '';

        // Create a basic user model for display
        user.value = UserModel(
          id: authUser.uid,
          name: name,
          email: authUser.email ?? '',
          userType:
              'tradesperson', // Default to tradesperson for trade myaccount page
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

      // Upload image if selected
      final imageUrl = await _uploadProfileImage();

      // Combine first and last name
      final fullName =
          '${firstNameController.text} ${lastNameController.text}'.trim();

      // Prepare update data
      final updateData = {
        'name': fullName,
        'email': emailController.text,
        'phone': phoneController.text,
        'address': addressController.text,
        'title': titleController.text,
        'bio': bioController.text,
        'updatedAt': FieldValue.serverTimestamp(),
        // Explicitly remove customer fields for tradespeople
        'username': FieldValue.delete(),
      };

      // Add image URL if uploaded
      if (imageUrl != null) {
        updateData['profileImage'] = imageUrl;
      }

      // Update all user data in unified users collection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(authUser.uid)
          .update(updateData);

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
