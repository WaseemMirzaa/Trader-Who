import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traderwho/controller/navigation_controller.dart';
import 'package:traderwho/core/shared_widgets/custom_nav_bar.dart';
import 'package:traderwho/core/shared_widgets/custom_sccfold.dart';

class MainPageWithNavbar extends StatefulWidget {
  const MainPageWithNavbar({super.key});

  @override
  State<MainPageWithNavbar> createState() => _MainPageWithNavbarState();
}

class _MainPageWithNavbarState extends State<MainPageWithNavbar> {
  @override
  void initState() {
    super.initState();

    // Make sure NavigationController is registered
    if (!Get.isRegistered<NavigationController>()) {
      Get.put(NavigationController());
    }

    // Print the current user type
    final controller = Get.find<NavigationController>();
    debugPrint(
      'MAIN PAGE INIT: isTradesperson = ${controller.isTradesPerson.value}',
    );

    // Force a rebuild after a short delay
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          debugPrint(
            'FORCED REBUILD: isTradesperson = ${controller.isTradesPerson.value}',
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NavigationController>();
    debugPrint(
      'MAIN PAGE BUILD: isTradesperson = ${controller.isTradesPerson.value}',
    );

    return GetBuilder<NavigationController>(
      builder: (controller) {
        debugPrint(
          'MAIN PAGE GETBUILDER: isTradesperson = ${controller.isTradesPerson.value}',
        );

        return GradientScaffold(
          body: Obx(() {
            final currentIndex = controller.currentIndex.value;
            final isTradesperson = controller.isTradesPerson.value;
            final pages =
                isTradesperson
                    ? controller.tradesPersonPages
                    : controller.customerPages;

            debugPrint(
              'RENDERING PAGE: index=$currentIndex, isTradesperson=$isTradesperson',
            );

            if (currentIndex >= 0 && currentIndex < pages.length) {
              return pages[currentIndex];
            } else {
              return pages[0];
            }
          }),
          bottomNavigationBar: const CustomNavBar(),
        );
      },
    );
  }
}
