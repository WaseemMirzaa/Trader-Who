part of 'widgets.dart';

class TradePersonDetailsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final TradesPerson person;
  final VoidCallback? onBackPressed;
  final double screenHeight;

  const TradePersonDetailsAppBar({
    super.key,
    required this.person,
    this.onBackPressed,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.appBackground,
      elevation: 0,
      toolbarHeight: screenHeight,
      automaticallyImplyLeading: false,
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
          top: false,
          child: Padding(
            padding: context.responsivePadding(horizontal: 3, vertical: 3),
            child: Column(
              spacing: 20,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: context.responsiveFontSize(24),
                      ),
                      onPressed: onBackPressed ?? () => Navigator.pop(context),
                      padding: context.responsivePadding(
                        horizontal: 0.5,
                        vertical: 0.5,
                      ),
                      constraints: const BoxConstraints(),
                    ),
                    SizedBox(width: 100),
                    CustomText(
                      text: 'Details',
                      fontSize: context.responsiveFontSize(18),
                      fontWeight: FontWeight.w600,
                      color: AppColor.primaryText,
                    ),
                  ],
                ),

                _buildAvatarWithFallback(context),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      person.name,
                      style: TextStyle(
                        fontSize: context.responsiveFontSize(20),
                        fontWeight: FontWeight.w600,
                        color: AppColor.primaryText,
                        fontFamily: 'openSans',
                      ),
                    ),
                    kGap10,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          Assets.svgsPound,
                          width: context.responsiveWidth(4),
                          height: context.responsiveWidth(4),
                        ),
                        kGap5,
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Price: ',
                                style: TextStyle(
                                  fontSize: context.responsiveFontSize(15),
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.primaryText,
                                  fontFamily: 'openSans',
                                ),
                              ),
                              TextSpan(
                                text: '£${person.price}',
                                style: TextStyle(
                                  fontSize: context.responsiveFontSize(15),
                                  color: AppColor.secondaryText,
                                  fontFamily: 'openSans',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    kGap15,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          Assets.svgsTime,
                          width: context.responsiveWidth(4),
                          height: context.responsiveWidth(4),
                        ),
                        kGap5,
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Available Time: ',
                                style: TextStyle(
                                  fontSize: context.responsiveFontSize(14),
                                  color: AppColor.primaryText,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'openSans',
                                ),
                              ),
                              TextSpan(
                                text: '9:00 AM - 5:00 PM',
                                style: TextStyle(
                                  fontSize: context.responsiveFontSize(14),
                                  color: AppColor.secondaryText,
                                  fontFamily: 'openSans',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    kGap15,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: context.screenWidth * 0.9,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomButton(
                                text: 'Book Now',
                                onTap: () {},
                                width: context.responsiveWidth(29),
                                height: context.responsiveHeight(4.5),
                                color: AppColor.orangecustomColor,
                                textColor: Colors.white,

                                radius: 25,
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {}, // Add call functionality here
                                child: Container(
                                  width: context.responsiveWidth(10),
                                  height: context.responsiveWidth(10),
                                  decoration: BoxDecoration(
                                    color:
                                        AppColor
                                            .darkBlue, // Dark blue background
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      Assets.svgsCall,
                                      width: context.responsiveWidth(5),
                                      height: context.responsiveWidth(5),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {}, // Add message functionality here
                                child: Container(
                                  width: context.responsiveWidth(10),
                                  height: context.responsiveWidth(10),
                                  decoration: BoxDecoration(
                                    color:
                                        AppColor
                                            .darkBlue, // Dark blue background
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      Assets.svgsMessage,
                                      width: context.responsiveWidth(5),
                                      height: context.responsiveWidth(5),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarWithFallback(BuildContext context) {
    return Container(
      width: context.responsiveWidth(24),
      height: context.responsiveWidth(24),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColor.midGray.withOpacity(0.2),
      ),
      child: ClipOval(
        child: Image.asset(
          person.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(Assets.imagesChatThomas, fit: BoxFit.cover);
          },
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(screenHeight);
}
