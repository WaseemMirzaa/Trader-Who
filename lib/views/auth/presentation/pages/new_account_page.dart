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
      appBar: AppBar(
        centerTitle: true,

        title: CustomText(
          text: 'Create New Account',
          color: AppColor.black,
          fontWeight: FontWeight.bold,
          fontSize: context.responsiveFontSize(16),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    navController.setUserType(false);
                    Get.toNamed(AppRoutes.signup);
                  },
                  child: Container(
                    width: context.responsiveWidth(45),
                    height: context.responsiveHeight(20),
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
                          height: context.responsiveHeight(6),
                          width: context.responsiveWidth(12),
                        ),
                        SizedBox(height: context.responsiveHeight(1)),
                        CustomText(
                          text: 'Customer',
                          color: AppColor.black,
                          fontWeight: FontWeight.bold,
                          fontSize: context.responsiveFontSize(14),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: context.responsiveHeight(3)),

                GestureDetector(
                  onTap: () {
                    navController.setUserType(true);
                    Get.toNamed(AppRoutes.signup);
                  },
                  child: Container(
                    width: context.responsiveWidth(45),
                    height: context.responsiveHeight(20),
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
                          Assets.imagesPeople,
                          height: context.responsiveHeight(6),
                          width: context.responsiveWidth(12),
                        ),
                        SizedBox(height: context.responsiveHeight(1)),
                        CustomText(
                          text: 'TradesPerson',
                          color: AppColor.black,
                          fontWeight: FontWeight.bold,
                          fontSize: context.responsiveFontSize(14),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: context.responsiveHeight(5)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
