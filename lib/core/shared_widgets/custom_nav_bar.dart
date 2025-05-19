// custom_nav_bar.dart
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
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: Obx(() => BottomNavigationBar(
          items: [
            _buildNavItem(Assets.imagesHome, 0),
            _buildNavItem(Assets.imagesDetails, 1),
            _buildNavItem(Assets.imagesChat, 2),
            _buildNavItem(Assets.imagesProfile, 3),
          ],
          currentIndex: navController.currentIndex.value,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: navController.changePage,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
        )),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(String iconPath, int index) {
    final isSelected = NavigationController.to.currentIndex.value == index;

    return BottomNavigationBarItem(
      icon: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 3,
            width: 24,
            decoration: BoxDecoration(
              color: isSelected ? AppColor.darkBlue : Colors.transparent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 6),
          Image.asset(
            iconPath,
            width: 24,
            height: 24,
            color: isSelected ? null : Colors.grey,
          ),
        ],
      ),
      label: '',
    );
  }
}