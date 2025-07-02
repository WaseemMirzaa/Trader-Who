part of 'widgets.dart';

class ChangePasswordAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  const ChangePasswordAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 105, // Decreased height
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColor.black),
        onPressed: () => Navigator.of(context).pop(),
      ),
      flexibleSpace: Container(
        margin: EdgeInsets.zero,
        decoration: const BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: const SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                SizedBox(height: 16),
                // This is the row with centered JobPost and right-aligned notification
                Expanded(
                  child: Center(
                    child: CustomText(
                      text: 'Change Password',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColor.black,
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
  Size get preferredSize => const Size.fromHeight(105); // Updated height
}
