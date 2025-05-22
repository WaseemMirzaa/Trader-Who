import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traderwho/controller/navigation_controller.dart';
import 'package:traderwho/core/theme/app_color.dart';
import 'package:traderwho/core/theme/assets.dart';

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final navController = NavigationController.to;

    return Obx(() {
      // Only show nav bar if there are routes available
      if (navController.currentRoutes.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            items: List.generate(
              navController.currentRoutes.length,
              (index) => _buildNavItem(_getIconPath(index), index),
            ),
            currentIndex: navController.currentIndex.value.clamp(
              0,
              navController.currentRoutes.length - 1,
            ),
            showSelectedLabels: false,
            showUnselectedLabels: false,
            onTap: navController.changePage,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
      );
    });
  }

  BottomNavigationBarItem _buildNavItem(String iconPath, int index) {
    final isSelected = NavigationController.to.currentIndex.value == index;
    final navController = NavigationController.to;
    final isDisabled = index >= navController.currentRoutes.length;

    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.only(top: 4), // Space for the top indicator
        decoration: BoxDecoration(
          border:
              isSelected
                  ? const Border(
                    top: BorderSide(color: AppColor.darkBlue, width: 3),
                  )
                  : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 4),
            Image.asset(
              iconPath,
              width: 24,
              height: 24,
              color:
                  isDisabled
                      ? Colors.grey.withOpacity(0.3)
                      : (isSelected ? AppColor.darkBlue : Colors.grey),
            ),
          ],
        ),
      ),
      label: '',
    );
  }

  String _getIconPath(int index) {
    const icons = [
      Assets.imagesHome,
      Assets.imagesDetails,
      Assets.imagesChat,
      Assets.imagesProfile,
    ];
    return index < icons.length ? icons[index] : Assets.imagesHome;
  }
}
