part of 'widgets.dart';

class TradeProfileAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  const TradeProfileAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double avatarRadius =
        size.width * 0.15; // Slightly larger for profile
    final double avatarImageSize = avatarRadius * 2;
    final TradeProfileController profileController =
        Get.isRegistered<TradeProfileController>()
            ? Get.find<TradeProfileController>()
            : Get.put(TradeProfileController());

    return AppBar(
      backgroundColor: AppColor.appBackground,
      automaticallyImplyLeading: false,
      elevation: 0,
      toolbarHeight: 280, // Increased height to accommodate the layout
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
              color: Colors.grey.withOpacity(0.1),
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
                kGap15,
                SizedBox(
                  width: double.infinity,

                  child: Row(
                    children: [
                      SizedBox(width: 25),
                      // Back button placeholder (to balance the edit icon)

                      // Matches the edit icon size

                      // Centered "Profile" text
                      Expanded(
                        child: Center(
                          child: const Text(
                            'Profile',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColor.primaryText,
                              fontFamily: 'openSans',
                            ),
                          ),
                        ),
                      ),
                      // Edit icon
                      InkWell(
                        onTap: () {
                          profileController.refreshProfile();
                        },
                        child: Obx(
                          () =>
                              profileController.isLoading.value
                                  ? SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColor.orangeCustomColor,
                                      ),
                                    ),
                                  )
                                  : SvgPicture.asset(
                                    Assets.svgsTradeProfileUpdate,
                                    width: 24,
                                    height: 24,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
                kGap25,
                // Circular avatar
                CustomCircleAvatar(
                  radius: avatarRadius,
                  circleColor: AppColor.orangeCustomColor,
                  child: Image(
                    image: AssetImage(Assets.imagesTradeProfile),
                    width: avatarImageSize,
                    height: avatarImageSize,
                    fit: BoxFit.cover,
                  ),
                ),

                Obx(() {
                  if (profileController.isLoading.value) {
                    return Column(
                      children: [
                        Container(
                          width: 150,
                          height: 22,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 200,
                          height: 15,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    );
                  }

                  if (profileController.error.value.isNotEmpty) {
                    return Column(
                      children: [
                        Text(
                          'Error loading profile',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Please try again',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: AppColor.darkerGray,
                          ),
                        ),
                      ],
                    );
                  }

                  return Column(
                    children: [
                      // Name text
                      Text(
                        profileController.name.value.isEmpty
                            ? 'Loading...'
                            : profileController.name.value,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Email text
                      Text(
                        profileController.email.value.isEmpty
                            ? 'Loading...'
                            : profileController.email.value,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: AppColor.darkerGray,
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(280);
}
