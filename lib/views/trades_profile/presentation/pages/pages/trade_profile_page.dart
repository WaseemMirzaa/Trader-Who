part of 'pages.dart';

class TradeProfilePage extends StatelessWidget {
  final List<Map<String, dynamic>> profileOptions = [
    {
      'title': 'My Account',
      'icon': Assets.svgsProfileIcon,
      'route': AppRoutes.tradeMyaccount,
    },
    {
      'title': 'Reviews',
      'icon': Assets.svgsTradeReview,
      'route': AppRoutes.tradeCustomerFeedback,
    },
    {
      'title': 'Notifications',
      'icon': Assets.svgsNotification,
      'route': AppRoutes.notificationPage,
    },
    {
      'title': 'Change Password',
      'icon': Assets.svgsPassword,
      // 'route': AppRoutes.transactionHistory,
    },
  ];

  TradeProfilePage({super.key});
  void _handleOptionTap(BuildContext context, Map<String, dynamic> option) {
    final String? route = option['route'];
    if (route != null) {
      Navigator.pushNamed(context, route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: const TradeProfileAppbar(),
      body: Column(
        children: [
          Expanded(
            // Takes remaining space
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: profileOptions.length,
                    itemBuilder: (context, index) {
                      final option = profileOptions[index];
                      return ProfileCard(
                        title: option['title'],
                        svgAsset: option['icon'],
                        onTap: () => _handleOptionTap(context, option),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // Logout button at the bottom
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomButton(
              text: 'Log Out',
              onTap: () async {
                try {
                  // Get the TradeProfileController
                  final profileController = Get.find<TradeProfileController>();

                  // Use the controller's logout method
                  await profileController.logout();

                  // No need for additional navigation, the controller handles it
                } catch (e) {
                  debugPrint('Error during logout: $e');
                  // Fallback if controller not found or error occurs
                  await FirebaseAuth.instance.signOut();
                  Get.offAllNamed(AppRoutes.onboarding);
                }
              },
              color: AppColor.darkBlue,
              textColor: Colors.white,
              enableIcon: true,
              icon: SvgPicture.asset(
                Assets.svgsDoorExit,
                width: 20,
                height: 20,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
