part of 'pages.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  // In your NotificationPage where you handle taps
  void _showNotificationBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) => NotificationBottomSheet(
            title: 'Job Reassessment - Action Required',
            description: 'Your trader has marked the job as "Not as described"',
            onAccept: () {
              // Handle accept action
              Navigator.pop(context);
            },
            onReject: () {
              // Handle reject action
              Navigator.pop(context);
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TraderWhoScaffold(
      appBar: const NotificationAppbar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'New Notifications',
                fontWeight: FontWeight.w500,
                fontSize: context.responsiveFontSize(18),
              ),
              SizedBox(height: context.responsiveHeight(2)),

              // Notification item
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and time row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: CustomText(
                          text: 'Job Reassessment - Action Required',
                          fontWeight: FontWeight.w500,
                          fontSize: context.responsiveFontSize(14),
                        ),
                      ),
                      CustomText(
                        text: '10:30 AM',
                        color: AppColor.grey,
                        fontSize: context.responsiveFontSize(11),
                      ),
                    ],
                  ),
                  SizedBox(height: context.responsiveHeight(1)),

                  // Description text
                  Text(
                    'Your trader has marked the job as "Not as described", as the work required appears to be more extensive than initially outlined.',
                    style: TextStyle(
                      fontFamily: 'openSans',

                      fontSize: context.responsiveFontSize(13),
                      color: AppColor.secondaryText,
                    ),
                  ),
                  SizedBox(height: context.responsiveHeight(1.5)),

                  // Buttons row
                  Align(
                    alignment: Alignment.centerRight,
                    child: Wrap(
                      spacing: context.responsiveWidth(2),
                      children: [
                        // Reject Button
                        CustomButton(
                          text: 'REJECT',
                          onTap: () => _showNotificationBottomSheet(context),
                          width: context.responsiveWidth(
                            21,
                          ), // 20% of screen width
                          height: context.responsiveHeight(
                            4,
                          ), // 4% of screen height
                          color: AppColor.primaryButton,
                          textColor: AppColor.white,
                          radius: 25,
                          fontSize: context.responsiveFontSize(10),
                        ),
                        // Accept Button
                        CustomButton(
                          text: 'ACCEPT',
                          onTap: () => _showNotificationBottomSheet(context),
                          width: context.responsiveWidth(21),
                          height: context.responsiveHeight(4),
                          color: AppColor.darkBlue,
                          textColor: AppColor.white,
                          radius: 25,
                          fontSize: context.responsiveFontSize(10),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: context.responsiveHeight(2)),
                  GestureDetector(
                    onTap: () => _showNotificationBottomSheet(context),
                    child: NotificationCard(
                      title: "Kate Austen",
                      description:
                          "You will get a notification when your job is accepted",
                      time: "11:23 AM",
                      avatarImage: Assets.imagesNotificationImage,
                    ),
                  ),
                  SizedBox(height: context.responsiveHeight(1.2)),

                  CustomText(
                    text: 'New Notifications',
                    fontWeight: FontWeight.w500,
                    fontSize: context.responsiveFontSize(18),
                  ),
                  SizedBox(height: context.responsiveHeight(1.2)),

                  GestureDetector(
                    onTap: () => _showNotificationBottomSheet(context),
                    child: NotificationCard(
                      title: "Kate Austen",
                      description:
                          "You will get a notification when your job is accepted",
                      time: "11:23 AM",
                      avatarImage: Assets.imagesNotificationKate,
                    ),
                  ),
                  SizedBox(height: context.responsiveHeight(1.2)),

                  GestureDetector(
                    onTap: () => _showNotificationBottomSheet(context),
                    child: NotificationCard(
                      title: "Kate Austen",
                      description:
                          "You will get a notification when your job is accepted",
                      time: "11:23 AM",
                      avatarImage: Assets.imagesNotificationAusten,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
