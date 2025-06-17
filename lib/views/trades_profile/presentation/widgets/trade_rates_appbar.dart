part of 'widgets.dart';

class TradeRatesAppbar extends StatefulWidget implements PreferredSizeWidget {
  const TradeRatesAppbar({super.key});

  @override
  State<TradeRatesAppbar> createState() => _TradeRatesAppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(90); // Match the toolbarHeight
}

class _TradeRatesAppbarState extends State<TradeRatesAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.appBackground,
      automaticallyImplyLeading: false,
      elevation: 0,
      toolbarHeight: 100,
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
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Back button
                    InkWell(
                      onTap: () => Get.back(),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                    kGap20,
                    // Centered title
                    Expanded(
                      child: Center(
                        child: CustomText(
                          text: "Set Fixed Prices for Small Jobs",
                          color: AppColor.primaryText,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    // This empty SizedBox balances the back button in the row
                    SizedBox(width: 24),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
