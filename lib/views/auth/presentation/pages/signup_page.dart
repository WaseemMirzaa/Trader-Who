part of 'pages.dart';

class SignupPage extends StatefulWidget {
  final bool isTradesperson;
  const SignupPage({super.key, required this.isTradesperson});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final bool _rememberMe = false;
  final _formKey = GlobalKey<FormState>();
  final SignupController controller = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GradientScaffold(
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        CustomText(
                          text:
                              widget.isTradesperson
                                  ? 'Create an Account'
                                  : 'Customer Signup',
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                        const SizedBox(
                          width: 48,
                        ), // Invisible spacer to balance the row
                      ],
                    ),
                    const Gap(80),

                    // Email/Phone Field
                    CustomTextField(
                      controller: controller.nameController,
                      borderColor: Colors.transparent,
                      hintText: 'Full Name',
                      hintStyle: const TextStyle(color: AppColor.midGray),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    const Gap(20),
                    CustomTextField(
                      controller: controller.emailController,
                      borderColor: Colors.transparent,
                      hintText: 'Email',
                      hintStyle: const TextStyle(color: AppColor.midGray),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    const Gap(20),
                    CustomTextField(
                      controller: controller.phoneController,
                      borderColor: Colors.transparent,
                      hintText: 'Phone',
                      hintStyle: const TextStyle(color: AppColor.midGray),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone';
                        }
                        return null;
                      },
                    ),
                    const Gap(20),
                    CustomTextField(
                      controller: controller.addressController,
                      borderColor: Colors.transparent,
                      hintText: 'Address(auto-location/manual)',
                      hintStyle: const TextStyle(color: AppColor.midGray),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Address';
                        }
                        return null;
                      },
                    ),
                    const Gap(20),

                    // Password Field
                    CustomTextField(
                      hintStyle: const TextStyle(color: AppColor.midGray),

                      controller: controller.passwordController,
                      borderColor: Colors.transparent,
                      hintText: 'Password',
                      obscureText: true,
                      showPasswordToggle: true,
                      passwordToggleIconColor: AppColor.midGray,
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
                    const Gap(30),

                    // Sign In Button
                    Obx(
                      () => CustomButton(
                        text: 'Sign Up',
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            controller.signup(
                              name: controller.nameController.text,
                              email: controller.emailController.text,
                              phone: controller.phoneController.text,
                              address: controller.addressController.text,
                              password: controller.passwordController.text,
                            );
                          }
                        },
                        width: double.infinity,
                        color: AppColor.orangecustomColor,
                        textColor: Colors.white,
                        fontSize: screenWidth > 600 ? 18 : 16,
                        fontWeight: FontWeight.normal,
                        radius: 25,
                        isLoading: controller.isLoading.value,
                        loadingColor: Colors.white,
                      ),
                    ),
                    const Gap(20),

                    // Or Divider
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 50, // length of left divider
                          child: Divider(color: AppColor.midGray, thickness: 1),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: CustomText(
                            text: 'Sign-in with Apple/Google',
                            color: AppColor.darkGrayText,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(
                          width: 50, // length of right divider
                          child: Divider(color: AppColor.midGray, thickness: 1),
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
                          color: AppColor.black,
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
    );
  }
}
