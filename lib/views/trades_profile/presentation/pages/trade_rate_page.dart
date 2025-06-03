part of 'pages.dart';

class TradeRatePage extends StatefulWidget {
  const TradeRatePage({super.key});

  @override
  State<TradeRatePage> createState() => _TradeRatePageState();
}

class _TradeRatePageState extends State<TradeRatePage> {
  // State for toggle switches
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom text for specifying rates
              const Text(
                'Specify your fixed rates for common small tasks.',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: AppColor.mediumGray,
                ),
              ),
              const SizedBox(height: 20),
              // List of tasks with toggle switches and price fields
              ...taskToggles.keys.map(
                (task) => Container(
                  margin: const EdgeInsets.symmetric(vertical: 6.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColor.lightGray, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.lightGray.withValues(alpha: 0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Toggle switch with app theme colors
                      Switch(
                        value: taskToggles[task]!,
                        onChanged: (value) {
                          setState(() {
                            taskToggles[task] = value;
                          });
                        },
                        activeColor: AppColor.white,
                        activeTrackColor: AppColor.darkBlue,
                        inactiveThumbColor: AppColor.white,
                        inactiveTrackColor: AppColor.lightGray,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      const SizedBox(width: 12),
                      // Task name
                      Expanded(
                        child: Text(
                          task,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColor.darkBlueText,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Price input field using CustomTextField
                      CustomTextField(
                        controller: priceControllers[task],
                        enabled: taskToggles[task]!,
                        keyboardType: TextInputType.number,
                        textColor:
                            taskToggles[task]!
                                ? AppColor.darkBlueText
                                : AppColor.mediumGray,
                        hintText: '0.00',
                        hintStyle: TextStyle(color: AppColor.midGray),
                        prefix: Text(
                          '£',
                          style: TextStyle(
                            color:
                                taskToggles[task]!
                                    ? AppColor.darkBlueText
                                    : AppColor.mediumGray,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        borderColor:
                            taskToggles[task]!
                                ? AppColor.darkBlue
                                : AppColor.lightGray,
                        fillColor:
                            taskToggles[task]!
                                ? AppColor.offWhite
                                : AppColor.veryLightGray,
                        borderRadius: 8,
                        width: 100,
                        height: 55.0,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 15,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d{0,2}'),
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
                'Other small job',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColor.darkBlueText,
                ),
              ),
              const SizedBox(height: 16),
              // Custom task description text field using CustomTextField
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColor.lightGray, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.lightGray.withValues(alpha: 0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      controller: customTaskController,
                      textColor: AppColor.darkBlueText,
                      hintText: 'Description',
                      hintStyle: TextStyle(color: AppColor.midGray),
                      borderColor: AppColor.darkBlue,
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Price',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColor.darkBlueText,
                          ),
                        ),
                        CustomTextField(
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
                          borderColor: AppColor.darkBlue,
                          fillColor: AppColor.offWhite,
                          borderRadius: 8,
                          width: 100,
                          height: 55.0,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 15,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d{0,2}'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Save changes button
              Center(
                child: CustomButton(
                  text: 'Save Changes',
                  onTap: () {
                    // TODO: Implement save functionality
                  },
                  width: double.infinity,
                  color: AppColor.darkBlue,
                  textColor: AppColor.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  radius: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
