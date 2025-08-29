part of 'pages.dart';

class CustomJobPost extends StatefulWidget {
  const CustomJobPost({super.key});

  @override
  State<CustomJobPost> createState() => _CustomJobPostState();
}

class _CustomJobPostState extends State<CustomJobPost> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(text: '•', fontSize: 16, color: Colors.black),
          const SizedBox(width: 8),
          Expanded(
            child: CustomText(
              text: text,
              maxLines: 3,
              fontSize: 14,
              color: AppColor.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return TraderWhoScaffold(
      appBar: const CustomJobRequestAppbar(),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenWidth > 600 ? 400 : screenWidth * 0.96,
              minHeight: screenHeight,
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // How to post your job instructions
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'How to post your Custom job:',
                        fontSize: screenWidth > 600 ? 18 : 16,
                        fontWeight: FontWeight.w700,
                        color: AppColor.primaryText,
                      ),
                      const Gap(8),
                      _buildBulletPoint(
                        'If you cant found the Tradeperson then you post custom job',
                      ),
                      _buildBulletPoint('Write your Job Title'),
                      _buildBulletPoint('Write your Job Description'),
                      _buildBulletPoint(
                        'Then send quote to Tradeperson then he will accept or reject according to your job',
                      ),
                      _buildBulletPoint(
                        'Upload photos to help traders quote faster',
                      ),
                      const Gap(16),
                    ],
                  ),

                  // Job Type Selection
                  CustomText(
                    text: 'Job Title',
                    fontSize: screenWidth > 600 ? 18 : 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  const Gap(10),
                  CustomTextField(
                    height: 45,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 9,
                      horizontal: 14,
                    ),
                    fillColor: AppColor.white,
                    controller: _titleController,
                    borderColor: AppColor.white,
                    fontStyle: FontStyle.normal,
                    hintText: 'Job Title',
                    hintStyle: const TextStyle(
                      color: AppColor.grayHintText,
                      fontSize: 15,
                    ),
                    keyboardType: TextInputType.streetAddress,
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Please enter a location';
                    //   }
                    //   return null;
                    // },
                  ),
                  const Gap(20),
                  // Job Description
                  CustomText(
                    text: 'Job Description',
                    fontSize: screenWidth > 600 ? 18 : 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  const Gap(10),
                  CustomTextField(
                    fontStyle: FontStyle.normal,
                    fillColor: AppColor.white,
                    controller: _descriptionController,
                    borderColor: AppColor.white,
                    hintText: 'Describe what needs fixing...',
                    hintStyle: const TextStyle(
                      color: AppColor.grayHintText,
                      fontSize: 15,
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    height: screenHeight * 0.13,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.02,
                      horizontal: screenWidth * 0.04,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  Gap(20),
                  CustomText(
                    text: 'Upload Photos',
                    fontSize: screenWidth > 600 ? 18 : 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                  const Gap(5),
                  // Image upload section
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Container(
                      // width: itemWidth * 1.60,
                      // height: itemWidth * 1,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(12),
                        color: AppColor.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              Assets.svgsIconAwesomeImage,
                              // width: itemWidth * 0.36,
                              // height: itemWidth * 0.28,
                            ),
                            const Gap(8),
                            const CustomText(
                              text: 'Tap to Upload',
                              fontSize: 12,
                              color: AppColor.secondaryText,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const Gap(100),

                  // Find TradePeople Button
                  CustomButton(
                    text: 'Submit',
                    onTap: () {
                      Get.toNamed(AppRoutes.mainPageWithNavBar);
                    },
                    width: double.infinity,
                    color: AppColor.primaryButton,
                    textColor: AppColor.white,
                    radius: 25,
                    fontSize: screenWidth > 600 ? 18 : 16,
                  ),
                  const Gap(10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
