part of 'widgets.dart';

class JobHistoryContainer extends StatelessWidget {
  const JobHistoryContainer({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    Get.put(TradeJobHistoryController());

    return GetBuilder<TradeJobHistoryController>(
      builder:
          (controller) => TraderWhoScaffold(
            appBar: TradesJobHistoryAppbar(
              onListPressed: controller.switchToList,
              onMapPressed: controller.switchToMap,
            ),
            body: Obx(
              () => IndexedStack(
                index: controller.selectedIndex.value,
                children: const [
                  TradesJobHistoryPage(),
                  TradeJobHistoryMapScreen(),
                ],
              ),
            ),
          ),
    );
  }
}
