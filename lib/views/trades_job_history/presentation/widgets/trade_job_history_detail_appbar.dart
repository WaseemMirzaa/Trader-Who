part of 'widgets.dart';

class TradeJobHistoryDetailAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  final String status; // Add status parameter

  const TradeJobHistoryDetailAppbar({
    super.key,
    required this.status, // Require status in constructor
  });

  @override
  Widget build(BuildContext context) {
    // Determine title based on status
    final String title =
        status.toLowerCase() == 'completed'
            ? 'Completed Job Details'
            : 'New Job Details';

    return AppBar(
      backgroundColor: AppColor.appbarBackground,
      elevation: 0,
      toolbarHeight: 120, // Decreased height
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ),
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
                // This is the row with centered TradeJobHistoryDetailAppbar and right-aligned notification
                Expanded(
                  child: Center(
                    child: Text(
                      title, // Use dynamic title
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w500,
                        color: AppColor.darkBlueText,
                      ),
                    ),
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
  Size get preferredSize => const Size.fromHeight(100); // Updated height
}
