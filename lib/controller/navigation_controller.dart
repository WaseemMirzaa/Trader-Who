import 'package:get/get.dart';
import 'package:traderwho/core/config/app_routes.dart';

class NavigationController extends GetxController {
  static NavigationController get to => Get.find();

  final RxInt currentIndex = 0.obs;
  final RxBool isTradesPerson = false.obs;

  // Customer routes
  final List<String> customerRoutes = [
    AppRoutes.homePage,
    AppRoutes.jobHistoryPage,
    AppRoutes.chatPage,
    AppRoutes.profilePage,
  ];

  // TradesPerson routes
  final List<String> tradesPersonRoutes = [
    AppRoutes.tradesHomePage,
    AppRoutes.tradesJobHistoryPage, // Add this route
    AppRoutes.tradesChatPage, // Add this route
    AppRoutes.tradesProfilePage, // Add this route
  ];

  List<String> get currentRoutes =>
      isTradesPerson.value ? tradesPersonRoutes : customerRoutes;

  void changePage(int index) {
    if (index >= currentRoutes.length)
      return; // Prevent navigation to undefined routes
    if (currentIndex.value != index ||
        Get.currentRoute != currentRoutes[index]) {
      currentIndex.value = index;
      Get.offNamedUntil(currentRoutes[index], (route) => false);
    }
  }

  void setUserType(bool isTrades) {
    isTradesPerson.value = isTrades;
    currentIndex.value = 0; // Reset to first tab
    // Navigate to the first route of the selected user type
    Get.offNamedUntil(currentRoutes[0], (route) => false);
  }
}
