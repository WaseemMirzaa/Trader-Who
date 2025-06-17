part of 'widgets.dart';

class NotificationAppbar extends StatefulWidget implements PreferredSizeWidget {
  const NotificationAppbar({super.key});

  @override
  State<NotificationAppbar> createState() => _NotificationAppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(120);
}

class _NotificationAppbarState extends State<NotificationAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.appBackground,
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
              color: AppColor.grey.withValues(alpha: 0.1),
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
                          "Notification",
                          style: TextStyle(
                            fontFamily: 'openSans',

                            color: AppColor.primaryText,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      // Right-aligned icon
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
