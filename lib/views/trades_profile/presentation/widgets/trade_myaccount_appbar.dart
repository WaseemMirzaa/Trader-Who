part of 'widgets.dart';

class TradeMyaccountAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  const TradeMyaccountAppbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20.0),
        bottomRight: Radius.circular(20.0),
      ),
      child: AppBar(
        backgroundColor: AppColor.appbarBackground,
        centerTitle: true,
        title: const CustomText(
          text: 'My Account',
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: AppColor.black,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColor.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}
