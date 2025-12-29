part of 'pages.dart';

class CustomJobPost extends StatefulWidget {
  const CustomJobPost({super.key});

  @override
  State<CustomJobPost> createState() => _CustomJobPostState();
}

class _CustomJobPostState extends State<CustomJobPost> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  String? selectedCategory;
  String? selectedService;
  final String selectedJobType = 'customJob'; // Always custom for this page

  // Location variables
  double? latitude;
  double? longitude;
  String? address;

  @override
  void initState() {
    super.initState();
    // Get values from TradesPeopleController
    final tradesController = Get.find<TradesPeopleController>();
    selectedCategory = tradesController.selectedCategory.value;
    selectedService = tradesController.selectedService.value;

    // Get location from JobPostController (selected on job page)
    try {
      final jobController = Get.find<JobPostController>();
      latitude = jobController.selectedLat.value;
      longitude = jobController.selectedLon.value;
      address = jobController.address;
    } catch (e) {
      print(
        'JobPostController not found, location will need to be selected manually',
      );
    }

    // Pre-fill description from service if available
    // You can add more logic here if there's a default description
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
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

  Future<void> _submitCustomJobPost() async {
    // Validate required fields
    if (_titleController.text.trim().isEmpty) {
      Get.snackbar(
        'Missing Information',
        'Please enter a job title',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (_descriptionController.text.trim().isEmpty) {
      Get.snackbar(
        'Missing Information',
        'Please enter a job description',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    // Budget is now optional - no validation needed

    if (selectedCategory == null || selectedService == null) {
      Get.snackbar(
        'Missing Information',
        'Please select category and service from the previous page',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (latitude == null ||
        longitude == null ||
        latitude == 0.0 ||
        longitude == 0.0) {
      Get.snackbar(
        'Location Required',
        'Please go back and select a location on the job page',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    // Use the same booking dialog as regular bookings for consistency
    final bookingController = Get.put(BookingController());

    // Show the booking dialog with empty traderId for custom jobs
    await bookingController.showBookingDialog(
      traderName: 'All Available Traders',
      traderId: '', // Empty for custom jobs - any trader can quote
      category: selectedCategory!,
      service: selectedService!,
      jobType: selectedJobType,
      price: double.tryParse(_priceController.text) ?? 0.0,
    );

    // The booking dialog handles the complete booking flow
    // including date/time selection, notes, and image uploads
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return TraderouScaffold(
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
                  Text(
                    "Custom Job Summary",
                    style: TextStyle(
                      fontSize: screenWidth > 600 ? 22 : 20,
                      fontWeight: FontWeight.w700,
                      color: AppColor.primaryText,
                    ),
                  ),
                  const Gap(16),
                  // Selected Category and Service Display
                  if (selectedCategory != null && selectedService != null)
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: AppColor.primaryButton.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColor.primaryButton.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: const Text(
                                  'Custom Job Request',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Get.dialog(
                                    AlertDialog(
                                      title: Text(
                                        "What is a Custom Job?",
                                        style: TextStyle(
                                          fontFamily: 'openSans',
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      content: Text(
                                        "Post your job to get quotes from tradespeople. Add a clear description, budget (optional), preferred date and time and images. You’ll be notified as the quotes come in and you can use the in-app chat or video call feature with the tradesperson before accepting a quote.",
                                        style: TextStyle(
                                          fontFamily: 'openSans',
                                          fontSize: 16,
                                          color: AppColor.primaryText,
                                        ),
                                      ),
                                      actions: [
                                        CustomButton(
                                          text: 'Okay',
                                          onTap: () {
                                            Get.back();
                                          },
                                          height: 45,
                                          width: 100,
                                          color: AppColor.primaryButton,
                                          textColor: AppColor.white,
                                          radius: 20,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                icon: Icon(Icons.info_outline),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Text(
                                'Category: ',
                                style: TextStyle(
                                  color: AppColor.secondaryText,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                HelperService.formattedCategoryName(
                                  selectedCategory!,
                                ),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Service: ',
                                style: TextStyle(
                                  color: AppColor.secondaryText,
                                  fontSize: 14,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  selectedService!,
                                  maxLines: 2,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'All traders will be able to view this job and send you quotes.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColor.secondaryText,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          // Location info
                          if (latitude != null &&
                              longitude != null &&
                              latitude != 0.0 &&
                              longitude != 0.0) ...[
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    address ?? 'Location selected',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColor.primaryText,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),

                  // How to post your job instructions
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     CustomText(
                  //       text: 'How to post your Custom job:',
                  //       fontSize: screenWidth > 600 ? 18 : 16,
                  //       fontWeight: FontWeight.w700,
                  //       color: AppColor.primaryText,
                  //     ),
                  //     const Gap(8),
                  //     _buildBulletPoint(
                  //       'If you cant found the Tradeperson then you post custom job',
                  //     ),
                  //     _buildBulletPoint('Write your Job Title'),
                  //     _buildBulletPoint('Write your Job Description'),
                  //     _buildBulletPoint(
                  //       'Then send quote to Tradeperson then he will accept or reject according to your job',
                  //     ),
                  //     _buildBulletPoint(
                  //       'Upload photos to help traders quote faster',
                  //     ),
                  //     const Gap(16),
                  //   ],
                  // ),

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
                    hintText: 'Enter job title',
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
                    hintText: 'Describe what needs doing...',
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
                  const Gap(20),

                  // Budget field (optional)
                  Row(
                    children: [
                      CustomText(
                        text: 'Budget',
                        fontSize: screenWidth > 600 ? 18 : 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 8),
                      CustomText(
                        text: '(Optional)',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColor.secondaryText,
                      ),
                    ],
                  ),
                  const Gap(10),
                  CustomTextField(
                    height: 45,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 9,
                      horizontal: 14,
                    ),
                    fillColor: AppColor.white,
                    controller: _priceController,
                    borderColor: AppColor.white,
                    fontStyle: FontStyle.normal,
                    hintText: 'Enter your budget (traders will send quotes)',
                    hintStyle: const TextStyle(
                      color: AppColor.grayHintText,
                      fontSize: 15,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  Gap(20),
                  CustomText(
                    text: 'Attach up to 8 Images ',
                    fontSize: screenWidth > 600 ? 18 : 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                  const Gap(5),
                  // Image upload section
                  Obx(() {
                    final controller = Get.put(CustomJobPostController());
                    return Column(
                      children: [
                        if (controller.selectedImages.isNotEmpty) ...[
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: List.generate(
                              controller.selectedImages.length,
                              (index) => Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      File(
                                        controller.selectedImages[index].path,
                                      ),
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: GestureDetector(
                                      onTap:
                                          () => controller.removeImage(index),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Gap(10),
                        ],
                        GestureDetector(
                          onTap: () => controller.selectImages(),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Container(
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
                                    ),
                                    const Gap(8),
                                    CustomText(
                                      text:
                                          controller.selectedImages.isEmpty
                                              ? 'Tap to Upload'
                                              : 'Tap to Add More',
                                      fontSize: 12,
                                      color: AppColor.secondaryText,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),

                  const Gap(100),

                  // Find TradePeople Button
                  Obx(() {
                    final controller = Get.put(CustomJobPostController());
                    return CustomButton(
                      text:
                          controller.isCreatingPost.value
                              ? 'Submitting...'
                              : 'Submit Job Request',
                      onTap:
                          controller.isCreatingPost.value
                              ? null
                              : _submitCustomJobPost,
                      width: double.infinity,
                      color: AppColor.primaryButton,
                      textColor: AppColor.white,
                      radius: 25,
                      fontSize: screenWidth > 600 ? 18 : 16,
                    );
                  }),
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
