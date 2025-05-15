// custom_circular_indicator.dart

import 'package:flutter/material.dart';

import '../theme/app_color.dart';

/// A [CustomCircularIndicator]  widget that uses the app's primary color.
class CustomCircularIndicator extends StatelessWidget {
  /// [CustomCircularIndicator] constructor
  const CustomCircularIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(AppColor.blue),
      ),
    );
  }
}
