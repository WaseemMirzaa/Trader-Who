part of 'pages.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.find<LoginController>();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColor.purpleCustomColor,
      appBar: AppBar(
        centerTitle: true,
        title: const CustomText(
          text: 'Forget Password',
          color: AppColor.customLightGray,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenWidth > 600 ? 400 : screenWidth * 0.9,
              minHeight: screenHeight,
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Gap(150),
                    const CustomText(
                      text: 'Enter your email to receive a password reset link',
                      color: AppColor.lightGrayText,
                      fontSize: 16,
                      textAlign: TextAlign.center,
                    ),
                    const Gap(30),
                    // Email Field
                    CustomTextField(
                      fillColor: AppColor.darkSlateBlue,
                      borderColor: AppColor.darkSlateBlue,
                      controller: controller.emailController,
                      borderRadius: 11,
                      hintText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!GetUtils.isEmail(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const Gap(30),
                    // Send Reset Email Button
                    Obx(
                      () => CustomButton(
                        text: 'Send Reset Link',
                        onTap: () {
                          controller.resetPassword();
                        },
                        isLoading: controller.isLoading.value,
                        width: double.infinity,
                        color: AppColor.orangeCustomColor,
                        textColor: Colors.white,
                        fontSize: screenWidth > 600 ? 18 : 16,
                        fontWeight: FontWeight.normal,
                        radius: 25,
                      ),
                    ),
                    const Gap(20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
