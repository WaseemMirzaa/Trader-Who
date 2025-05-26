part of 'widgets.dart';

class TradeCustomerFeedbackAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  const TradeCustomerFeedbackAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20.0),
        bottomRight: Radius.circular(20.0),
      ),
      child: AppBar(
        centerTitle: true,
        title: const CustomText(
          text: 'Customer Feedback',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColor.black,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColor.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
