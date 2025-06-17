part of 'widgets.dart';

class TradeServicesSignupAppbar extends StatefulWidget
    implements PreferredSizeWidget {
  const TradeServicesSignupAppbar({super.key});

  @override
  State<TradeServicesSignupAppbar> createState() =>
      _TradeServicesSignupAppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(70);
}

class _TradeServicesSignupAppbarState extends State<TradeServicesSignupAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.appBackground,
      automaticallyImplyLeading: false,
      elevation: 0,
      toolbarHeight: 90,
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
                const SizedBox(height: 16),
                Expanded(
                  child: Stack(
                    children: [
                      // Back button on the left

                      // Centered title
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Services",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 19,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      // Right-aligned notification icon
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
