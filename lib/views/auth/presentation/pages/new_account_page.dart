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
    return GradientScaffold(
      body: SingleChildScrollView(
        child: Column(
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
                    fontSize: context.responsiveFontSize(18),
                    fontWeight: FontWeight.normal,
                  ),
                  SizedBox(
                    width: context.responsiveWidth(12),
                  ), // Spacer for balance
                ],
              ),
            ),
            SizedBox(height: context.responsiveHeight(15)),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    navController.setUserType(false);
                    Get.toNamed(AppRoutes.signup, arguments: false);
                  },
                  child: Container(
                    width: 175,
                    height: 150,
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: EdgeInsets.all(context.responsiveWidth(4)),
                    margin: EdgeInsets.symmetric(
                      vertical: context.responsiveHeight(1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          Assets.imagesCustomer,
                          height: 55,
                          width: 62,
                        ),
                        SizedBox(height: context.responsiveHeight(1)),
                        CustomText(
                          text: 'Customer',
                          color: AppColor.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: context.responsiveHeight(3)),
                GestureDetector(
                  onTap: () {
                    navController.setUserType(true);
                    Get.toNamed(AppRoutes.signup, arguments: true);
                  },
                  child: Container(
                    width: 175,
                    height: 150,
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: EdgeInsets.all(context.responsiveWidth(4)),
                    margin: EdgeInsets.symmetric(
                      vertical: context.responsiveHeight(1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                            context.responsiveWidth(
                              2,
                            ), // Responsive border radius
                          ),
                          child: Image.asset(
                            Assets.imagesTradePeopleIcon,
                            height: context.responsiveHeight(
                              10,
                            ), // Responsive height
                            width: context.responsiveWidth(
                              25,
                            ), // Responsive width
                            fit:
                                BoxFit
                                    .cover, // Maintains image aspect ratio while fitting
                          ),
                        ),
                        SizedBox(height: context.responsiveHeight(0.8)),
                        CustomText(
                          text: 'Tradesperson',
                          color: AppColor.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: context.responsiveHeight(5)),
          ],
        ),
      ),
    );
  }
}
