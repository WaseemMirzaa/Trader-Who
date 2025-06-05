import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traderwho/views/chat/presentation/pages/pages.dart';
import 'package:traderwho/views/home/presentation/pages/pages.dart';
import 'package:traderwho/views/job_history/pages/pages.dart';
import 'package:traderwho/views/profile/presentation/pages/pages.dart';
import 'package:traderwho/views/trades_chat/presentation/pages/pages.dart';
import 'package:traderwho/views/trades_home/presentation/pages/pages.dart';
import 'package:traderwho/views/trades_job_history/presentation/widgets/widgets.dart';
import 'package:traderwho/views/trades_profile/presentation/pages/pages/pages.dart';

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
    TradeChatPage(),
    TradeProfilePage(),
  ];

  void changePage(int index) {
    if (currentIndex.value != index) {
      currentIndex.value = index;
      update(); // Force UI update
    }
  }

  void setUserType(bool isTrades) {
    debugPrint(
      'SETTING USER TYPE IN NAVIGATION CONTROLLER: isTrades = $isTrades',
    );
    isTradesPerson.value = isTrades;
    currentIndex.value = 0; // Reset to first tab

    // Force update
    update();

    // Print the current value to verify it was set
    debugPrint(
      'USER TYPE AFTER SETTING: isTradesperson = ${isTradesPerson.value}',
    );
  }

  List<Widget> get currentPages {
    final pages = isTradesPerson.value ? tradesPersonPages : customerPages;
    debugPrint(
      'Getting current pages based on user type: isTradesperson = ${isTradesPerson.value}',
    );
    return pages;
  }
}
