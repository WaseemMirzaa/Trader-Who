part of 'pages.dart';

class TradeMyaccountPage extends StatelessWidget {
  const TradeMyaccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TradeMyaccountController controller =
        Get.find<TradeMyaccountController>();
    return GradientScaffold(
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

                // Shimmer for all text fields (7 fields: first name, last name, email, phone, address, title, bio)
                for (int i = 0; i < 7; i++) ...[
                  CustomShimmer(
                    isActive: true,
                    child: Container(
                      height: i == 6 ? 80 : 40, // Bio field is taller
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
                        image: AssetImage(Assets.imagesTradeProfile),
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
                    textColor: AppColor.black,
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
                    textColor: AppColor.black,
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
                    textColor: AppColor.black,
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
                    textColor: AppColor.black,
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
                    textColor: AppColor.black,
                    fillColor: Colors.white,
                    borderColor: AppColor.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    maxLines: 1,
                  ),
                  const SizedBox(height: 10),

                  // Title Field
                  TextFieldCustom(
                    prefixLabel: 'Professional Title',
                    controller: controller.titleController,
                    textColor: AppColor.black,
                    fillColor: Colors.white,
                    borderColor: AppColor.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Bio Field
                  TextFieldCustom(
                    prefixLabel: 'Bio',
                    controller: controller.bioController,
                    textColor: AppColor.black,
                    fillColor: Colors.white,
                    borderColor: AppColor.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    maxLines: 4,
                  ),
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
