part of 'pages.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late LoginController controller;
  @override
  void initState() {
    super.initState();
    controller = Get.put(LoginController(), permanent: true);
    // This ensures the controller is initialized and loadSavedCredentials is called
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColor.purplecustomColor,
      appBar: AppBar(
        centerTitle: true,
        title: const CustomText(
          text: 'Sign in Account',
          color: AppColor.customLightGray,
          fontSize: 18,
          fontWeight: FontWeight.normal,
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
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Gap(150),

                      // Email/Phone Field
                      CustomTextField(
                        fillColor: AppColor.darkSlateBlue,
                        borderColor: AppColor.darkSlateBlue,
                        controller: controller.emailController,
                        borderRadius: 11,
                        hintText: 'Email/Phone',

                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email or phone';
                          }
                          return null;
                        },
                      ),
                      const Gap(20),

                      // Password Field
                      CustomTextField(
                        fillColor: AppColor.darkSlateBlue,
                        borderColor: AppColor.darkSlateBlue,

                        controller: controller.passwordController,
                        hintText: 'Password',
                        obscureText: true,
                        showPasswordToggle: false,
                        borderRadius: 11,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      kGap10,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Remember Me Checkbox
                          Obx(
                            () => Row(
                              children: [
                                Checkbox(
                                  fillColor: WidgetStateProperty.resolveWith<
                                    Color?
                                  >((Set<WidgetState> states) {
                                    if (states.contains(WidgetState.selected)) {
                                      return AppColor
                                          .offWhite; // Background color when checked
                                    }
                                    return AppColor
                                        .darkSlateBlue; // Background color when unchecked
                                  }),
                                  side: BorderSide(color: AppColor.silverGray),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  value: controller.rememberMe.value,
                                  onChanged: (value) {
                                    if (value != null) {
                                      controller.rememberMe.value = value;
                                    }
                                  },
                                  activeColor:
                                      AppColor
                                          .offWhite, // Set activeColor to offWhite for consistency
                                  checkColor: AppColor.black,
                                ),
                                const CustomText(
                                  text: 'Remember me',
                                  color: AppColor.lightGrayText,
                                  fontSize: 14,
                                ),
                              ],
                            ),
                          ),

                          // Forgot Password
                          GestureDetector(
                            onTap: () {
                              // Add forgot password functionality
                            },
                            child: const CustomText(
                              text: 'Forgot password?',
                              color: AppColor.lightGrayText,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const Gap(30),

                      // Sign In Button
                      Obx(
                        () => CustomButton(
                          text: 'Login',
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              controller.login();
                            }
                          },
                          isLoading: controller.isLoading.value,
                          width: double.infinity,
                          color: AppColor.orangecustomColor,
                          textColor: Colors.white,
                          fontSize: screenWidth > 600 ? 18 : 16,
                          fontWeight: FontWeight.normal,
                          radius: 25,
                        ),
                      ),
                      const Gap(20),

                      // Or Divider
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 50, // length of left divider
                            child: Divider(
                              color: AppColor.darkSlateBlue,
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: CustomText(
                              text: 'Sign-in with Apple/Google',
                              color: AppColor.lightGrayText,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(
                            width: 50, // length of right divider
                            child: Divider(
                              color: AppColor.darkSlateBlue,
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      kGap20,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 140, // adjust width as needed
                            child: CustomButton(
                              text: 'Apple',
                              icon: SvgPicture.asset(
                                Assets.svgsApple,
                                height: 20,
                              ),
                              enableIcon: true,
                              color: Colors.white,
                              textColor: Colors.black,
                              onTap: controller.signInWithApple,

                              radius: 18,
                              height: 50,
                            ),
                          ),
                          kGap20,
                          SizedBox(
                            width: 140, // adjust width as needed
                            child: CustomButton(
                              text: 'Google',
                              icon: SvgPicture.asset(
                                Assets.svgsGoogle,
                                height: 20,
                              ),
                              enableIcon: true,
                              color: Colors.white,
                              textColor: Colors.black,
                              onTap: controller.signInWithGoogle,
                              radius: 18,
                              height: 50,
                            ),
                          ),
                        ],
                      ),
                      kGap20,
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
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
