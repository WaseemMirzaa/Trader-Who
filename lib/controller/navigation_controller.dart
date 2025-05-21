// navigation_controller.dart
import 'package:get/get.dart';
import 'package:traderwho/core/config/app_routes.dart';

class NavigationController extends GetxController {
  static NavigationController get to => Get.find();

  final RxInt currentIndex = 0.obs;
  final List<String> routes = [
    AppRoutes.homePage,
    AppRoutes.jobHistoryPage,
    AppRoutes.chatPage,
    AppRoutes.profilePage,

    // Add other routes here
  ];

  void changePage(int index) {
    if (currentIndex.value != index || Get.currentRoute != routes[index]) {
      currentIndex.value = index;
      Get.offNamedUntil(routes[index], (route) => false);
    }
  }
}
