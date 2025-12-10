part of 'pages.dart';

class TradeShortServicesPage extends StatefulWidget {
  const TradeShortServicesPage({super.key});

  @override
  State<TradeShortServicesPage> createState() => _TradeShortServicesPageState();
}

class _TradeShortServicesPageState extends State<TradeShortServicesPage> {
  // Use a local list to manage services
  List<Service> servicesList = List.from(services);

  // Predefined service options
  final List<String> predefinedServices = [
    "Basic Plumbing Repair",
    "Electrical Installation",
    "Gas Engineering",
    "HVAC Maintenance",
    "Roof Inspection",
    "Appliance Installation",
    "Painting Service",
    "Emergency Repair",
    "Carpentry Work",
    "Flooring Installation",
    "Drywall Repair",
    "Window Installation",
  ];

  // Selected service from dropdown
  String? selectedService;

  @override
  Widget build(BuildContext context) {
    return TraderouScaffold(
      appBar: const TradeServicesAppbar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Add dropdown for selecting predefined services
              Text(
                "Select a Short Service",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColor.black,
                ),
              ),
              const SizedBox(height: 8),
              CustomDropdown<String>(
                value: selectedService,
                hintText: "Select a service to add",
                items:
                    predefinedServices.map((service) {
                      return DropdownMenuItem<String>(
                        value: service,
                        child: Text(service),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedService = value;
                  });
                },
                borderRadius: 12,
                borderColor: AppColor.lightGray,
                fillColor: AppColor.white,
                dropdownIconColor: AppColor.darkGray,
                isExpanded: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              const SizedBox(height: 16),

              // Add button to add the selected service
              CustomButton(
                text: "Add Selected Service",
                onTap: () {
                  if (selectedService != null) {
                    // Add the selected service with a default price
                    setState(() {
                      servicesList.add(
                        Service(
                          title: selectedService!,
                          price: 50.0, // Default price
                        ),
                      );
                      selectedService = null; // Reset selection
                    });

                    // Show success message
                    Get.snackbar(
                      'Success',
                      'Service added successfully',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: AppColor.lightCyan,
                      colorText: AppColor.darkBlueText,
                    );
                  } else {
                    // Show error message if no service is selected
                    Get.snackbar(
                      'Error',
                      'Please select a service',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: AppColor.red,
                      colorText: AppColor.white,
                    );
                  }
                },
                color: AppColor.orangeCustomColor,
                textColor: Colors.white,
                width: double.infinity,
                radius: 12,
              ),

              const SizedBox(height: 24),
              Text(
                "Your Services",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColor.black,
                ),
              ),
              const SizedBox(height: 12),

              // List of added services
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: servicesList.length,
                itemBuilder: (context, index) {
                  final service = servicesList[index];
                  return ServiceCard(
                    service: service,
                    onEdit: (updatedService) {
                      setState(() {
                        servicesList[index] = updatedService;
                      });
                      // Show success message
                      Get.snackbar(
                        'Success',
                        'Service updated successfully',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppColor.lightCyan,
                        colorText: AppColor.darkBlueText,
                      );
                    },
                    onDelete: (service) {
                      setState(() {
                        servicesList.removeAt(index);
                      });
                      // Show success message
                      Get.snackbar(
                        'Success',
                        'Service deleted successfully',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppColor.lightCyan,
                        colorText: AppColor.darkBlueText,
                      );
                    },
                  );
                },
              ),

              // Empty state message when no services
              if (servicesList.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Text(
                      "No services added yet",
                      style: TextStyle(fontSize: 16, color: AppColor.grayChat),
                    ),
                  ),
                ),

              // Continue button at the bottom
              const SizedBox(height: 30),
              CustomButton(
                text: "Continue",
                onTap: () {
                  // Navigate to the main page with navbar (home screen)
                  final navController = NavigationController.to;
                  navController.setUserType(true); // Set as tradesperson
                  navController.navigateToMainPage();
                },
                color: AppColor.darkBlue,
                textColor: Colors.white,
                width: double.infinity,
                radius: 24,
              ),
              const SizedBox(height: 20), // Add some bottom padding
            ],
          ),
        ),
      ),
    );
  }
}

// Sample data
final List<Service> servicesShort = [
  Service(title: "Basic Plumbing Repair", price: 75.00),
  Service(title: "Electrical Installation", price: 120.00),
  Service(title: "Gas Eng", price: 90.00),
  Service(title: "HVAC Maintenance", price: 150.00),
  Service(title: "Roof Inspection", price: 200.00),
  Service(title: "Appliance Installation", price: 85.00),
  Service(title: "Painting Service", price: 60.00),
  Service(title: "Emergency Repair", price: 250.00),
];
