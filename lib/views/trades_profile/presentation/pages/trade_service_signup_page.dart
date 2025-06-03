part of 'pages.dart';

class TradeServiceSignupPage extends StatelessWidget {
  const TradeServiceSignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: const TradeServicesSignupAppbar(),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Welcome text
            const Text(
              'Add Your Services',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AppColor.darkBlueText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Subtitle
            const Text(
              'Start building your service portfolio by adding the services you offer to customers.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColor.mediumGray,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 60),

            // Beautiful Add Services Button
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColor.darkBlue,
                    AppColor.darkBlue.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.darkBlue.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    _showAddServiceDialog(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_circle_outline,
                          size: 40,
                          color: AppColor.white,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Add Services',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppColor.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Info text
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColor.lightCyan,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColor.teal.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: AppColor.teal, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'You can add multiple services and set individual prices for each one.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColor.darkBlueText,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddServiceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => CustomDialogs.addService(
            onSave: (newService) {
              if (newService != null) {
                // Handle saving the new service
                // You can add your logic here to save to database or state management
                // Example: serviceController.addService(newService);
              }
              Navigator.pop(context); // Close the dialog
            },
          ),
    );
  }
}
