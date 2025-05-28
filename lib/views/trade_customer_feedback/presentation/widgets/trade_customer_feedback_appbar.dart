part of 'widgets.dart';

class TradeCustomerFeedbackAppbar extends StatefulWidget
    implements PreferredSizeWidget {
  const TradeCustomerFeedbackAppbar({super.key});

  @override
  State<TradeCustomerFeedbackAppbar> createState() =>
      _TradeCustomerFeedbackAppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(120);
}

class _TradeCustomerFeedbackAppbarState
    extends State<TradeCustomerFeedbackAppbar> {
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
                      // Back button aligned left
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: AppColor.black,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      // Centered title
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Customer Feedback',
                          style: TextStyle(
                            color: AppColor.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
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
