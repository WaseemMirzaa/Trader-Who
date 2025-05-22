part of 'widgets.dart';

class MyAccountAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAccountAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: const CustomText(
        text: 'My Account',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColor.black,
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColor.black),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
