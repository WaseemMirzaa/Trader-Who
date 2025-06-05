part of 'pages.dart';

class TradeRatePage extends StatefulWidget {
  const TradeRatePage({super.key});

  @override
  State<TradeRatePage> createState() => _TradeRatePageState();
}

class _TradeRatePageState extends State<TradeRatePage> {
  // Flag to check if we came from profile page
  bool isFromProfilePage = false;

  // State for checkboxes
  Map<String, bool> taskToggles = {
    'Change light switch': false,
    'Replace socket': false,
    'Install light fixture': false,
    'Repair light fixture': false,
  };

  // State for prices
  Map<String, TextEditingController> priceControllers = {
    'Change light switch': TextEditingController(),
    'Replace socket': TextEditingController(),
    'Install light fixture': TextEditingController(),
    'Repair light fixture': TextEditingController(),
  };

  // Controller for custom task description
  final TextEditingController customTaskController = TextEditingController();
  // Controller for custom task price
  final TextEditingController customPriceController = TextEditingController();
  // State for custom task checkbox
  bool customTaskToggle = false;

  @override
  void initState() {
    super.initState();
    // Check the previous route to determine if we came from profile
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        isFromProfilePage =
            Get.arguments == true ||
            ModalRoute.of(context)?.settings.arguments == true ||
            Get.previousRoute == AppRoutes.tradeProfile;
      });
    });
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    priceControllers.forEach((_, controller) => controller.dispose());
    customTaskController.dispose();
    customPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: const TradeRatesAppbar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 14.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom text for specifying rates
              const Text(
                'Specify your fixed rates for common small tasks.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColor.black,
                ),
              ),
              const SizedBox(height: 20),
              // List of tasks with checkboxes and price fields
              ...taskToggles.keys.map(
                (task) => Container(
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColor.white, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.lightGray.withValues(alpha: 0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          task,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: AppColor.grayChat,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: context.responsiveWidth(
                              25,
                            ), // Adjust width to be responsive
                            child: CustomTextField(
                              controller: priceControllers[task],
                              enabled: taskToggles[task]!,
                              keyboardType: TextInputType.number,
                              textColor:
                                  taskToggles[task]!
                                      ? AppColor.darkBlueText
                                      : AppColor.mediumGray,
                              hintText: '0.00',

                              hintStyle: TextStyle(color: AppColor.midGray),
                              prefix: const Padding(
                                padding: EdgeInsets.only(
                                  right: 4.0,
                                ), // Small padding to separate £ from text
                                child: Text(
                                  '£',
                                  style: TextStyle(
                                    color:
                                        AppColor
                                            .darkBlueText, // Match enabled/disabled state if needed
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              borderColor:
                                  taskToggles[task]!
                                      ? AppColor.offWhite
                                      : AppColor.veryLightGray,
                              fillColor:
                                  taskToggles[task]!
                                      ? AppColor.offWhite
                                      : AppColor.veryLightGray,
                              borderRadius: 8,
                              height: 36.0,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15, // Reduced and balanced padding
                                vertical: 6,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d{0,2}'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Transform.scale(
                            scale: 0.9,
                            child: Checkbox(
                              value: taskToggles[task],
                              onChanged: (value) {
                                setState(() {
                                  taskToggles[task] = value!;
                                });
                              },
                              activeColor: AppColor.darkBlue,
                              checkColor: AppColor.white,
                              side: BorderSide(color: AppColor.grey),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Custom text for other small job
              const Text(
                'Other Small Job',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColor.darkBlueText,
                ),
              ),
              const SizedBox(height: 16),
              // Custom task description text field using CustomTextField
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    controller: customTaskController,
                    textColor: AppColor.grayChat,
                    hintText: 'Description',
                    hintStyle: TextStyle(color: AppColor.midGray),
                    borderColor: AppColor.offWhite,
                    fillColor: AppColor.offWhite,
                    borderRadius: 8,
                    height: 55.0,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 15,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Price text and input for custom task
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Price',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColor.darkBlueText,
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child: CustomTextField(
                              controller: customPriceController,
                              keyboardType: TextInputType.number,
                              textColor: AppColor.darkBlueText,
                              hintText: '0.00',
                              hintStyle: TextStyle(color: AppColor.midGray),
                              prefix: const Text(
                                '£',
                                style: TextStyle(
                                  color: AppColor.darkBlueText,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              borderColor: AppColor.offWhite,
                              fillColor: AppColor.offWhite,
                              borderRadius: 8,
                              height: 55.0,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 22,
                                vertical: 15,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d{0,2}'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Transform.scale(
                            scale: 0.9,
                            child: Checkbox(
                              value: customTaskToggle,
                              onChanged: (value) {
                                setState(() {
                                  customTaskToggle = value!;
                                });
                              },
                              activeColor: AppColor.darkBlue,
                              checkColor: AppColor.white,
                              side: BorderSide(color: AppColor.grey),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // Save changes button
              Center(
                child: CustomButton(
                  text: 'Save Changes',
                  onTap: () {
                    // Save the changes
                    // Show success message
                    Get.snackbar(
                      'Success',
                      'Rates saved successfully',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: AppColor.lightCyan,
                      colorText: AppColor.darkBlueText,
                    );

                    if (isFromProfilePage) {
                      // If coming from profile, just go back
                      Get.back();
                    } else {
                      // Normal flow - navigate to main page
                      final navController = NavigationController.to;
                      navController.setUserType(true); // Set as tradesperson
                      navController.navigateToMainPage();
                    }
                  },
                  width: double.infinity,
                  color: AppColor.darkBlue,
                  textColor: AppColor.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  radius: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
