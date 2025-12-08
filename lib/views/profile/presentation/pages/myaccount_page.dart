part of 'pages.dart';

class MyAccountPage extends StatelessWidget {
  const MyAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final MyaccountController controller = Get.find<MyaccountController>();

    return TraderWhoScaffold(
      appBar: const MyAccountAppBar(),
      body: Obx(() {
        // Full page shimmer when loading
        if (controller.showShimmer.value) {
          return SingleChildScrollView(
            padding: kHV20,
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                // Shimmer for avatar
                CustomShimmer(
                  isActive: true,
                  child: Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColor.lightGray,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Shimmer for all text fields (5 fields: first name, last name, email, phone, address, username)
                for (int i = 0; i < 6; i++) ...[
                  CustomShimmer(
                    isActive: true,
                    child: Container(
                      height: 40,
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],

                // Shimmer for button
                const SizedBox(height: 20),
                CustomShimmer(
                  isActive: true,
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // Actual content when not loading
        return Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: 100, // Add bottom padding to avoid button overlap
              ),
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  // Profile Avatar
                  Center(
                    child: CustomCircleAvatar(
                      radius: 50,
                      hasBorder: false,
                      child: Image(
                        image: AssetImage(Assets.imagesCircularAvatar),
                        width: context.width,
                        height: context.height,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // First Name Field
                  TextFieldCustom(
                    prefixLabel: 'First Name',
                    controller: controller.firstNameController,
                    textColor: AppColor.primaryText,
                    fillColor: Colors.white,
                    borderColor: AppColor.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Last Name Field
                  TextFieldCustom(
                    prefixLabel: 'Last Name',
                    controller: controller.lastNameController,
                    fillColor: Colors.white,
                    borderColor: AppColor.white,
                    textColor: AppColor.primaryText,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Email Field
                  TextFieldCustom(
                    prefixLabel: 'Email',
                    controller: controller.emailController,
                    textColor: AppColor.primaryText,
                    fillColor: Colors.white,
                    borderColor: AppColor.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 10),

                  // Phone Field
                  TextFieldCustom(
                    prefixLabel: 'Phone',
                    controller: controller.phoneController,
                    textColor: AppColor.primaryText,
                    fillColor: Colors.white,
                    borderColor: AppColor.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 10),

                  // Address Field
                  TextFieldCustom(
                    prefixLabel: 'Address',
                    controller: controller.addressController,
                    textColor: AppColor.primaryText,
                    fillColor: Colors.white,
                    borderColor: AppColor.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    maxLines: 1,
                  ),
                  const SizedBox(height: 10),

                  // Username Field (only for customers)
                  if (controller.isCustomer) ...[
                    TextFieldCustom(
                      prefixLabel: 'Username',
                      controller: controller.usernameController,
                      textColor: AppColor.primaryText,
                      fillColor: Colors.white,
                      borderColor: AppColor.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                  const SizedBox(height: 80), // Extra space for the button
                ],
              ),
            ),

            // Positioned button at the bottom
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: CustomButton(
                height: 55,
                text: 'Update Profile',
                onTap: () => controller.updateProfile(),
                color: AppColor.darkBlue,
                textColor: Colors.white,
              ),
            ),
          ],
        );
      }),
    );
  }
}
