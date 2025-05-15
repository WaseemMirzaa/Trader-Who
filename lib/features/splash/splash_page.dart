import 'package:flutter/material.dart';

import '../../core/extensions/extensions.dart';
import '../../core/theme/theme.dart';

/// The splash page widget displayed when the app starts.
class SplashPage extends StatefulWidget {
  /// Creates an instance of the [SplashPage] widget.
  const SplashPage({super.key});

  @override
  State<StatefulWidget> createState() => SplashPageState();
}

/// The state class for the [SplashPage] widget, handling initialization and UI.
class SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      // if (mounted) {
      //   context.goToLoginPage();
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColor.navyGradient, 
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                Assets.imagesSplashscreen, 
                width: context.width * 0.8,
                height: _calculateLogoHeight(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _calculateLogoHeight(BuildContext context) {
    final double logoWidth = context.width * 0.8;
    double logoHeight = logoWidth * (146 / 831);
    if (logoHeight > context.height * 0.2) {
      logoHeight = context.height * 0.2;
    }
    return logoHeight;
  }
}