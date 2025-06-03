part of 'pages.dart';

class JobPage extends StatefulWidget {
  const JobPage({super.key});

  @override
  State<JobPage> createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedJobType;

  // Job type options
  final List<Map<String, String>> _jobTypes = [
    {'value': 'small', 'label': 'Book Instantly: Small Fixed-Price Job'},
    {'value': 'large', 'label': 'Request Quote:  Large-Scale Job'},
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GradientScaffold(
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
                  CustomText(
                    text: 'Category Select',
                    fontSize: screenWidth > 600 ? 18 : 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  const Gap(10),

                  // Title Field
                  CustomTextField(
                    fillColor: AppColor.white,
                    controller: _titleController,
                    borderColor: AppColor.white,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 9,
                      horizontal: 14,
                    ),
                    borderRadius: 10,
                    height: 45,
                    hintText: 'Write title',
                    fontStyle: FontStyle.normal,
                    hintStyle: const TextStyle(
                      color: AppColor.grayHintText,
                      fontSize: 15,
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  const Gap(10),

                  // Job Type
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
                      });
                    },
                    fillColor: AppColor.white,
                    borderRadius: 10,
                  ),
                  const Gap(10),

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
                    contentPadding: EdgeInsets.symmetric(
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
                  const Gap(10),

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
                    height: screenHeight * 0.13, // Increased height
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

                    color: AppColor.darkBlue,
                    textColor: AppColor.white,
                    fontWeight: FontWeight.normal,
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
