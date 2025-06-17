import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traderwho/controller/navigation_controller.dart';
import 'package:traderwho/core/shared_widgets/custom_nav_bar.dart';
import 'package:traderwho/core/shared_widgets/custom_sccfold.dart';

class MainPageWithNavbar extends StatelessWidget {
  const MainPageWithNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    final navController = NavigationController.to;

    return Obx(
      () => TraderWhoScaffold(
        body: navController.currentPages.elementAt(
          navController.currentIndex.value,
        ),
        bottomNavigationBar: const CustomNavBar(),
      ),
    );
  }
}
