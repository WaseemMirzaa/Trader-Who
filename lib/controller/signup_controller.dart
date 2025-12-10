import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:traderou/core/config/app_routes.dart';
import 'package:traderou/core/shared_widgets/custom_time_picker.dart';
import 'package:traderou/core/shared_widgets/map_picker_screen.dart';
import 'package:traderou/core/theme/app_color.dart';
import 'package:traderou/models/user_model.dart';
import 'package:traderou/models/category_model.dart';

class SignupController extends GetxController {
  // Text controllers for input fields
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final bioController = TextEditingController();
  final titleController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();

  // Observables
  var isLoading = false.obs;
  var isTradesperson = false.obs;
  var obscurePassword = true.obs;
  var availability = false.obs;
  var startTime = Rx<TimeOfDay?>(null);
  var endTime = Rx<TimeOfDay?>(null);
  final selectedLat = Rx<double?>(null);
  final selectedLon = Rx<double?>(null);

  // Categories
  var categories = <CategoryModel>[].obs;
  var isLoadingCategories = false.obs;
  var selectedCategory = Rx<CategoryModel?>(null);

  // Certificates/Credentials
  var certificates = <XFile>[].obs;
  var isUploadingCertificates = false.obs;
  final ImagePicker _picker = ImagePicker();

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  void onInit() {
    super.onInit();
    isTradesperson.value = Get.arguments ?? false;
    if (isTradesperson.value) {
      loadCategories();
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    bioController.dispose();
    titleController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    super.onClose();
  }

  /// Pick certificates/qualifications
  Future<void> pickCertificates() async {
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage(
        imageQuality: 80,
      );

      if (pickedFiles.isNotEmpty) {
        certificates.addAll(pickedFiles);
        Get.snackbar(
          'Success',
          '${pickedFiles.length} certificate(s) added',
          backgroundColor: AppColor.orangeCustomColor,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('❌ Error picking certificates: $e');
      Get.snackbar(
        'Error',
        'Failed to pick certificates. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Remove a certificate from the list
  void removeCertificate(int index) {
    if (index >= 0 && index < certificates.length) {
      certificates.removeAt(index);
      Get.snackbar(
        'Removed',
        'Certificate removed',
        backgroundColor: AppColor.orangeCustomColor,
        colorText: Colors.white,
      );
    }
  }

  /// Upload certificates to Firebase Storage
  Future<List<String>> uploadCertificates(String userId) async {
    List<String> certificateUrls = [];

    try {
      isUploadingCertificates.value = true;

      for (int i = 0; i < certificates.length; i++) {
        final file = File(certificates[i].path);
        final fileName =
            'certificate_${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
        final ref = _storage.ref().child('credentials/$userId/$fileName');

        debugPrint(
          '📤 Uploading certificate ${i + 1}/${certificates.length}...',
        );
        await ref.putFile(file);
        final url = await ref.getDownloadURL();
        certificateUrls.add(url);
        debugPrint('✅ Certificate uploaded: $url');
      }

      debugPrint('✅ All certificates uploaded successfully');
    } catch (e) {
      debugPrint('❌ Error uploading certificates: $e');
      Get.snackbar(
        'Warning',
        'Some certificates failed to upload',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    } finally {
      isUploadingCertificates.value = false;
    }

    return certificateUrls;
  }

  /// Load categories from Firebase
  Future<void> loadCategories() async {
    try {
      isLoadingCategories.value = true;
      debugPrint('📂 Loading categories from Firebase...');

      final snapshot =
          await _firestore.collection('categories').orderBy('name').get();

      categories.value =
          snapshot.docs.map((doc) => CategoryModel.fromDoc(doc)).toList();

      debugPrint('✅ Loaded ${categories.length} categories');
    } catch (e) {
      debugPrint('❌ Error loading categories: $e');
      Get.snackbar(
        'Error',
        'Failed to load categories. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingCategories.value = false;
    }
  }

  Future<void> signup({
    required String name,
    required String email,
    required String phone,
    required String address,
    required String password,
    required String confirmPassword,
    String? bio,
    String? title,
    double? lat,
    double? lon,
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

      if (password != confirmPassword) {
        debugPrint('Validation failed: Passwords do not match');
        Get.snackbar('Error', 'Passwords do not match.');
        return;
      }

      if (isTradesperson.value) {
        if (bio == null || bio.isEmpty) {
          debugPrint('Validation failed: Bio is empty');
          Get.snackbar('Error', 'Please enter your bio');
          return;
        }
        if (selectedCategory.value == null) {
          debugPrint('Validation failed: Category not selected');
          Get.snackbar('Error', 'Please select your professional category');
          return;
        }
        if (startTime.value == null || endTime.value == null) {
          debugPrint('Validation failed: Working hours not selected');
          Get.snackbar('Error', 'Please select your working hours');
          return;
        }
        // Compare times by converting to minutes
        final startMinutes =
            startTime.value!.hour * 60 + startTime.value!.minute;
        final endMinutes = endTime.value!.hour * 60 + endTime.value!.minute;
        if (endMinutes <= startMinutes) {
          debugPrint(
            'Validation failed: End time is before or equal to start time',
          );
          Get.snackbar('Error', 'End time must be after start time');
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

      // Upload certificates if any for tradesperson
      List<String>? certificateUrls;
      if (isTradesperson.value && certificates.isNotEmpty) {
        debugPrint('Uploading ${certificates.length} certificates...');
        certificateUrls = await uploadCertificates(userCredential.user!.uid);
        debugPrint('Certificates uploaded: ${certificateUrls.length}');
      }

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
        lat: double.tryParse(latitudeController.text.trim()),
        lon: double.tryParse(longitudeController.text.trim()),
        userType: isTradesperson.value ? 'tradesperson' : 'customer',
        createdAt: DateTime.now(),
        title: isTradesperson.value ? selectedCategory.value?.id : null,
        bio: isTradesperson.value ? bio?.trim() : null,
        status: isTradesperson.value ? 'pending' : null,
        availability: isTradesperson.value ? availability.value : null,
        startTime: isTradesperson.value ? startDateTime : null,
        endTime: isTradesperson.value ? endDateTime : null,
        certificates: isTradesperson.value ? certificateUrls : null,
        username: !isTradesperson.value ? name.trim() : null,
      );

      // Save user data to Firestore
      await _firestore
          .collection('users')
          .doc(userCredential.user?.uid)
          .set(userModel.toMap());
      debugPrint('User data saved to Firestore with role-specific fields');

      // Send email verification
      await userCredential.user?.sendEmailVerification();
      debugPrint('Email verification sent');

      isLoading.value = false;
      Get.snackbar(
        'Success',
        'Verification email sent! Please verify your email.',
        colorText: AppColor.primaryText,
      );
      debugPrint('Showing success snackbar');

      // Navigate to EmailVerificationScreen and pass user data
      Get.toNamed(
        AppRoutes.emailVerification,
        arguments: {
          'email': email.trim(),
          'userModel': userModel,
          'isTradesperson': isTradesperson.value,
          'userId': userCredential.user?.uid,
        },
      );
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      String message = _getAuthErrorMessage(e.code);
      debugPrint('FirebaseAuthException: $message');
      Get.snackbar('Error', message);
    } catch (e) {
      isLoading.value = false;
      debugPrint('Unexpected error: $e');
      Get.snackbar('Error', 'An unexpected error occurred: ${e.toString()}');
    } finally {
      isLoading.value = false;
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
    final pickedTime = await showCustomTimePicker(
      context: context,
      initialTime: startTime.value ?? TimeOfDay.now(),
    );
    if (pickedTime != null) {
      startTime.value = pickedTime;
    }
  }

  Future<void> selectEndTime(BuildContext context) async {
    final pickedTime = await showCustomTimePicker(
      context: context,
      initialTime: endTime.value ?? TimeOfDay.now(),
    );
    if (pickedTime != null) {
      // If start time is already selected, ensure end is after start
      if (startTime.value != null) {
        final startMinutes =
            startTime.value!.hour * 60 + startTime.value!.minute;
        final pickedMinutes = pickedTime.hour * 60 + pickedTime.minute;
        if (pickedMinutes <= startMinutes) {
          Get.snackbar(
            'Invalid time',
            'End time must be after start time',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }
      }

      endTime.value = pickedTime;
    }
  }

  Future<void> pickLocationFromMap() async {
    try {
      final result = await Get.to<Map<String, dynamic>>(
        () => const MapPickerScreen(),
      );
      if (result != null) {
        addressController.text = result['address'];
        selectedLat.value = result['lat'];
        selectedLon.value = result['lon'];
        latitudeController.text = result['lat'].toString();
        longitudeController.text = result['lon'].toString();
      }
    } catch (e) {
      debugPrint("Error picking location: $e");
      Get.snackbar('Error', 'Could not pick location');
    }
  }

  Future<void> signUpWithGoogle() async {
    try {
      isLoading.value = true;

      final GoogleSignIn googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user == null) throw Exception("Google sign-in failed");

      final now = DateTime.now();

      final userModel = UserModel(
        name: user.displayName ?? '',
        email: user.email ?? '',
        phone: '',
        address: '',
        lat: selectedLat.value,
        lon: selectedLon.value,
        userType: isTradesperson.value ? 'tradesperson' : 'customer',
        createdAt: now,
        title: isTradesperson.value ? titleController.text.trim() : null,
        bio: isTradesperson.value ? bioController.text.trim() : null,
        status: isTradesperson.value ? 'pending' : null,
        availability: isTradesperson.value ? availability.value : null,
        startTime:
            isTradesperson.value && startTime.value != null
                ? DateTime(
                  now.year,
                  now.month,
                  now.day,
                  startTime.value!.hour,
                  startTime.value!.minute,
                )
                : null,
        endTime:
            isTradesperson.value && endTime.value != null
                ? DateTime(
                  now.year,
                  now.month,
                  now.day,
                  endTime.value!.hour,
                  endTime.value!.minute,
                )
                : null,
        username: !isTradesperson.value ? user.displayName : null,
        latitude:
            isTradesperson.value
                ? double.tryParse(latitudeController.text.trim())
                : null,
        longitude:
            isTradesperson.value
                ? double.tryParse(longitudeController.text.trim())
                : null,
      );

      await _firestore.collection('users').doc(user.uid).set(userModel.toMap());

      isLoading.value = false;
      Get.offAllNamed(AppRoutes.mainPageWithNavBar);
    } catch (e) {
      isLoading.value = false;
      debugPrint("Google signup error: $e");
      Get.snackbar("Error", "Google sign-up failed.");
    }
  }

  Future<void> signUpWithApple() async {
    try {
      isLoading.value = true;

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final userCredential = await _auth.signInWithCredential(oauthCredential);
      final user = userCredential.user;
      if (user == null) throw Exception("Apple sign-in failed");

      final now = DateTime.now();

      final userModel = UserModel(
        name: user.displayName ?? appleCredential.givenName ?? '',
        email: user.email ?? '',
        phone: '',
        address: '',
        lat: selectedLat.value,
        lon: selectedLon.value,
        userType: isTradesperson.value ? 'tradesperson' : 'customer',
        createdAt: now,
        title: isTradesperson.value ? titleController.text.trim() : null,
        bio: isTradesperson.value ? bioController.text.trim() : null,
        status: isTradesperson.value ? 'pending' : null,
        availability: isTradesperson.value ? availability.value : null,
        startTime:
            isTradesperson.value && startTime.value != null
                ? DateTime(
                  now.year,
                  now.month,
                  now.day,
                  startTime.value!.hour,
                  startTime.value!.minute,
                )
                : null,
        endTime:
            isTradesperson.value && endTime.value != null
                ? DateTime(
                  now.year,
                  now.month,
                  now.day,
                  endTime.value!.hour,
                  endTime.value!.minute,
                )
                : null,
        username:
            !isTradesperson.value
                ? (user.displayName ?? appleCredential.givenName)
                : null,
      );

      await _firestore.collection('users').doc(user.uid).set(userModel.toMap());

      isLoading.value = false;
      Get.offAllNamed(AppRoutes.mainPageWithNavBar);
    } catch (e) {
      isLoading.value = false;
      debugPrint("Apple signup error: $e");
      Get.snackbar("Error", "Apple sign-up failed.");
    }
  }
}
