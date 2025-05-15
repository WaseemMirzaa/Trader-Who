import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/config/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    debugPrint('SplashController initialized');
    navigateToLogin();
  }

  void navigateToLogin() {
    debugPrint('navigateToLogin called, will navigate in 3 seconds');
    Future.delayed(const Duration(seconds: 3), () {
      debugPrint('Attempting to navigate to ${AppRoutes.login}');
      // Try direct navigation first
      Get.toNamed(AppRoutes.onboarding);
    });
  }
}
