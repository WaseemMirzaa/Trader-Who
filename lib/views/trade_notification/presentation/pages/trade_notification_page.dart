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
            horizontal: context.responsiveWidth(4), // ~4% of screen width
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'New Notifications',
                fontSize: context.responsiveFontSize(18),
              ),
              SizedBox(height: context.responsiveHeight(2)),

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
                  // Title and time row
                  SizedBox(height: context.responsiveHeight(2)),
                  NotificationCard(
                    title: "Kate Austen",
                    description:
                        "You will get a notification when your job is accepted.",
                    time: "11:23 AM",
                    avatarImage: Assets.imagesNotificationImage,
                  ),
                  SizedBox(height: context.responsiveHeight(1.2)),

                  CustomText(
                    text: 'New Notifications',
                    fontSize: context.responsiveFontSize(18),
                  ),
                  SizedBox(height: context.responsiveHeight(1.2)),

                  NotificationCard(
                    title: "Kate Austen",
                    description:
                        "You will get a notification when your job is accepted",
                    time: "11:23 AM",
                    avatarImage: Assets.imagesNotificationKate,
                  ),
                  SizedBox(height: context.responsiveHeight(1.2)),

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
