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
      'title': 'Services',
      'icon': Assets.svgsProvider,
      'route': AppRoutes.tradeServices,
    },
    {
      'title': 'Set Your Rates, Small Jobs Done Right',
      'icon': Assets.svgsPound,
      'route': AppRoutes.tradeRate,
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
              onTap: () {
                Get.offAllNamed(AppRoutes.onboarding);
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
