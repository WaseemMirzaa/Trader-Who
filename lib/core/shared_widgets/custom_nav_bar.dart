import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:traderwho/controller/navigation_controller.dart';
import 'package:traderwho/core/theme/app_color.dart';
import 'package:traderwho/core/theme/assets.dart';

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final navController = NavigationController.to;
    final double indicatorWidth = 24; // Reduced width for the top indicator

    return Obx(() {
      // SVG icons for navigation
      final icons = [
        Assets.svgsHome,
        Assets.svgsDetails,
        Assets.svgsChat,
        Assets.svgsProfile,
      ];

      return SizedBox(
        height: 80, // Reduced height (standard is usually 56-60)
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.grey.withValues(alpha: 0.1),
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
                  items: _buildNavItems(
                    icons,
                    navController.currentIndex.value,
                  ),
                  currentIndex: navController.currentIndex.value,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  onTap: navController.changePage,
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
              ),
            ),
            // Top border indicator - now with reduced width
            Positioned(
              top: 0,
              left:
                  (MediaQuery.of(context).size.width /
                      icons.length *
                      navController.currentIndex.value) +
                  (MediaQuery.of(context).size.width / icons.length -
                          indicatorWidth) /
                      2,
              width: indicatorWidth,
              child: Container(height: 2, color: AppColor.darkBlue),
            ),
          ],
        ),
      );
    });
  }

  List<BottomNavigationBarItem> _buildNavItems(
    List<String> icons,
    int currentIndex,
  ) {
    return icons.map((iconPath) {
      final index = icons.indexOf(iconPath);
      final isSelected = currentIndex == index;

      return BottomNavigationBarItem(
        icon: Container(
          padding: const EdgeInsets.only(top: 6), // Reduced padding
          child: SvgPicture.asset(
            iconPath,
            width: 22, // Slightly smaller icons
            height: 22,
            color: isSelected ? AppColor.darkBlue : Colors.grey,
          ),
        ),
        label: '',
      );
    }).toList();
  }
}
