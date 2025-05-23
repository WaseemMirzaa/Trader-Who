import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traderwho/views/chat/presentation/pages/pages.dart';
import 'package:traderwho/views/home/presentation/pages/pages.dart';
import 'package:traderwho/views/job_history/pages/pages.dart';
import 'package:traderwho/views/main_page_with_navbar.dart';
import 'package:traderwho/views/profile/presentation/pages/pages.dart';
import 'package:traderwho/views/trades_home/presentation/pages/pages.dart';
import 'package:traderwho/views/trades_job_history/presentation/widgets/widgets.dart';

class NavigationController extends GetxController {
  static NavigationController get to => Get.find();

  final RxInt currentIndex = 0.obs;
  final RxBool isTradesPerson = false.obs;

  // Different pages for each user type
  final List<Widget> customerPages = [
    HomePage(),
    JobHistoryPage(),
    ChatPage(),
    ProfileScreen(),
  ];

  final List<Widget> tradesPersonPages = [
    TradeHomePage(),
    JobHistoryContainer(),
    ChatPage(),
    ProfileScreen(),
  ];

  void changePage(int index) {
    if (currentIndex.value != index) {
      currentIndex.value = index;
    }
  }

  void setUserType(bool isTrades) {
    isTradesPerson.value = isTrades;
    currentIndex.value = 0; // Reset to first tab
    Get.offAll(() => MainPageWithNavbar()); // Navigate to main page
  }

  List<Widget> get currentPages =>
      isTradesPerson.value ? tradesPersonPages : customerPages;
}
