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

    return TraderWhoScaffold(
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
                          fontWeight: FontWeight.w600,
                          color: AppColor.primaryText,
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
                      textColor: AppColor.primaryText,
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
                      textColor: AppColor.primaryText,
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
                      textColor: AppColor.primaryText,
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
                      textColor: AppColor.primaryText,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.map, color: AppColor.midGray),
                        onPressed: () => controller.pickLocationFromMap(),
                      ),
                    ),
                    const Gap(20),

                    // CustomTextField(
                    //   controller: controller.latitudeController,
                    //   borderColor: Colors.transparent,
                    //   hintText: 'Latitude',
                    //   hintStyle: const TextStyle(color: AppColor.midGray),
                    //   keyboardType: TextInputType.number,
                    //   textColor: AppColor.midGray,
                    //   validator: (value) {
                    //     if (value == null || value.isEmpty) {
                    //       return 'Please enter your latitude';
                    //     }
                    //     return null;
                    //   },
                    // ),
                    // const Gap(20),

                    // CustomTextField(
                    //   controller: controller.longitudeController,
                    //   borderColor: Colors.transparent,
                    //   hintText: 'Longitude',
                    //   hintStyle: const TextStyle(color: AppColor.midGray),
                    //   keyboardType: TextInputType.number,
                    //   textColor: AppColor.midGray,
                    //   validator: (value) {
                    //     if (value == null || value.isEmpty) {
                    //       return 'Please enter your longitude';
                    //     }
                    //     return null;
                    //   },
                    // ),

                    // const Gap(20),

                    // Tradesperson-specific fields
                    if (widget.isTradesperson) ...[
                      // Professional Category Dropdown
                      Obx(
                        () => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child:
                              controller.isLoadingCategories.value
                                  ? const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                  : DropdownButtonHideUnderline(
                                    child: DropdownButton<CategoryModel>(
                                      isExpanded: true,
                                      hint: const Text(
                                        'Select Professional Category',
                                        style: TextStyle(
                                          color: AppColor.midGray,
                                          fontStyle: FontStyle.italic,
                                          fontSize: 16,
                                        ),
                                      ),
                                      value: controller.selectedCategory.value,
                                      items:
                                          controller.categories.map((category) {
                                            return DropdownMenuItem<
                                              CategoryModel
                                            >(
                                              value: category,
                                              child: Text(
                                                category.name,
                                                style: const TextStyle(
                                                  color: AppColor.primaryText,
                                                  fontStyle: FontStyle.italic,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                      onChanged: (CategoryModel? newValue) {
                                        controller.selectedCategory.value =
                                            newValue;
                                      },
                                    ),
                                  ),
                        ),
                      ),
                      const Gap(20),

                      // Bio Field
                      CustomTextField(
                        controller: controller.bioController,
                        borderColor: Colors.transparent,
                        hintText:
                            'Bio (This will be your business card that customers see)',
                        hintStyle: const TextStyle(color: AppColor.midGray),
                        keyboardType: TextInputType.multiline,
                        maxLines: 4,
                        textColor: AppColor.primaryText,
                      ),
                      const Gap(20),

                      // Working Hours Selection
                      // Obx(
                      //   () => Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Expanded(
                      //         child: CustomButton(
                      //           text:
                      //               controller.startTime.value == null
                      //                   ? 'Job Start Time'
                      //                   : controller.startTime.value!.format(
                      //                     context,
                      //                   ),
                      //           onTap:
                      //               () => controller.selectStartTime(context),
                      //           color: Colors.white,
                      //           textColor: AppColor.midGray,
                      //           borderColor:
                      //               controller.startTime.value == null
                      //                   ? Colors.red
                      //                   : AppColor.midGray,
                      //           radius: 10,
                      //         ),
                      //       ),
                      //       const SizedBox(width: 10),
                      //       Expanded(
                      //         child: CustomButton(
                      //           text:
                      //               controller.endTime.value == null
                      //                   ? 'Job End Time'
                      //                   : controller.endTime.value!.format(
                      //                     context,
                      //                   ),
                      //           onTap: () => controller.selectEndTime(context),
                      //           color: Colors.white,
                      //           textColor: AppColor.midGray,
                      //           borderColor:
                      //               controller.endTime.value == null
                      //                   ? Colors.red
                      //                   : AppColor.midGray,
                      //           radius: 10,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // const Gap(20),

                      // Credentials/Certificates Upload Section
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColor.midGray.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomText(
                              text: 'Credentials & Qualifications',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColor.midGray,
                            ),
                            const Gap(8),
                            const CustomText(
                              text:
                                  'Upload your certificates, licenses, or qualifications',
                              fontSize: 12,
                              color: AppColor.darkGrayText,
                            ),
                            const Gap(12),

                            // Upload Button
                            CustomButton(
                              text: 'Add Certificate',
                              icon: const Icon(
                                Icons.upload_file,
                                color: AppColor.orangeCustomColor,
                                size: 20,
                              ),
                              enableIcon: true,
                              onTap: () => controller.pickCertificates(),
                              color: Colors.white,
                              textColor: AppColor.orangeCustomColor,
                              borderColor: AppColor.orangeCustomColor,
                              radius: 8,
                              height: 40,
                            ),

                            // Display selected certificates
                            Obx(
                              () =>
                                  controller.certificates.isEmpty
                                      ? const SizedBox.shrink()
                                      : Column(
                                        children: [
                                          const Gap(12),
                                          ...List.generate(
                                            controller.certificates.length,
                                            (index) => Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 8,
                                              ),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 8,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: AppColor
                                                      .orangeCustomColor
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.description,
                                                      color:
                                                          AppColor
                                                              .orangeCustomColor,
                                                      size: 20,
                                                    ),
                                                    const Gap(8),
                                                    Expanded(
                                                      child: CustomText(
                                                        text:
                                                            controller
                                                                .certificates[index]
                                                                .name,
                                                        fontSize: 12,
                                                        color: AppColor.midGray,
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                      ),
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(
                                                        Icons.close,
                                                        color: Colors.red,
                                                        size: 18,
                                                      ),
                                                      onPressed:
                                                          () => controller
                                                              .removeCertificate(
                                                                index,
                                                              ),
                                                      padding: EdgeInsets.zero,
                                                      constraints:
                                                          const BoxConstraints(),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
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
                      textColor: AppColor.primaryText,
                      hintText: 'Password',
                      obscureText: true,
                      showPasswordToggle: true,
                      passwordToggleIconColor: AppColor.midGray,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }

                        return null;
                      },
                    ),
                    const Gap(20),
                    CustomTextField(
                      hintStyle: const TextStyle(color: AppColor.midGray),

                      controller: controller.confirmPasswordController,
                      borderColor: Colors.transparent,
                      textColor: AppColor.primaryText,
                      hintText: 'Confirm Password',
                      obscureText: true,
                      showPasswordToggle: true,
                      passwordToggleIconColor: AppColor.midGray,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != controller.passwordController.text) {
                          return 'Passwords do not match';
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
                            if (widget.isTradesperson) {
                              if (controller.selectedCategory.value == null) {
                                Get.snackbar(
                                  'Error',
                                  'Please select your professional category',
                                );
                                return;
                              }
                              if (controller.startTime.value == null ||
                                  controller.endTime.value == null) {
                                Get.snackbar(
                                  'Error',
                                  'Please select your working hours',
                                );
                                return;
                              }
                            }
                            print('Submitting signup form');
                            controller.signup(
                              name: controller.nameController.text,
                              email: controller.emailController.text,
                              phone: controller.phoneController.text,
                              address: controller.addressController.text,
                              lat:
                                  controller.selectedLat.value, // Pass latitude
                              lon: controller.selectedLon.value,
                              password: controller.passwordController.text,
                              confirmPassword:
                                  controller.confirmPasswordController.text,
                              bio:
                                  widget.isTradesperson
                                      ? controller.bioController.text
                                      : null,
                              title:
                                  null, // No longer used, category is used instead
                            );
                          } else {
                            print('Form validation failed');
                          }
                        },
                        width: double.infinity,
                        color: AppColor.orangeCustomColor,
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
                            onTap: () => controller.signUpWithApple(),
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
                            onTap: () => controller.signUpWithGoogle(),
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
