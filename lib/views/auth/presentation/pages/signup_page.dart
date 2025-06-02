part of 'pages.dart';

class SignupPage extends StatefulWidget {
  final bool isTradesperson;
  const SignupPage({super.key, required this.isTradesperson});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
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
                          onPressed: () => Get.back(),
                        ),
                        CustomText(
                          text:
                              widget.isTradesperson
                                  ? 'Create an Account'
                                  : 'Customer Signup',
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                    const Gap(80),

                    // Name Field
                    CustomTextField(
                      controller: controller.nameController,
                      borderColor: Colors.transparent,
                      hintText: 'Full Name',
                      hintStyle: const TextStyle(color: AppColor.midGray),
                      keyboardType: TextInputType.name,
                      textColor: AppColor.midGray,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    const Gap(20),

                    // Email Field
                    CustomTextField(
                      controller: controller.emailController,
                      borderColor: Colors.transparent,
                      hintText: 'Email',
                      hintStyle: const TextStyle(color: AppColor.midGray),
                      keyboardType: TextInputType.emailAddress,
                      textColor: AppColor.midGray,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!GetUtils.isEmail(value)) {
                          return 'Invalid email format';
                        }
                        return null;
                      },
                    ),
                    const Gap(20),

                    // Phone Field
                    CustomTextField(
                      controller: controller.phoneController,
                      borderColor: Colors.transparent,
                      hintText: 'Phone',
                      hintStyle: const TextStyle(color: AppColor.midGray),
                      keyboardType: TextInputType.phone,
                      textColor: AppColor.midGray,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        if (!GetUtils.isPhoneNumber(value)) {
                          return 'Invalid phone number';
                        }
                        return null;
                      },
                    ),
                    const Gap(20),

                    // Address Field
                    CustomTextField(
                      controller: controller.addressController,
                      borderColor: Colors.transparent,
                      hintText: 'Address (auto-location/manual)',
                      hintStyle: const TextStyle(color: AppColor.midGray),
                      keyboardType: TextInputType.streetAddress,
                      textColor: AppColor.midGray,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                    ),
                    const Gap(20),

                    // Tradesperson-specific fields
                    if (widget.isTradesperson) ...[
                      // Title Field
                      CustomTextField(
                        controller: controller.titleController,
                        borderColor: Colors.transparent,
                        hintText: 'Professional Title (e.g., Plumber)',
                        hintStyle: const TextStyle(color: AppColor.midGray),
                        keyboardType: TextInputType.text,
                        textColor: AppColor.midGray,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your professional title';
                          }
                          return null;
                        },
                      ),
                      const Gap(20),

                      // Bio Field
                      CustomTextField(
                        controller: controller.bioController,
                        borderColor: Colors.transparent,
                        hintText: 'Bio (Describe your services)',
                        hintStyle: const TextStyle(color: AppColor.midGray),
                        keyboardType: TextInputType.multiline,
                        maxLines: 4,
                        textColor: AppColor.midGray,
                      ),
                      const Gap(20),

                      // Working Hours Selection
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: CustomButton(
                                text:
                                    controller.startTime.value == null
                                        ? 'Select Start Time'
                                        : controller.startTime.value!.format(
                                          context,
                                        ),
                                onTap:
                                    () => controller.selectStartTime(context),
                                color: Colors.white,
                                textColor: AppColor.midGray,
                                borderColor:
                                    controller.startTime.value == null
                                        ? Colors.red
                                        : AppColor.midGray,
                                radius: 10,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: CustomButton(
                                text:
                                    controller.endTime.value == null
                                        ? 'Select End Time'
                                        : controller.endTime.value!.format(
                                          context,
                                        ),
                                onTap: () => controller.selectEndTime(context),
                                color: Colors.white,
                                textColor: AppColor.midGray,
                                borderColor:
                                    controller.endTime.value == null
                                        ? Colors.red
                                        : AppColor.midGray,
                                radius: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(20),
                    ],

                    // Password Field
                    CustomTextField(
                      hintStyle: const TextStyle(color: AppColor.midGray),

                      controller: controller.passwordController,
                      borderColor: Colors.transparent,
                      textColor: AppColor.midGray,
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

                    // Sign Up Button
                    Obx(
                      () => CustomButton(
                        text: 'Sign Up',
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            if (widget.isTradesperson &&
                                (controller.startTime.value == null ||
                                    controller.endTime.value == null)) {
                              Get.snackbar(
                                'Error',
                                'Please select your working hours',
                              );
                              return;
                            }
                            print('Submitting signup form');
                            controller.signup(
                              name: controller.nameController.text,
                              email: controller.emailController.text,
                              phone: controller.phoneController.text,
                              address: controller.addressController.text,
                              password: controller.passwordController.text,
                              bio:
                                  widget.isTradesperson
                                      ? controller.bioController.text
                                      : null,
                              title:
                                  widget.isTradesperson
                                      ? controller.titleController.text
                                      : null,
                            );
                          } else {
                            print('Form validation failed');
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
                          width: 50,
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
                          width: 50,
                          child: Divider(color: AppColor.midGray, thickness: 1),
                        ),
                      ],
                    ),
                    const Gap(20),

                    // Social Sign-in Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 140,
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
                        const Gap(20),
                        SizedBox(
                          width: 140,
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
                    const Gap(20),

                    // Terms and Policies
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
