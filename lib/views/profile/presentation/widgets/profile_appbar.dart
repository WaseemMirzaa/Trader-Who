part of 'widgets.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double avatarRadius =
        size.width * 0.13; // Slightly larger for profile
    final double avatarImageSize = avatarRadius * 2;

    return AppBar(
      backgroundColor: Colors.transparent,
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
              color: Colors.black.withOpacity(0.1),
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
                // Row with back button, centered "Profile" text, and edit icon
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      // Back button placeholder (to balance the edit icon)
                      SizedBox(width: 25),
                      // Matches the edit icon size

                      // Centered "Profile" text
                      Expanded(
                        child: Center(
                          child: const Text(
                            'Profile',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      // Edit icon
                      InkWell(
                        onTap: () {
                          // Handle edit profile action
                        },
                        child: SvgPicture.asset(
                          Assets.svgsProfileEdit,
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                kGap25,
                // Circular avatar
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
                kGap30,
                // Name text
                CustomText(
                  text: 'Alex Jerome!',
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                const SizedBox(height: 4),
                // Username text
                CustomText(
                  text: '@katemiddleton',
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: AppColor.midGray,
                ),
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
