part of 'widgets.dart';

// widgets.dart
class TradeContainer extends StatelessWidget {
  const TradeContainer({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    Get.put(TradeController());

    return GetBuilder<TradeController>(
      builder:
          (controller) => GradientScaffold(
            appBar: TradesPeopleAppbar(
              onListPressed: controller.switchToList,
              onMapPressed: controller.switchToMap,
            ),
            body: Obx(
              () => IndexedStack(
                index: controller.selectedIndex.value,
                children: const [TradesPage(), MapScreen()],
              ),
            ),
          ),
    );
  }
}
