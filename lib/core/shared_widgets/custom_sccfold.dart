import 'package:flutter/material.dart';
import 'package:traderwho/core/theme/app_color.dart';

class GradientScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar; // Make appBar nullable
  final Widget? drawer;
  final Widget? bottomNavigationBar;

  const GradientScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.drawer,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      drawer: drawer,
      bottomNavigationBar: bottomNavigationBar,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColor.defaultGradient, // Use the gradient from AppColor
        ),
        child: body,
      ),
    );
  }
}
