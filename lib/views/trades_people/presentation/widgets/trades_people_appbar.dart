part of 'widgets.dart';

class TradesPeopleAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback? onMapPressed;
  final VoidCallback? onListPressed;

  const TradesPeopleAppbar({super.key, this.onMapPressed, this.onListPressed});

  @override
  Size get preferredSize => const Size.fromHeight(120);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TradeController>();

    return Obx(
      () => AppBar(
        backgroundColor: AppColor.appBackground,
        elevation: 0,
        toolbarHeight: 120,
        flexibleSpace: Container(
          margin: EdgeInsets.zero,
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColor.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  SizedBox(height: 16),
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned.fill(
                          child: Center(
                            child: CustomText(
                              text: "Tradespeople",
                              color: AppColor.primaryText,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            width: 78,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColor.midGray,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: onListPressed,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color:
                                          controller.selectedIndex.value == 0
                                              ? AppColor.darkBlue
                                              : Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: SvgPicture.asset(
                                      Assets.svgsNomap,
                                      color:
                                          controller.selectedIndex.value == 0
                                              ? AppColor.white
                                              : Colors
                                                  .black, // White when selected, black when not
                                      width: 18,
                                      height: 18,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                GestureDetector(
                                  onTap: onMapPressed,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color:
                                          controller.selectedIndex.value == 1
                                              ? AppColor.darkBlue
                                              : Colors.transparent,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: SvgPicture.asset(
                                      Assets.svgsMap,
                                      color:
                                          controller.selectedIndex.value == 1
                                              ? AppColor.white
                                              : Colors
                                                  .black, // White when selected, black when not
                                      width: 18,
                                      height: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
