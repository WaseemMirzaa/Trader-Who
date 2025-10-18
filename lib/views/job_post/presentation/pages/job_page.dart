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

  late final JobPostController _jobController;
  final NewServiceController _serviceController = Get.find();

  String? _selectedJobType;
  JobModel? _selectedService;

  String? _categoryId;
  String? _categoryName;

  Future<List<MapEntry<JobModel, (double?, double?)>>>? _jobsWithPricesFuture;

  final List<Map<String, String>> _jobTypes = [
    {'value': 'smallJob', 'label': 'Instant Book-Fixed Price'},
    {'value': 'largeJob', 'label': 'Custom Quote-Flexible Price'},
  ];

  @override
  void initState() {
    super.initState();
    _jobController = Get.put(JobPostController());

    // Get the arguments to extract both categoryId and categoryName
    final args = Get.arguments;
    if (args is Map) {
      _categoryId = args['categoryId'];
      _categoryName = args['categoryName'];
    }

    // If we have categoryId, use it directly
    if (_categoryId != null) {
      print('🔍 JobPage: Using categoryId: $_categoryId, name: $_categoryName');
      _serviceController.selectCategory(_categoryId!);
    } else {
      // Fallback: try to find by name or use the value directly
      print(
        '🔍 JobPage: No categoryId, searching by name: ${widget.selectedCategory}',
      );
      final category = _serviceController.categories.firstWhereOrNull(
        (c) => c.name == widget.selectedCategory,
      );

      if (category != null) {
        _categoryId = category.id;
        _categoryName = category.name;
        print(
          '🔍 JobPage: Found category - ID: $_categoryId, Name: $_categoryName',
        );
        _serviceController.selectCategory(category.id);
      } else {
        // Last resort: treat selectedCategory as ID
        print(
          '⚠️ JobPage: Category not found, using as ID: ${widget.selectedCategory}',
        );
        _categoryId = widget.selectedCategory;
        _categoryName = widget.selectedCategory;
        _serviceController.selectCategory(widget.selectedCategory);
      }
    }

    print(
      '📋 JobPage: Selected category services: ${_serviceController.selectedCategoryServices.length}',
    );
  }

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

    return TraderWhoScaffold(
      appBar: const JobAppBar(),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenWidth > 600 ? 400 : screenWidth * 0.96,
              minHeight: screenHeight,
            ),
            child: Obx(() {
              return SingleChildScrollView(
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
                          _selectedService = null;
                          if (newValue == 'largeJob') {
                            _titleController.clear();
                            _descriptionController.clear();
                          }
                          // Load the jobs with prices when job type is selected
                          if (newValue == 'smallJob') {
                            _jobsWithPricesFuture = _loadJobsWithPrices();
                          }
                        });
                        // Load services for the selected job type
                        if (newValue != null) {
                          _jobController.loadServicesForJobType(newValue);
                        }
                      },
                      fillColor: AppColor.white,
                      borderRadius: 10,
                    ),
                    const Gap(20),

                    // Selected Category (Read-only - from home page selection)
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
                          Icon(
                            Icons.check_circle,
                            color: AppColor.primaryButton,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _categoryName ?? widget.selectedCategory,
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

                    // Loading indicator
                    if (_jobController.isLoading.value) ...[
                      const Center(child: CircularProgressIndicator()),
                      const Gap(20),
                    ],

                    // Conditional Sections Based on Job Type
                    if (!_jobController.isLoading.value &&
                        _selectedJobType == 'smallJob') ...[
                      _buildQuickJobSelection(screenWidth, screenHeight),
                    ] else if (_selectedJobType == 'largeJob') ...[
                      _buildLargeJobSelection(screenWidth, screenHeight),
                      _buildBudgetField(screenWidth, screenHeight),
                    ],

                    // Location
                    _buildLocationField(screenWidth, screenHeight),

                    // Job Description
                    _buildDescriptionField(screenWidth, screenHeight),

                    const Gap(10),

                    // Find TradePeople Button
                    CustomButton(
                      text: 'Find Tradepeople',
                      onTap: () {
                        if (_locationController.text.isEmpty) {
                          Get.snackbar('Error', 'Please select a location');
                          return;
                        }

                        // For smallJob, service_id is required
                        if (_selectedJobType == 'smallJob' &&
                            _selectedService?.id == null) {
                          Get.snackbar('Error', 'Please select a service');
                          return;
                        }

                        print('🚀 Navigating to trade container with:');
                        print('  Category ID: $_categoryId');
                        print('  Category Name: $_categoryName');
                        print('  Service ID: ${_selectedService?.id}');
                        print('  Service Title: ${_selectedService?.title}');
                        print('  Job Type: $_selectedJobType');

                        Get.toNamed(
                          AppRoutes.tradeContainer,
                          arguments: {
                            'selectedCategory':
                                _categoryId, // Pass category ID, not name
                            'categoryName':
                                _categoryName, // Also pass name for display
                            'selectedService': _selectedService?.title,
                            'jobType': _selectedJobType,
                            'servicePrice': _selectedService?.price,
                            'service_id': _selectedService?.id ?? '',
                          },
                        );
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
              );
            }),
          ),
        ),
      ),
      bottomNavigationBar: const CustomNavBar(),
    );
  }

  Widget _buildQuickJobSelection(double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          style: TextStyle(fontSize: 14, color: AppColor.secondaryText),
        ),

        const Gap(15),

        // Services List - Using FutureBuilder to load services with prices
        FutureBuilder<List<MapEntry<JobModel, (double?, double?)>>>(
          future: _jobsWithPricesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[300]!, width: 1.0),
                ),
                child: Text(
                  'No services available for this category yet.',
                  style: TextStyle(fontSize: 14, color: AppColor.secondaryText),
                ),
              );
            }

            final jobsWithPrices = snapshot.data!;

            return Column(
              children:
                  jobsWithPrices.map((entry) {
                    final job = entry.key;
                    final (minPrice, maxPrice) = entry.value;
                    final isSelected = _selectedService?.id == job.id;

                    String displayPrice = 'Price on request';
                    if (minPrice != null && maxPrice != null) {
                      if (minPrice == maxPrice) {
                        displayPrice = '£${minPrice.toInt()}';
                      } else {
                        displayPrice =
                            '£${minPrice.toInt()} - £${maxPrice.toInt()}';
                      }
                    } else if (minPrice != null) {
                      displayPrice = 'From £${minPrice.toInt()}';
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedService = job;
                            Get.find<NewServiceController>().selectService(
                              job.id,
                            );
                            _titleController.text =
                                '${_categoryName ?? widget.selectedCategory} - ${job.title}';
                            _descriptionController.text =
                                'I need a ${job.title} service. ${job.description ?? ""} Estimated price: $displayPrice';
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? AppColor.primaryButton.withOpacity(0.1)
                                    : AppColor.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color:
                                  isSelected
                                      ? AppColor.primaryButton
                                      : Colors.grey[300]!,
                              width: 1.0,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      job.title,
                                      style: TextStyle(
                                        fontFamily: 'openSans',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            isSelected
                                                ? AppColor.primaryButton
                                                : Colors.black,
                                      ),
                                    ),
                                    if (job.description != null &&
                                        job.description!.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        job.description!,
                                        style: TextStyle(
                                          fontFamily: 'openSans',
                                          fontSize: 12,
                                          color: AppColor.secondaryText,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                displayPrice,
                                style: TextStyle(
                                  fontFamily: 'openSans',
                                  fontSize: 15,
                                  color: AppColor.primaryButton,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            );
          },
        ),
        const Gap(2),
      ],
    );
  }

  /// Load jobs with their price ranges, filtering out jobs without prices
  Future<List<MapEntry<JobModel, (double?, double?)>>>
  _loadJobsWithPrices() async {
    print('🔍 _loadJobsWithPrices: Starting...');
    print('🔍 Selected job type: $_selectedJobType');
    print('🔍 Selected category ID: $_categoryId');

    // Make sure we're getting jobs for the right type
    final jobs = _serviceController.getJobsForCategory(
      _categoryId ?? '',
      'small', // Force small job type since this is only shown for smallJob
    );

    print('🔍 Found ${jobs.length} jobs for category');

    final jobsWithPrices = <MapEntry<JobModel, (double?, double?)>>[];

    for (final job in jobs) {
      print('🔍 Checking prices for job: ${job.title} (${job.id})');
      final priceRange = await _serviceController.getPriceRange(job.id);
      final (minPrice, maxPrice) = priceRange;

      print('🔍 Price range: min=$minPrice, max=$maxPrice');

      // Only include jobs that have at least a minimum price set
      if (minPrice != null) {
        jobsWithPrices.add(MapEntry(job, priceRange));
        print('✅ Added job with price: ${job.title}');
      } else {
        print('❌ Skipped job without price: ${job.title}');
      }
    }

    print('🔍 Total jobs with prices: ${jobsWithPrices.length}');
    return jobsWithPrices;
  }

  Widget _buildLargeJobSelection(double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Large Job Selection (without prices)
        CustomText(
          text: 'Select Job Type',
          fontSize: screenWidth > 600 ? 18 : 16,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        const Gap(10),
        Text(
          'Select the type of work you need (optional)',
          style: TextStyle(fontSize: 14, color: AppColor.secondaryText),
        ),

        const Gap(15),

        // Large Jobs List - without prices
        Obx(() {
          final jobs = _serviceController.getJobsForCategory(
            _categoryId ?? '',
            'large',
          );

          if (jobs.isEmpty) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[300]!, width: 1.0),
              ),
              child: Text(
                'No jobs available for this category yet.',
                style: TextStyle(fontSize: 14, color: AppColor.secondaryText),
              ),
            );
          }

          return Column(
            children:
                jobs.map((job) {
                  final isSelected = _selectedService?.id == job.id;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedService = job;
                          Get.find<NewServiceController>().selectService(
                            job.id,
                          );
                          _titleController.text =
                              '${_categoryName ?? widget.selectedCategory} - ${job.title}';
                          _descriptionController.text =
                              'I need a ${job.title} service. ${job.description ?? ""}';
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? AppColor.primaryButton.withOpacity(0.1)
                                  : AppColor.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color:
                                isSelected
                                    ? AppColor.primaryButton
                                    : Colors.grey[300]!,
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    job.title,
                                    style: TextStyle(
                                      fontFamily: 'openSans',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          isSelected
                                              ? AppColor.primaryButton
                                              : Colors.black,
                                    ),
                                  ),
                                  if (job.description != null &&
                                      job.description!.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      job.description!,
                                      style: TextStyle(
                                        fontFamily: 'openSans',
                                        fontSize: 12,
                                        color: AppColor.secondaryText,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
          );
        }),
        const Gap(10),
      ],
    );
  }

  Widget _buildBudgetField(double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              style: TextStyle(color: AppColor.secondaryText, fontSize: 16),
            ),
          ),
        ),
        const Gap(20),
      ],
    );
  }

  Widget _buildLocationField(double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          readOnly: true,
          // onTap: () async {
          //   await _jobController.pickLocationFromMap();
          //   if (_jobController.address != null) {
          //     setState(() {
          //       _locationController.text = _jobController.address!;
          //     });
          //   }
          // },
          hintText: 'Auto-fill from GPS',
          hintStyle: const TextStyle(
            color: AppColor.grayHintText,
            fontSize: 15,
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.map, color: AppColor.midGray),
            onPressed: () async {
              await _jobController.pickLocationFromMap();
              if (_jobController.address != null) {
                setState(() {
                  _locationController.text = _jobController.address!;
                });
              }
            },
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
      ],
    );
  }

  Widget _buildDescriptionField(double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        const Gap(20),
      ],
    );
  }
}
