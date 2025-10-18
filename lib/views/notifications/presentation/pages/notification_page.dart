part of 'pages.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationController = Get.put(NotificationController());
    final quoteController = Get.put(QuoteController());

    return TraderWhoScaffold(
      appBar: const NotificationAppbar(),
      body: Obx(() {
        if (notificationController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColor.primaryButton),
          );
        }

        if (notificationController.notifications.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_off,
                  size: 64,
                  color: AppColor.secondaryText,
                ),
                SizedBox(height: 16),
                Text(
                  'No notifications yet',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColor.secondaryText,
                    fontFamily: 'openSans',
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'You\'ll receive notifications about quotes and job updates here',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColor.secondaryText,
                    fontFamily: 'openSans',
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await notificationController.fetchNotifications();
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'Notifications',
                    fontWeight: FontWeight.w500,
                    fontSize: context.responsiveFontSize(18),
                  ),
                  SizedBox(height: context.responsiveHeight(2)),

                  // Display notifications from controller
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: notificationController.notifications.length,
                    separatorBuilder:
                        (context, index) =>
                            SizedBox(height: context.responsiveHeight(1.2)),
                    itemBuilder: (context, index) {
                      final notification =
                          notificationController.notifications[index];

                      // Show special layout for actionable notifications (pending quotes)
                      if (notification.actionType == 'quote_received') {
                        return _buildActionableNotification(
                          context,
                          notification,
                          quoteController,
                          notificationController,
                        );
                      }

                      // Regular notification card for other types
                      return GestureDetector(
                        onTap:
                            () => _showQuoteInfoBottomSheet(
                              context,
                              notification,
                            ),
                        child: NotificationCard(
                          title: notification.title,
                          description: notification.description,
                          time: notification.formattedTime,
                          avatarImage:
                              notification.avatarImage.isNotEmpty
                                  ? notification.avatarImage
                                  : Assets.imagesNotificationImage,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildActionableNotification(
    BuildContext context,
    QuoteNotification notification,
    QuoteController quoteController,
    NotificationController notificationController,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title and time row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: CustomText(
                text: 'Quote Received - Action Required',
                fontWeight: FontWeight.w500,
                fontSize: context.responsiveFontSize(14),
              ),
            ),
            CustomText(
              text: notification.formattedTime,
              color: AppColor.grey,
              fontSize: context.responsiveFontSize(11),
            ),
          ],
        ),
        SizedBox(height: context.responsiveHeight(1)),

        // Description text
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontFamily: 'openSans',
              fontSize: context.responsiveFontSize(14),
              color: AppColor.secondaryText,
            ),
            children: [
              TextSpan(
                text: notification.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(text: ' sent you a quote for '),
              TextSpan(
                text: '£${notification.quote.quotedPrice.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(text: '. "'),
              TextSpan(text: notification.quote.details),
              const TextSpan(text: '"'),
            ],
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
              Obx(
                () => CustomButton(
                  text: 'REJECT',
                  onTap:
                      quoteController.isLoading.value
                          ? null
                          : () async {
                            await quoteController.rejectQuote(
                              notification.quote.id!,
                            );
                            Get.snackbar(
                              'Quote Rejected',
                              'You have rejected the quote from ${notification.title}',
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                            await notificationController.fetchNotifications();
                          },
                  width: context.responsiveWidth(21),
                  height: context.responsiveHeight(4),
                  color:
                      quoteController.isLoading.value
                          ? Colors.grey
                          : AppColor.primaryButton,
                  textColor: AppColor.white,
                  radius: 25,
                  fontSize: context.responsiveFontSize(10),
                ),
              ),
              // Accept Button
              Obx(
                () => CustomButton(
                  text:
                      quoteController.isLoading.value
                          ? 'PROCESSING...'
                          : 'ACCEPT',
                  onTap:
                      quoteController.isLoading.value
                          ? null
                          : () async {
                            await quoteController.acceptQuote(
                              notification.quote.id!,
                            );
                            Get.snackbar(
                              'Quote Accepted',
                              'You have accepted the quote from ${notification.title}',
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                            );
                            await notificationController.fetchNotifications();
                          },
                  width: context.responsiveWidth(21),
                  height: context.responsiveHeight(4),
                  color:
                      quoteController.isLoading.value
                          ? Colors.grey
                          : AppColor.darkBlue,
                  textColor: AppColor.white,
                  radius: 25,
                  fontSize: context.responsiveFontSize(10),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: context.responsiveHeight(2)),
      ],
    );
  }

  void _showQuoteInfoBottomSheet(
    BuildContext context,
    QuoteNotification notification,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) => NotificationBottomSheet(
            title:
                notification.actionType.contains('accepted')
                    ? 'Quote Accepted'
                    : notification.actionType.contains('rejected')
                    ? 'Quote Rejected'
                    : notification.actionType.contains('expired')
                    ? 'Quote Expired'
                    : 'Quote Update',
            description:
                notification.description +
                '\n\nAmount: £${notification.quote.quotedPrice.toStringAsFixed(2)}' +
                '\nDetails: ${notification.quote.details}',
            onAccept: null, // No action needed for info-only notifications
            onReject: null,
          ),
    );
  }
}
