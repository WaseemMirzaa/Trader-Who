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
  int _selectedIndex = 0;
  String? _selectedJobType;

  // Job type options
  final List<Map<String, String>> _jobTypes = [
    {'value': 'small', 'label': 'Small Job: Fixed price estimate'},
    {'value': 'large', 'label': 'Large Jobs: Custom Quote Required'},
  ];

  static const List<String> _titles = ['Home', 'Details', 'Chat', 'Profile'];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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

    return Scaffold(
      backgroundColor: AppColor.lightPeach,
      appBar: const JobAppBar(),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenWidth > 600 ? 400 : screenWidth * 0.9,
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
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  const Gap(10),

                  // Title Field
                  CustomTextField(
                    fillColor: AppColor.white,
                    controller: _titleController,
                    hintText: 'Write title',
                    hintStyle: const TextStyle(color: AppColor.midGray),
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
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  const Gap(10),
                  CustomDropdown<String>(
                    value: _selectedJobType,
                    hintText: 'Select job type',
                    fieldHeading: null,
                    items: _jobTypes.map((jobType) {
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
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  const Gap(10),
                  CustomTextField(
                    fillColor: AppColor.white,
                    controller: _locationController,
                   
                    hintText: 'Auto-fill from GPS or manual entry',
                    hintStyle: const TextStyle(color: AppColor.midGray),
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
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  const Gap(10),
                  CustomTextField(
                    fillColor: AppColor.white,
                    controller: _descriptionController,
                    hintText: 'Describe what needs fixing...',
                    hintStyle: const TextStyle(color: AppColor.midGray),
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
                  const Gap(60),

                  // Find TradePeople Button
                  CustomButton(
                    text: 'Find TradePeople',
                    onTap: () {
                      Get.toNamed(AppRoutes.tradesPage); 
                    },
                    width: double.infinity,
                    height: screenHeight * 0.06,
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
      bottomNavigationBar: CustomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}