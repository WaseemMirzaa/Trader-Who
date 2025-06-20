part of 'pages.dart';

class JobPage extends StatefulWidget {
  final String selectedCategory;

  const JobPage({super.key, required this.selectedCategory});

  @override
  State<JobPage> createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();

  String? _selectedJobType;
  String? _selectedSubCategory;

  final List<Map<String, String>> _jobTypes = [
    {'value': 'small', 'label': 'Instant Book-Fixed Price'},
    {'value': 'large', 'label': 'Custom QuoteFlexible Price'},
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _budgetController.dispose();
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
    final subCategories =
        CategoryData.subCategories[widget.selectedCategory] ?? [];

    return TraderWhoScaffold(
      appBar: const JobAppBar(),
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
                        text: 'How to post your job:',
                        fontSize: screenWidth > 600 ? 18 : 16,
                        fontWeight: FontWeight.w700,
                        color: AppColor.primaryText,
                      ),
                      const Gap(8),
                      _buildBulletPoint(
                        'Choose from pre-listed quick jobs with fixed prices (like "replace a tap")',
                      ),
                      _buildBulletPoint(
                        'Or describe your job in your own words',
                      ),
                      _buildBulletPoint(
                        'We\'ll match you with trusted local traders',
                      ),
                      _buildBulletPoint(
                        'Traders can offer instant booking or send quotes',
                      ),
                      _buildBulletPoint(
                        'Upload photos to help traders quote faster',
                      ),
                      const Gap(16),
                    ],
                  ),

                  // Job Type Selection
                  CustomText(
                    text: 'Job Type',
                    fontSize: screenWidth > 600 ? 18 : 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  const Gap(10),
                  CustomDropdown<String>(
                    value: _selectedJobType,
                    hintText: 'Select job type',
                    fieldHeading: null,
                    items:
                        _jobTypes.map((jobType) {
                          return DropdownMenuItem<String>(
                            value: jobType['value'],
                            child: Text(jobType['label']!),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedJobType = newValue;
                        _selectedSubCategory = null;
                        if (newValue == 'large') {
                          _titleController.clear();
                          _descriptionController.clear();
                        }
                      });
                    },
                    fillColor: AppColor.white,
                    borderRadius: 10,
                  ),
                  const Gap(20),

                  // Selected Category
                  CustomText(
                    text: 'Selected Category',
                    fontSize: screenWidth > 600 ? 18 : 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  const Gap(10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: AppColor.primaryButton),
                        const SizedBox(width: 8),
                        Text(
                          widget.selectedCategory,
                          style: TextStyle(
                            color: AppColor.secondaryText,
                            fontFamily: 'openSans',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(20),

                  // Conditional Sections Based on Job Type
                  if (_selectedJobType == 'small' &&
                      subCategories.isNotEmpty) ...[
                    // Quick Job Selection for Fixed Price
                    CustomText(
                      text: 'Quick Job Selection',
                      fontSize: screenWidth > 600 ? 18 : 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    const Gap(10),
                    Text(
                      'Select from common jobs with fixed prices (optional)',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColor.secondaryText,
                      ),
                    ),
                    const Gap(15),

                    // Subcategories List
                    ...subCategories.map((subCat) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedSubCategory = subCat['name'];
                              _titleController.text =
                                  '${widget.selectedCategory} - ${subCat['name']}';
                              _descriptionController.text =
                                  'I need a ${subCat['name']} service. Estimated price: ${subCat['price']}';
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color:
                                  _selectedSubCategory == subCat['name']
                                      ? AppColor.primaryButton.withOpacity(0.1)
                                      : AppColor.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.white,
                                width: 1.0,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    subCat['name'],
                                    style: TextStyle(
                                      fontFamily: 'openSans',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          _selectedSubCategory == subCat['name']
                                              ? AppColor.primaryButton
                                              : Colors.black,
                                    ),
                                  ),
                                ),
                                Text(
                                  subCat['price'],
                                  style: TextStyle(
                                    fontFamily: 'openSans',
                                    fontSize: 15,
                                    color:
                                        _selectedSubCategory == subCat['name']
                                            ? AppColor.primaryButton
                                            : AppColor.primaryButton,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    const Gap(10),
                  ] else if (_selectedJobType == 'large') ...[
                    // Budget Field for Custom Quote
                    CustomText(
                      text: 'Your Budget (Optional)',
                      fontSize: screenWidth > 600 ? 18 : 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    const Gap(10),
                    CustomTextField(
                      controller: _budgetController,
                      height: 45,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 9,
                        horizontal: 14,
                      ),
                      fillColor: AppColor.white,
                      borderColor: AppColor.white,
                      fontStyle: FontStyle.normal,
                      hintText: 'Enter your estimated budget',
                      hintStyle: const TextStyle(
                        color: AppColor.grayHintText,
                        fontSize: 15,
                      ),
                      keyboardType: TextInputType.number,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          '£',
                          style: TextStyle(
                            color: AppColor.secondaryText,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const Gap(20),
                  ],

                  // Location
                  CustomText(
                    text: 'Location',
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
                    controller: _locationController,
                    borderColor: AppColor.white,
                    fontStyle: FontStyle.normal,
                    hintText: 'Auto-fill from GPS or manual entry',
                    hintStyle: const TextStyle(
                      color: AppColor.grayHintText,
                      fontSize: 15,
                    ),
                    keyboardType: TextInputType.streetAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a location';
                      }
                      return null;
                    },
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
                  const Gap(100),

                  // Find TradePeople Button
                  CustomButton(
                    text: 'Find Tradepeople',
                    onTap: () {
                      Get.toNamed(AppRoutes.tradeContainer);
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
      bottomNavigationBar: const CustomNavBar(),
    );
  }
}
