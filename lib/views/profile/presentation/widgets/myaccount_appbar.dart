part of 'widgets.dart';

class MyAccountAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAccountAppBar({super.key});

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
          text: 'My Account',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColor.primaryText,
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
