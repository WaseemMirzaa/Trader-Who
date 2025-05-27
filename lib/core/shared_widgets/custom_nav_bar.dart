// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:traderwho/controller/navigation_controller.dart';
// import 'package:traderwho/core/theme/app_color.dart';
// import 'package:traderwho/core/theme/assets.dart';

// class CustomNavBar extends StatelessWidget {
//   const CustomNavBar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final navController = NavigationController.to;

//     return Obx(() {
//       return Container(
//         decoration: BoxDecoration(
//           color: AppColor.white,
//           borderRadius: const BorderRadius.only(
//             topLeft: Radius.circular(20),
//             topRight: Radius.circular(20),
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 8,
//               offset: const Offset(0, -2),
//             ),
//           ],
//         ),
//         child: ClipRRect(
//           borderRadius: const BorderRadius.only(
//             topLeft: Radius.circular(20),
//             topRight: Radius.circular(20),
//           ),
//           child: BottomNavigationBar(
//             items: _buildNavItems(),
//             currentIndex: navController.currentIndex.value,
//             showSelectedLabels: false,
//             showUnselectedLabels: false,
//             onTap: navController.changePage,
//             type: BottomNavigationBarType.fixed,
//             backgroundColor: Colors.transparent,
//             elevation: 0,
//           ),
//         ),
//       );
//     });
//   }

//   List<BottomNavigationBarItem> _buildNavItems() {
//     const icons = [
//       Assets.imagesHome,
//       Assets.imagesDetails,
//       Assets.imagesChat,
//       Assets.imagesProfile,
//     ];

//     return icons.map((iconPath) {
//       final index = icons.indexOf(iconPath);
//       final isSelected = NavigationController.to.currentIndex.value == index;

//       return BottomNavigationBarItem(
//         icon: Container(
//           padding: const EdgeInsets.only(top: 4),
//           decoration: BoxDecoration(
//             border:
//                 isSelected
//                     ? const Border(
//                       top: BorderSide(color: AppColor.darkBlue, width: 3),
//                     )
//                     : null,
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const SizedBox(height: 4),
//               Image.asset(
//                 iconPath,
//                 width: 24,
//                 height: 24,
//                 color: isSelected ? AppColor.darkBlue : Colors.grey,
//               ),
//             ],
//           ),
//         ),
//         label: '',
//       );
//     }).toList();
//   }
// }
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
      // Same icons for both user types
      const icons = [
        Assets.imagesHome,
        Assets.imagesDetails,
        Assets.imagesChat,
        Assets.imagesProfile,
      ];

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
            items: _buildNavItems(icons, navController.currentIndex.value),
            currentIndex: navController.currentIndex.value,
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

  List<BottomNavigationBarItem> _buildNavItems(
    List<String> icons,
    int currentIndex,
  ) {
    return icons.map((iconPath) {
      final index = icons.indexOf(iconPath);
      final isSelected = currentIndex == index;

      return BottomNavigationBarItem(
        icon: Container(
          padding: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
            border:
                isSelected
                    ? const Border(
                      top: BorderSide(color: AppColor.darkBlue, width: 2),
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
                color: isSelected ? AppColor.darkBlue : Colors.grey,
              ),
            ],
          ),
        ),
        label: '',
      );
    }).toList();
  }
}
