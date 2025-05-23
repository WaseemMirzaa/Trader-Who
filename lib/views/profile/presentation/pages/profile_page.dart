part of 'pages.dart';

class ProfileScreen extends StatelessWidget {
  final List<Map<String, dynamic>> profileOptions = [
    {
      'title': 'My Account',
      'icon': Assets.svgsProfileIcon,
      'route': AppRoutes.myAccountPage,
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

  ProfileScreen({super.key});
  void _handleOptionTap(BuildContext context, Map<String, dynamic> option) {
    final String? route = option['route'];
    if (route != null) {
      Navigator.pushNamed(context, route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: const ProfileAppBar(),
      body: SingleChildScrollView(
        child: Padding(
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
              kGap100,
              CustomButton(
                text: 'Log Out',
                onTap: () {},
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
            ],
          ),
        ),
      ),
    );
  }
}
