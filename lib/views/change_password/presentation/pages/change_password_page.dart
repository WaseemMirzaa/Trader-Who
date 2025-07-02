part of 'pages.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final ChangePasswordController controller = Get.put(
    ChangePasswordController(),
  );

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return TraderWhoScaffold(
      appBar: const ChangePasswordAppbar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: screenWidth * 0.04,
            right: screenWidth * 0.04,
            top: screenHeight * 0.02,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: screenWidth > 600 ? 400 : screenWidth * 0.96,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Old Password
                      CustomText(
                        text: 'Old Password',
                        fontSize: screenWidth > 600 ? 18 : 16,
                        fontWeight: FontWeight.w400,
                        color: AppColor.black,
                      ),
                      const Gap(10),
                      Obx(
                        () => CustomTextField(
                          fillColor: AppColor.white,
                          controller: controller.oldPasswordController,
                          borderColor: AppColor.white,
                          textColor: AppColor.midGray,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 9,
                            horizontal: 14,
                          ),
                          borderRadius: 10,
                          height: 45,
                          hintText: 'Enter Old Password',
                          hintStyle: const TextStyle(color: AppColor.midGray),
                          fontStyle: FontStyle.normal,
                          obscureText: controller.obscureOldPassword.value,
                          keyboardType: TextInputType.visiblePassword,
                          showPasswordToggle: true,
                          passwordToggleIconColor: AppColor.midGray,

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your old password';
                            }
                            return null;
                          },
                        ),
                      ),
                      const Gap(20),

                      // New Password
                      CustomText(
                        text: 'New Password',
                        fontSize: screenWidth > 600 ? 18 : 16,
                        fontWeight: FontWeight.w400,
                        color: AppColor.black,
                      ),
                      const Gap(10),
                      Obx(
                        () => CustomTextField(
                          height: 45,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 9,
                            horizontal: 14,
                          ),
                          fillColor: AppColor.white,
                          textColor: AppColor.midGray,
                          controller: controller.newPasswordController,
                          borderColor: AppColor.white,
                          hintStyle: const TextStyle(color: AppColor.midGray),
                          fontStyle: FontStyle.normal,
                          hintText: 'Enter New Password',
                          obscureText: controller.obscureNewPassword.value,
                          keyboardType: TextInputType.visiblePassword,
                          showPasswordToggle: true,
                          passwordToggleIconColor: AppColor.midGray,

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a new password';
                            }
                            if (value.length < 8) {
                              return 'Password must be at least 8 characters long';
                            }
                            if (!RegExp(
                              r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
                            ).hasMatch(value)) {
                              return 'Password must contain at least one letter and one number';
                            }
                            return null;
                          },
                        ),
                      ),
                      const Gap(20),

                      // Confirm Password
                      CustomText(
                        text: 'Confirm Password',
                        fontSize: screenWidth > 600 ? 18 : 16,
                        fontWeight: FontWeight.w400,
                        color: AppColor.black,
                      ),
                      const Gap(10),
                      Obx(
                        () => CustomTextField(
                          height: 45,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 9,
                            horizontal: 14,
                          ),
                          fillColor: AppColor.white,
                          textColor: AppColor.midGray,
                          controller: controller.confirmPasswordController,
                          borderColor: AppColor.white,
                          hintStyle: const TextStyle(color: AppColor.midGray),
                          fontStyle: FontStyle.normal,
                          hintText: 'Confirm New Password',
                          obscureText: controller.obscureConfirmPassword.value,
                          keyboardType: TextInputType.visiblePassword,
                          showPasswordToggle: true,
                          passwordToggleIconColor: AppColor.midGray,

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value !=
                                controller.newPasswordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                      ),
                      const Gap(20),
                    ],
                  ),
                ),
              ),
              // Spacer to push button to the bottom
              SizedBox(height: screenHeight * 0.35),
              // Save Changes Button
              Obx(
                () => Align(
                  alignment: Alignment.center,
                  child: CustomButton(
                    text: 'Save Changes',
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        controller.changePassword(
                          oldPassword: controller.oldPasswordController.text,
                          newPassword: controller.newPasswordController.text,
                          confirmPassword:
                              controller.confirmPasswordController.text,
                        );
                      }
                    },
                    color: AppColor.primaryButton,
                    textColor: Colors.white,
                    fontWeight: FontWeight.w400,
                    radius: 17,
                    width: screenWidth > 600 ? 400 : screenWidth * 0.96,
                    isLoading: controller.isLoading.value,
                    loadingColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
