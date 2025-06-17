part of 'pages.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _rememberMe = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
                        controller: _emailController,
                        borderRadius: 11,
                        hintText: 'Email/Phone',

                        keyboardType: TextInputType.emailAddress,
                        // validator: (value) {
                        //   if (value == null || value.isEmpty) {
                        //     return 'Please enter your email or phone';
                        //   }
                        //   return null;
                        // },
                      ),
                      const Gap(20),

                      // Password Field
                      CustomTextField(
                        fillColor: AppColor.darkSlateBlue,
                        borderColor: AppColor.darkSlateBlue,

                        controller: _passwordController,
                        hintText: 'Password',
                        obscureText: true,
                        showPasswordToggle: true,
                        borderRadius: 11,
                        // validator: (value) {
                        //   if (value == null || value.isEmpty) {
                        //     return 'Please enter your password';
                        //   }
                        //   if (value.length < 6) {
                        //     return 'Password must be at least 6 characters';
                        //   }
                        //   return null;
                        // },
                      ),
                      kGap10,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Remember Me Checkbox
                          Row(
                            children: [
                              Checkbox(
                                fillColor: WidgetStateProperty.all(
                                  AppColor.darkSlateBlue,
                                ),

                                side: BorderSide(color: AppColor.silverGray),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    6.0,
                                  ), // Adjust for roundness (e.g., 4.0 for slight rounding)
                                ),
                                value: _rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value!;
                                  });
                                },
                                activeColor: AppColor.orangecustomColor,
                                checkColor: AppColor.midGray,
                              ),
                              const CustomText(
                                text: 'Remember me',
                                color: AppColor.lightGrayText,
                                fontSize: 14,
                              ),
                            ],
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
                      CustomButton(
                        text: 'Sign in',
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            // Add sign in functionality
                          }
                        },
                        width: double.infinity,

                        color: AppColor.primaryButton,
                        textColor: Colors.white,
                        fontSize: screenWidth > 600 ? 18 : 16,
                        fontWeight: FontWeight.w600,
                        radius: 25,
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
                              onTap: () {},
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
                              onTap: () {},
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
