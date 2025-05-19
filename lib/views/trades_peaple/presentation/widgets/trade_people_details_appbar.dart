part of 'widgets.dart';

class TradePersonDetailsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TradesPerson person;
  final VoidCallback? onBackPressed;

  const TradePersonDetailsAppBar({
    super.key,
    required this.person,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 300,
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
              color: Colors.black.withOpacity(0.1),
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
              children: [
                Stack(
                  children: [
                    Center(
                      child: Text(
                        'Details',
                        style: TextStyle(
                          fontSize: context.responsiveFontSize(24),
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 0,
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: context.responsiveFontSize(24),
                        ),
                        onPressed: onBackPressed ?? () => Navigator.pop(context),
                        padding: context.responsivePadding(horizontal: 0.5, vertical: 0.5),
                        constraints: const BoxConstraints(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.responsiveHeight(2)),
                CustomCircleAvatar(
                  radius: context.responsiveWidth(8),
                  imageUrl: person.imageUrl,
                ),
                SizedBox(height: context.responsiveHeight(2)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      person.name,
                      style: TextStyle(
                        fontSize: context.responsiveFontSize(20),
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: context.responsiveHeight(1)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          Assets.imagesPounds,
                          width: context.responsiveWidth(4),
                          height: context.responsiveWidth(4),
                        ),
                        SizedBox(width: context.responsiveWidth(1)),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Price: ',
                                style: TextStyle(
                                  fontSize: context.responsiveFontSize(15),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: '£${person.price}',
                                style: TextStyle(
                                  fontSize: context.responsiveFontSize(15),
                                  color: AppColor.mutedGray,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.responsiveHeight(1)),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       SvgPicture.asset(
          Assets.svgsTime,
          width: context.responsiveWidth(4),
                          height: context.responsiveWidth(4),
        ),
        kGap10,
                      
                       RichText(
                         text: TextSpan(
                           children: [
                             TextSpan(
                               text: 'Available Time: ',
                               style: TextStyle(
                                 fontSize: context.responsiveFontSize(14),
                                 color: AppColor.black,  // Usi
                               ),
                             ),
                             TextSpan(
                               text: '9:00 AM - 5:00 PM',
                               style: TextStyle(
                                 fontSize: context.responsiveFontSize(14),
                                 color: AppColor.mutedGray,  // Using mutedGray for the time
                               ),
                             ),
                           ],
                         ),
                       ),
                     ],
                   ),
                    kGap20,
                   Padding(
  padding: EdgeInsets.symmetric(horizontal: 20), // Adjust horizontal padding as needed
  child: SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    physics: const AlwaysScrollableScrollPhysics(),
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: context.screenWidth * 0.9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // Changed from end to center
        children: [
          CustomButton(
            text: 'Book Now',
            onTap: () {},
            width: context.responsiveWidth(29),
            height: context.responsiveHeight(4),
            color: AppColor.orangecustomColor,
            textColor: Colors.white,
            fontWeight: FontWeight.normal,
            radius: 25,
          ),
          kGap10,
          Image.asset(
            Assets.imagesCall,
            width: context.responsiveWidth(8),
            height: context.responsiveWidth(10),
          ),
          kGap10,
          Image.asset(
            Assets.imagesMessage,
            width: context.responsiveWidth(8),
            height: context.responsiveWidth(10),
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

  @override
  Size get preferredSize => const Size.fromHeight(300);
}