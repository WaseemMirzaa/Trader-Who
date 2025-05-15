import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traderwho/core/shared_widgets/custom_button.dart';
import '../../core/config/app_routes.dart';
import '../../core/theme/theme.dart';
import 'controller.dart';

/// The splash page widget displayed when the app starts.
class SplashPage extends StatelessWidget {
  /// Creates an instance of the [SplashPage] widget.
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Explicitly find the controller to ensure it's initialized
    final controller = Get.find<SplashController>();
    debugPrint('SplashPage build called, controller: ${controller.hashCode}');

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: AppColor.purplecustomColor,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                Assets.imagesSplashscreen,
                width: 150,
                height: 150,
                fit: BoxFit.contain, 
              ),
kGap20,
             
            
            ],
          ),
        ),
      ),
    );
  }
}