part of 'pages.dart';

class NewAccountPage extends StatefulWidget {
  const NewAccountPage({super.key});

  @override
  State<NewAccountPage> createState() => _NewAccountState();
}

class _NewAccountState extends State<NewAccountPage> {
  @override
  Widget build(BuildContext context) {
    final navController = NavigationController.to;
    return TraderouScaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.responsiveWidth(4),
              vertical: context.responsiveHeight(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                CustomText(
                  text: 'Create New Account',
                  color: AppColor.primaryText,
                  fontSize: context.responsiveFontSize(18),
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(
                  width: context.responsiveWidth(12),
                ), // Spacer for balance
              ],
            ),
          ),
          SizedBox(height: context.responsiveHeight(20)),

          // Simple row with both images
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Customer Image
              GestureDetector(
                onTap: () {
                  navController.setUserType(false);
                  Get.toNamed(AppRoutes.signup, arguments: false);
                },
                child: Image.asset(
                  Assets.imagesCustomer,
                  height: context.responsiveHeight(30),
                  width: context.responsiveWidth(40),
                  fit: BoxFit.cover,
                ),
              ),

              // Tradesperson Image
              GestureDetector(
                onTap: () {
                  navController.setUserType(true);
                  Get.toNamed(AppRoutes.signup, arguments: true);
                },
                child: Image.asset(
                  Assets.imagesTradePerson,
                  height: context.responsiveHeight(30),
                  width: context.responsiveWidth(40),
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          SizedBox(height: context.responsiveHeight(5)),
        ],
      ),
    );
  }
}
