import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:traderwho/controller/navigation_controller.dart';
import 'package:traderwho/core/config/app_routes.dart';

class LoginController extends GetxController {
  // Controllers for text fields
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Secure storage for credentials
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Observables
  final rememberMe = false.obs;
  final isLoading = false.obs;
  final obscurePassword = true.obs;
  final isLoggedIn = false.obs;
  final authException = ''.obs;

  // Authentication instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    _initializeAuth();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> _initializeAuth() async {
    try {
      isLoading.value = true;

      // Check for existing session
      if (_auth.currentUser != null && _auth.currentUser!.emailVerified) {
        isLoggedIn.value = true;
        await _checkUserTypeAndNavigate(_auth.currentUser!.uid);
        return;
      }

      // Clear text fields on initialization to prevent pre-filling
      emailController.clear();
      passwordController.clear();

      // Only load saved credentials if rememberMe is explicitly true
      final remembered = await _secureStorage.read(key: 'rememberMe');
      if (remembered == 'true') {
        rememberMe.value = true;
        await _loadSavedCredentials();
        // Do NOT auto-login here. Only pre-fill fields.
        // if (emailController.text.isNotEmpty &&
        //     passwordController.text.isNotEmpty) {
        //   await _attemptAutoLogin();
        // }
      } else {
        // Ensure credentials are cleared if rememberMe is not set
        await _clearAllCredentials();
      }
    } catch (e) {
      debugPrint('Auth initialization error: $e');
      authException.value = 'Failed to initialize authentication';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadSavedCredentials() async {
    try {
      emailController.text = await _secureStorage.read(key: 'savedEmail') ?? '';
      passwordController.text =
          await _secureStorage.read(key: 'savedPassword') ?? '';
    } catch (e) {
      debugPrint('Error loading credentials: $e');
      authException.value = 'Failed to load saved credentials';
    }
  }

  Future<void> _attemptAutoLogin() async {
    try {
      isLoading.value = true;
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (userCredential.user!.emailVerified) {
        await _checkUserTypeAndNavigate(userCredential.user!.uid);
      } else {
        await _auth.signOut();
        Get.snackbar(
          'Verification Required',
          'Please verify your email before logging in',
          duration: const Duration(seconds: 5),
        );
      }
    } on FirebaseAuthException catch (e) {
      authException.value = _getAuthErrorMessage(e.code);
      debugPrint('Auto-login failed: ${e.code}');
    } catch (e) {
      authException.value = 'Auto-login failed. Please login manually';
      debugPrint('Auto-login error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login() async {
    if (!_validateInputs()) return;

    try {
      isLoading.value = true;
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!userCredential.user!.emailVerified) {
        await _handleUnverifiedEmail();
        return;
      }

      await _checkUserTypeAndNavigate(userCredential.user!.uid);
    } on FirebaseAuthException catch (e) {
      _handleLoginError(e);
    } catch (e) {
      _handleUnexpectedError(e);
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateInputs() {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields');
      return false;
    }

    if (!GetUtils.isEmail(emailController.text)) {
      Get.snackbar('Error', 'Please enter a valid email');
      return false;
    }

    return true;
  }

  Future<void> _handleUnverifiedEmail() async {
    await _auth.signOut();
    Get.snackbar(
      'Email Not Verified',
      'Please verify your email before logging in',
      duration: const Duration(seconds: 5),
    );
  }

  Future<void> _handleSuccessfulLogin() async {
    await _saveCredentialsIfRemembered();
    isLoggedIn.value = true;
    Get.offAllNamed(AppRoutes.mainPageWithNavBar);
  }

  Future<void> _saveCredentialsIfRemembered() async {
    try {
      if (rememberMe.value) {
        await _secureStorage.write(key: 'rememberMe', value: 'true');
        await _secureStorage.write(
          key: 'savedEmail',
          value: emailController.text.trim(),
        );
        await _secureStorage.write(
          key: 'savedPassword',
          value: passwordController.text.trim(),
        );
      } else {
        // Clear credentials if rememberMe is not checked
        await _clearAllCredentials();
      }
    } catch (e) {
      debugPrint('Error saving credentials: $e');
    }
  }

  void _handleLoginError(FirebaseAuthException e) {
    authException.value = _getAuthErrorMessage(e.code);
    Get.snackbar('Login Failed', authException.value);
  }

  void _handleUnexpectedError(dynamic e) {
    authException.value = 'An unexpected error occurred';
    Get.snackbar('Error', authException.value);
    debugPrint('Unexpected error: $e');
  }

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      await _checkUserTypeAndNavigate(userCredential.user!.uid);
    } catch (e) {
      authException.value = 'Google Sign-In failed';
      Get.snackbar('Error', authException.value);
      debugPrint('Google sign-in error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithApple() async {
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
      await _checkUserTypeAndNavigate(userCredential.user!.uid);
    } catch (e) {
      authException.value = 'Apple Sign-In failed';
      Get.snackbar('Error', authException.value);
      debugPrint('Apple sign-in error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      await _clearAllCredentials();
      isLoggedIn.value = false;
      rememberMe.value = false; // Reset rememberMe state
      emailController.clear(); // Clear text fields
      passwordController.clear();
      Get.offAllNamed(AppRoutes.onboarding);
    } catch (e) {
      debugPrint('Logout error: $e');
      Get.snackbar('Error', 'Logout failed. Please try again');
    }
  }

  Future<void> _clearAllCredentials() async {
    try {
      await _secureStorage.delete(key: 'rememberMe');
      await _secureStorage.delete(key: 'savedEmail');
      await _secureStorage.delete(key: 'savedPassword');
    } catch (e) {
      debugPrint('Error clearing credentials: $e');
    }
  }

  Future<void> resetPassword() async {
    if (emailController.text.isEmpty ||
        !GetUtils.isEmail(emailController.text)) {
      Get.snackbar('Error', 'Please enter a valid email');
      return;
    }

    try {
      isLoading.value = true;
      await _auth.sendPasswordResetEmail(email: emailController.text.trim());
      Get.snackbar(
        'Password Reset',
        'A password reset link has been sent to your email',
        duration: const Duration(seconds: 5),
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to send password reset email');
    } finally {
      isLoading.value = false;
    }
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'too-many-requests':
        return 'Too many attempts. Try again later';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'invalid-email':
        return 'Please enter a valid email';
      case 'network-request-failed':
        return 'Network error. Check your connection';
      default:
        return 'Login failed. Please try again';
    }
  }

  Future<void> _checkUserTypeAndNavigate(String uid) async {
    try {
      final userDoc = await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        final userData = userDoc.data();
        if (userData == null) {
          debugPrint('USER DATA IS NULL');
          Get.snackbar('Error', 'User profile data is missing');
          return;
        }

        debugPrint('FIRESTORE USER DATA: $userData');

        bool isTradesperson = false;
        if (userData.containsKey('user_type')) {
          final userType = userData['user_type'];
          debugPrint(
            'USER TYPE FROM FIRESTORE: $userType (${userType.runtimeType})',
          );
          if (userType is String) {
            isTradesperson = userType.toLowerCase() == 'tradesperson';
          }
          debugPrint('DETERMINED IS TRADESPERSON: $isTradesperson');
        }

        if (!Get.isRegistered<NavigationController>()) {
          Get.put(NavigationController());
        }

        debugPrint(
          'SETTING USER TYPE IN NAVIGATION CONTROLLER: $isTradesperson',
        );
        NavigationController.to.setUserType(isTradesperson);

        await _saveCredentialsIfRemembered();
        isLoggedIn.value = true;

        Get.forceAppUpdate();
        await Future.delayed(const Duration(milliseconds: 100));

        debugPrint('NAVIGATING TO MAIN PAGE WITH USER TYPE: $isTradesperson');
        Get.offAllNamed(AppRoutes.mainPageWithNavBar);
      } else {
        debugPrint('USER DOCUMENT NOT FOUND IN FIRESTORE');
        Get.snackbar('Error', 'User profile not found');
      }
    } catch (e) {
      debugPrint('ERROR CHECKING USER TYPE: $e');
      Get.snackbar('Error', 'Failed to load user profile');
    }
  }
}
