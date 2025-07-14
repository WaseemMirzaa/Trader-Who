import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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
      if (authUser == null) {
        throw Exception('User not authenticated');
      }

      // Validate file existence
      final file = profileImage.value!;
      if (!await file.exists()) {
        throw Exception('Selected file does not exist');
      }

      final fileExtension = file.path.split('.').last.toLowerCase();
      final contentType = fileExtension == 'png' ? 'image/png' : 'image/jpeg';

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_profile_images')
          .child(
            '${authUser.uid}_${DateTime.now().millisecondsSinceEpoch}.$fileExtension',
          );

      final uploadTask = storageRef.putFile(
        file,
        SettableMetadata(
          contentType: contentType,
          customMetadata: {'uploadedBy': authUser.uid},
        ),
      );

      // Monitor upload progress
      uploadTask.snapshotEvents.listen(
        (taskSnapshot) {
          debugPrint(
            'Upload progress: ${(taskSnapshot.bytesTransferred / taskSnapshot.totalBytes) * 100}%',
          );
        },
        onError: (error) {
          debugPrint('Upload error: $error');
        },
      );

      // Wait for upload completion
      final taskSnapshot = await uploadTask;

      // Check upload state
      if (taskSnapshot.state != TaskState.success) {
        throw Exception('Upload failed with state: ${taskSnapshot.state}');
      }

      // Get download URL with retry mechanism
      final downloadUrl = await storageRef.getDownloadURL().timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw Exception('Timeout getting download URL'),
      );

      return downloadUrl;
    } on FirebaseException catch (e) {
      debugPrint('Firebase Storage error: ${e.code} - ${e.message}');
      Get.snackbar(
        'Upload Error',
        'Failed to upload image: ${e.message ?? e.code}',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
      return null;
    } catch (e, stackTrace) {
      debugPrint('Image upload error: $e');
      debugPrint(stackTrace.toString());
      Get.snackbar(
        'Upload Error',
        'Failed to upload image: ${e.toString().replaceAll(RegExp(r'^Exception: '), '')}',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
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

      final authUser = FirebaseAuth.instance.currentUser;
      if (authUser == null) {
        Get.snackbar(
          'Error',
          'No authenticated user',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Upload image if selected and get URL
      String? imageUrl;
      if (profileImage.value != null) {
        imageUrl = await _uploadProfileImage();
        // Continue even if image upload fails (imageUrl will be null)
      }

      // Prepare update data including image URL
      final updateData = {
        'name': '${firstNameController.text} ${lastNameController.text}'.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'address': addressController.text.trim(),
        'title': titleController.text.trim(),
        'bio': bioController.text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
        if (imageUrl != null) 'image': imageUrl,
      };

      // Update Firestore document
      await FirebaseFirestore.instance
          .collection('users')
          .doc(authUser.uid)
          .update(updateData);

      // Update local user model
      user.value = user.value?.copyWith(
        name: updateData['name'] as String,
        email: updateData['email'] as String,
        phone: updateData['phone'] as String?,
        address: updateData['address'] as String?,
        title: updateData['title'] as String?,
        bio: updateData['bio'] as String?,
        image: imageUrl ?? user.value?.image,
      );

      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.back();
    } on FirebaseException catch (e) {
      Get.snackbar(
        'Error',
        'Update failed: ${e.message ?? e.code}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Update failed: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      showShimmer(false);
    }
  }
}
