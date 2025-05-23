import 'package:get/get.dart';

class TradeJobHistoryController extends GetxController {
  var selectedIndex =
      0.obs; // 0 for TradesJobHistoryPage, 1 for TradeJobHistoryMapScreen
  var selectedTab = 'New Jobs'.obs; // Tracks "New Jobs" or "Completed"

  void switchToList() {
    selectedIndex.value = 0;
  }

  void switchToMap() {
    selectedIndex.value = 1;
  }

  void setTab(String tab) {
    selectedTab.value = tab;
  }
}
