// controllers/trade_controller.dart
import 'package:get/get.dart';

class TradeController extends GetxController {
  var selectedIndex = 0.obs; // 0 for list view, 1 for map view
  var isMapActive = false.obs;

  void switchToList() {
    selectedIndex.value = 0;
    isMapActive.value = false;
  }

  void switchToMap() {
    selectedIndex.value = 1;
    isMapActive.value = true;
  }
}
