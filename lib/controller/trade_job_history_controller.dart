import 'package:get/get.dart';
import 'package:traderou/controller/job_history_page_controller.dart';

class TradeJobHistoryController extends GetxController {
  var selectedIndex =
      0.obs; // 0 for TradesJobHistoryPage, 1 for TradeJobHistoryMapScreen
  var selectedTab = 'New Jobs'.obs; // Tracks "New Jobs" or "Completed"

  @override
  void onInit() {
    super.onInit();
    // Initialize Firebase data controller if not already done
    if (!Get.isRegistered<JobHistoryPageController>()) {
      Get.put(JobHistoryPageController());
    }
  }

  void switchToList() {
    selectedIndex.value = 0;
  }

  void switchToMap() {
    selectedIndex.value = 1;
  }

  void setTab(String tab) {
    selectedTab.value = tab;
    // Optional: Could trigger data refresh when tab changes
    _refreshDataIfNeeded();
  }

  /// Refresh data when needed
  void _refreshDataIfNeeded() {
    if (Get.isRegistered<JobHistoryPageController>()) {
      final jobController = Get.find<JobHistoryPageController>();
      // Only refresh if data is stale or empty
      if (jobController.jobHistoryItems.isEmpty) {
        jobController.refreshBookings();
      }
    }
  }

  /// Get filtered jobs based on current tab
  List<dynamic> getFilteredJobs() {
    if (Get.isRegistered<JobHistoryPageController>()) {
      final jobController = Get.find<JobHistoryPageController>();
      final allJobs = jobController.jobHistoryItems;

      return allJobs
          .where(
            (job) =>
                selectedTab.value == 'New Jobs'
                    ? job.status != 'Completed'
                    : job.status == 'Completed',
          )
          .toList();
    }
    return [];
  }

  /// Manual refresh trigger
  Future<void> refreshData() async {
    if (Get.isRegistered<JobHistoryPageController>()) {
      final jobController = Get.find<JobHistoryPageController>();
      await jobController.refreshBookings();
    }
  }
}
