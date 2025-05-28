part of 'widgets.dart';

class TradeChatAppbar extends StatefulWidget implements PreferredSizeWidget {
  const TradeChatAppbar({super.key});

  @override
  State<TradeChatAppbar> createState() => _TradeChatAppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(120);
}

class _TradeChatAppbarState extends State<TradeChatAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.appbarBackground,
      automaticallyImplyLeading: false,
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
                const SizedBox(height: 16),
                Expanded(
                  child: Stack(
                    children: [
                      // Centered title - takes full width but text is centered
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Chat",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      // Right-aligned icon
                      InkWell(
                        onTap: () => Get.toNamed(AppRoutes.tradeNotification),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: SvgPicture.asset(
                            Assets.svgsBlackNotification,
                            width: 24,
                            height: 24,
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
    );
  }
}
