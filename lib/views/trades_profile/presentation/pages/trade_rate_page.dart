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
                (task) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      // Toggle switch
                      Switch(
                        value: taskToggles[task]!,
                        onChanged: (value) {
                          setState(() {
                            taskToggles[task] = value;
                          });
                        },
                        activeColor: AppColor.darkBlue,
                        inactiveThumbColor: Colors.black,
                        inactiveTrackColor: Colors.grey.shade300,
                      ),
                      // Task name
                      Expanded(
                        child: Text(
                          task,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColor.black,
                          ),
                        ),
                      ),
                      // Price input field using CustomTextField
                      CustomTextField(
                        controller: priceControllers[task],
                        enabled: taskToggles[task]!,
                        keyboardType: TextInputType.number,
                        textColor: Colors.black,
                        hintText: '0.00',
                        hintStyle: TextStyle(color: AppColor.midGray),
                        prefix: const Text(
                          '£',
                          style: TextStyle(color: Colors.black),
                        ),
                        borderColor: Colors.grey.shade400,
                        fillColor: Colors.transparent, // Transparent fill
                        borderRadius: 8,
                        width: 100, // Match original width
                        height: 55.0, // Match CustomTextField default height
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
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
              const SizedBox(height: 20),
              // Custom text for other small job
              const Text(
                'Other small job',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColor.black,
                ),
              ),
              const SizedBox(height: 10),
              // Custom task description text field using CustomTextField
              CustomTextField(
                controller: customTaskController,
                textColor: Colors.black,
                hintText: 'Description',
                hintStyle: TextStyle(color: AppColor.midGray),
                borderColor: Colors.black,
                fillColor: Colors.transparent, // Transparent fill
                borderRadius: 8,
                height: 55.0, // Match CustomTextField default height
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 15,
                ),
              ),
              const SizedBox(height: 20), // Replace kGap20
              // Price text and input for custom task
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Price',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  CustomTextField(
                    controller: customPriceController,
                    keyboardType: TextInputType.number,
                    textColor: Colors.black,
                    hintText: '0.00',
                    prefix: const Text(
                      '£',
                      style: TextStyle(color: Colors.black),
                    ),
                    borderColor: Colors.grey.shade400,
                    fillColor: Colors.transparent, // Transparent fill
                    borderRadius: 8,
                    width: 100, // Match original width
                    height: 55.0, // Match CustomTextField default height
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
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
              const SizedBox(height: 30),
              // Save changes button
              Center(
                child: CustomButton(
                  text: 'Save Changes',
                  onTap: () {},
                  width: 200,
                  color: AppColor.darkBlue,
                  textColor: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  radius: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
