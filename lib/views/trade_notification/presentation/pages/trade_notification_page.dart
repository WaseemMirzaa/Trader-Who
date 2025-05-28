part of 'pages.dart';

class TradeNotificationPage extends StatelessWidget {
  const TradeNotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: const NotificationAppbar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.responsiveWidth(4),
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  'New Notifications',
                  style: TextStyle(
                    color: AppColor.black,
                    fontWeight: FontWeight.w500,
                    fontSize: context.responsiveFontSize(18),
                  ),
                ),
              ),
              SizedBox(
                height: context.responsiveHeight(2),
              ), // Consistent spacing
              // Notification item
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NotificationCard(
                    title: "Kate Austen",
                    description:
                        "You will get a notification when your job is accepted.",
                    time: "11:23 AM",
                    avatarImage: Assets.imagesTradeNotification,
                  ),
                  SizedBox(
                    height: context.responsiveHeight(2),
                  ), // Consistent spacing
                  NotificationCard(
                    title: "Kate Austen",
                    description:
                        "You will get a notification when your job is accepted.",
                    time: "11:23 AM",
                    avatarImage: Assets.imagesNotificationImage,
                  ),
                  SizedBox(
                    height: context.responsiveHeight(2),
                  ), // Consistent spacing
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      'New Notifications',
                      style: TextStyle(
                        color: AppColor.black,
                        fontWeight: FontWeight.w500,
                        fontSize: context.responsiveFontSize(18),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: context.responsiveHeight(2),
                  ), // Consistent spacing
                  NotificationCard(
                    title: "Kate Austen",
                    description:
                        "You will get a notification when your job is accepted",
                    time: "11:23 AM",
                    avatarImage: Assets.imagesNotificationKate,
                  ),
                  SizedBox(
                    height: context.responsiveHeight(2),
                  ), // Consistent spacing
                  NotificationCard(
                    title: "Kate Austen",
                    description:
                        "You will get a notification when your job is accepted",
                    time: "11:23 AM",
                    avatarImage: Assets.imagesNotificationAusten,
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
