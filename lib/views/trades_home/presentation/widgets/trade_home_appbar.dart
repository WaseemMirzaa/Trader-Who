part of 'widgets.dart';

class TradeHomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TradeHomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Get current month and year (e.g., "May 2025")
    final String currentMonthYear = DateFormat(
      'MMMM yyyy',
    ).format(DateTime.now());

    return AppBar(
      backgroundColor: AppColor.appBackground,
      automaticallyImplyLeading: false,
      elevation: 0,
      toolbarHeight: 400, // Adjusted to accommodate new row
      flexibleSpace: Container(
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Colors.white,
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
                const SizedBox(height: 16),
                // Home and notification row
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      SizedBox(width: 20),
                      Expanded(
                        child: Center(
                          child: CustomText(
                            text: 'Home',

                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColor.primaryText,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => Get.toNamed(AppRoutes.tradeNotification),
                        child: SvgPicture.asset(
                          Assets.svgsNotification,
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                kGap20,
                // New row for "Upcoming Jobs" and current month/year
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Upcoming Jobs Date',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColor.primaryText,
                          fontFamily: 'openSans',
                        ),
                      ),
                      Text(
                        currentMonthYear, // e.g., "May 2025"
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: AppColor.primaryText,
                          fontFamily: 'openSans',
                        ),
                      ),
                    ],
                  ),
                ),
                kGap20,
                // Calendar section
                Flexible(
                  child: Container(
                    height: 320, // Kept to fit calendar
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColor.paleGray, width: 1.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: CalendarPicker(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(430); // Adjusted for new row
}
