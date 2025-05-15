part of 'pages.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColor.purplecustomColor,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenWidth > 600 ? 400 : screenWidth * 0.9,
              minHeight: screenHeight,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                     SizedBox(height: screenHeight * 0.10), 
                    Image.asset(
                      Assets.imagesSplashscreen,
                      width: screenWidth > 600 ? 200 : screenWidth * 0.3,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: screenHeight * 0.35),
                    CustomText(
                      text: 'Trusted TradesPeople \n Just a tap away',
                      maxLines: 2,
                      fontSize: screenWidth > 600 ? 28 : 24,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                Column(
                  children: [
                    CustomButton(
                      text: 'Login',
                      onTap: () {
                       Get.toNamed(AppRoutes.login);
                      },
                      width: double.infinity,
                      height: screenHeight * 0.06,
                      color: AppColor.orangecustomColor,
                      textColor: Colors.white,
                      fontSize: screenWidth > 600 ? 18 : 16,
                      fontWeight: FontWeight.normal,
                      radius: 25,
                    ),
                    const Gap(20), // Space between buttons
                    
                    CustomButton(
                      text: 'Create New Account',
                      onTap: () {
                        Get.toNamed(AppRoutes.newAccount);
                      },
                      width: double.infinity,
                      height: screenHeight * 0.06,
                      color: AppColor.white,
                      textColor: AppColor.black,
                      fontSize: screenWidth > 600 ? 18 : 16,
                      fontWeight: FontWeight.normal,
                      enableBorder: true,
                      borderColor: AppColor.white,
                      radius: 24,
                    ),
                    const Gap(15), // Space before policy text
                    
                   RichText(
  textAlign: TextAlign.center,
  text: TextSpan(
    style: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: AppColor.white,
    ),
    children: const [
      TextSpan(text: 'By continuing, you agree to our\n'),
      TextSpan(
        text: 'Terms of Service',
        style: TextStyle(
          decoration: TextDecoration.underline,
        ),
      ),
      TextSpan(text: ' – '),
      TextSpan(
        text: 'Privacy Policy',
        style: TextStyle(
          decoration: TextDecoration.underline,
        ),
      ),
      TextSpan(text: ' – '),
      TextSpan(
        text: 'Content Policy',
        style: TextStyle(
          decoration: TextDecoration.underline,
        ),
      ),
    ],
  ),
),
                    const Gap(20), 
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}