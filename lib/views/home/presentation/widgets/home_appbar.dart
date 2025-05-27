part of 'widgets.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double avatarRadius = size.width * 0.10;
    final double avatarImageSize = avatarRadius * 2;

    return AppBar(
      backgroundColor: AppColor.appbarBackground,
      automaticallyImplyLeading: false,
      elevation: 0,
      toolbarHeight: 200,
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
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: SafeArea(
          // Add SafeArea here
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                const SizedBox(height: 16),
                // Title row
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Center(
                            child: const Text(
                              'Home',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => Get.toNamed(AppRoutes.notificationPage),
                        child: SvgPicture.asset(
                          Assets.svgsNotification,
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // User info row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      CustomCircleAvatar(
                        radius: avatarRadius,
                        circleColor: AppColor.orangecustomColor,

                        child: Image(
                          image: AssetImage(Assets.imagesCircularAvatar),
                          width: avatarImageSize,
                          height: avatarImageSize,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: 'Hi, Alex Jerome!',
                              fontSize: 24,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                            kGap10,
                            CustomText(
                              text: 'customer',
                              decorationColor: AppColor.midGray,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: AppColor.darkerGray,
                            ),
                          ],
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

  @override
  Size get preferredSize => const Size.fromHeight(200);
}
