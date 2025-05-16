import 'package:flutter/material.dart';
import 'package:traderwho/core/theme/app_color.dart';
import 'package:traderwho/core/theme/assets.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
        child: BottomNavigationBar(
          items: [
            _buildNavItem(Assets.imagesHome, 0),
            _buildNavItem(Assets.imagesDetails, 1),
            _buildNavItem(Assets.imagesChat, 2),
            _buildNavItem(Assets.imagesProfile, 3),
          ],
          currentIndex: currentIndex,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: onTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(String iconPath, int index) {
    bool isSelected = currentIndex == index;
    
    return BottomNavigationBarItem(
      icon: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Purple top bar indicator
          Container(
            height: 3,
            width: 24,
            decoration: BoxDecoration(
              color: isSelected ? AppColor.darkBlue : Colors.transparent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 6),
          // Icon with grey/color states
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