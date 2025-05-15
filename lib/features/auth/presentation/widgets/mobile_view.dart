part of 'widgets.dart';

/// Mobile View Screen
class MobileView extends StatefulWidget {
  /// MobileView Constructor
  const MobileView({super.key});

  @override
  State<MobileView> createState() => _MobileViewState();
}

class _MobileViewState extends State<MobileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColor.navyGradient, // Applying navyGradient (#313649 to #132241)
        ),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              // Top-centered splash screen image
              Image.asset(
                Assets.imagesSplashscreen,
                height: 100, // Adjust height as needed
                alignment: Alignment.center,
              ),
              kGap20, // Space after image
              // CustomText with "Trusted"
              const CustomText(
                text: 'Trusted',
                fontSize: 28,
                color: AppColor.white, // White text for contrast on dark gradient
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
              kGap20, // Space after text
              // Login button
              CustomButton(
                onTap: () {
                  // Navigate to login page (replace with your navigation logic)
                  context.goToLoginPage();
                },
                text: 'Login',
                enableIcon: true,
              ),
              kGap20, // Space between buttons
              // Create New Account button
              CustomButton(
                onTap: () {
                  // Navigate to signup page (replace with your navigation logic)
                  context.goToSignUpPage();
                },
                text: 'Create New Account',
                enableIcon: true,
              ),
              kGap20, // Space before final text
              // Final CustomText
              const CustomText(
                text: 'Welcome',
                fontSize: 14,
                color: AppColor.white, // White text for contrast
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w200,
                overflow: TextOverflow.ellipsis,
              ),
              kGap20, // Bottom padding
            ],
          ),
        ),
      ),
    );
  }
}