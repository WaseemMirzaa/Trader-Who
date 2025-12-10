part of 'pages.dart';

class TradeMyaccountPage extends StatelessWidget {
  const TradeMyaccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TradeMyaccountController controller =
        Get.find<TradeMyaccountController>();
    return TraderouScaffold(
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
                  // Profile Avatar with Edit Icon
                  Stack(
                    children: [
                      Center(
                        child: CustomCircleAvatar(
                          radius: 50,
                          hasBorder: false,
                          child: // In your build method
                              Obx(() {
                            // If new image was picked but not yet uploaded
                            if (controller.profileImage.value != null) {
                              return ClipOval(
                                child: Image.file(
                                  controller.profileImage.value!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              );
                            }
                            // If image URL exists in user data
                            else if (controller.user.value?.image != null) {
                              return ClipOval(
                                child: Image.network(
                                  controller.user.value!.image!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (
                                    context,
                                    child,
                                    loadingProgress,
                                  ) {
                                    if (loadingProgress == null) return child;
                                    return CircularProgressIndicator();
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.error);
                                  },
                                ),
                              );
                            }
                            // Default avatar
                            else {
                              return Image.asset(
                                Assets.imagesTradeProfile,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              );
                            }
                          }),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: MediaQuery.of(context).size.width / 2 - 70,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColor.darkBlue,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () => controller.pickProfileImage(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Rest of your text fields...
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
                  // TextFieldCustom(
                  //   prefixLabel: 'Last Name',
                  //   controller: controller.lastNameController,
                  //   fillColor: Colors.white,
                  //   borderColor: AppColor.white,
                  //   textColor: AppColor.primaryText,
                  //   contentPadding: const EdgeInsets.symmetric(
                  //     horizontal: 16,
                  //     vertical: 12,
                  //   ),
                  // ),
                  // const SizedBox(height: 10),

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
                  // const SizedBox(height: 10),

                  // Professional Category Dropdown (matching TextFieldCustom style)
                  Obx(
                    () => Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (controller.isLoadingCategories.value)
                            const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          else
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Expanded(
                                    child: Text(
                                      'Professional Title',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: AppColor.mediumGray,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    HelperService.formattedCategoryName(
                                      controller.titleController.text,
                                    ),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  // Expanded(
                                  //   child: DropdownButtonHideUnderline(
                                  //     child: DropdownButton<CategoryModel>(
                                  //       isExpanded: true,
                                  //       alignment:
                                  //           AlignmentDirectional.centerEnd,
                                  //       isDense: false,
                                  //       hint: const Text(
                                  //         'Select Category',
                                  //         style: TextStyle(
                                  //           color: AppColor.midGray,
                                  //           fontSize: 14,
                                  //         ),
                                  //         maxLines: null,
                                  //         softWrap: true,
                                  //       ),
                                  //       value:
                                  //           controller.selectedCategory.value,
                                  //       icon: const Icon(
                                  //         Icons.keyboard_arrow_down,
                                  //         color: AppColor.midGray,
                                  //       ),
                                  //       style: const TextStyle(
                                  //         color: AppColor.black,
                                  //         fontSize: 14,
                                  //       ),
                                  //       selectedItemBuilder: (
                                  //         BuildContext context,
                                  //       ) {
                                  //         return controller.categories.map((
                                  //           category,
                                  //         ) {
                                  //           return Align(
                                  //             alignment: Alignment.centerRight,
                                  //             child: Text(
                                  //               category.name,
                                  //               style: const TextStyle(
                                  //                 color: AppColor.black,
                                  //                 fontSize: 14,
                                  //               ),
                                  //               maxLines: null,
                                  //               softWrap: true,
                                  //               textAlign: TextAlign.right,
                                  //             ),
                                  //           );
                                  //         }).toList();
                                  //       },
                                  //       items:
                                  //           controller.categories.map((
                                  //             category,
                                  //           ) {
                                  //             return DropdownMenuItem<
                                  //               CategoryModel
                                  //             >(
                                  //               value: category,
                                  //               child: Text(
                                  //                 category.name,
                                  //                 maxLines: null,
                                  //                 softWrap: true,
                                  //               ),
                                  //             );
                                  //           }).toList(),
                                  //       onChanged: (CategoryModel? newValue) {
                                  //         controller.selectedCategory.value =
                                  //             newValue;
                                  //       },
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Bio Field
                  TextFieldCustom(
                    prefixLabel: 'Bio',
                    controller: controller.bioController,
                    textColor: AppColor.primaryText,
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
