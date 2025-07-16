part of 'pages.dart';

class TradeProfilePage extends StatefulWidget {
  const TradeProfilePage({super.key});

  @override
  State<TradeProfilePage> createState() => _TradeProfilePageState();
}

class _TradeProfilePageState extends State<TradeProfilePage> {
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
      'title': 'Selected Large Jobs',
      'icon': Assets.svgsProvider,
      'route': AppRoutes.tradeLargeJobServices,
    },
    {
      'title': 'Selected Small Jobs',
      'icon': Assets.svgsPound,
      'route': AppRoutes.tradeRate,
    },
    {
      'title': 'Delete Account',
      'icon': Assets.svgsDeleteAccount,
      'isDelete': true, // Flag for delete option
    },
    {
      'title': 'Change Password',
      'icon': Assets.svgsPassword,
      'route': AppRoutes.changePassword,
    },
  ];

  @override
  void initState() {
    super.initState();
    // Call refreshProfile when the page initializes
    final profileController = Get.find<TradeProfileController>();
    profileController.refreshProfile();
  }

  void _handleOptionTap(
    BuildContext context,
    Map<String, dynamic> option,
  ) async {
    if (option['isLogout'] == true) {
      Get.offAllNamed(AppRoutes.onboarding);
      return;
    }

    if (option['isDelete'] == true) {
      final shouldDelete = await DeleteAccountDialog.show();
      if (shouldDelete == true) {
        final controller = Get.find<TradeProfileController>();
        await controller.deleteAccount();
      }
      return;
    }

    final String? route = option['route'];
    if (route != null) {
      Get.toNamed(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TraderWhoScaffold(
      appBar: const TradeProfileAppbar(),
      body: Column(
        children: [
          Expanded(
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomButton(
              text: 'Log Out',
              onTap: () async {
                try {
                  final profileController = Get.find<TradeProfileController>();
                  await profileController.logout();
                } catch (e) {
                  debugPrint('Error during logout: $e');
                  await FirebaseAuth.instance.signOut();
                  Get.offAllNamed(AppRoutes.onboarding);
                }
              },
              color: AppColor.primaryButton,
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
