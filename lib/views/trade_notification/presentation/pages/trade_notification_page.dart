part of 'pages.dart';

class TradeNotificationPage extends StatelessWidget {
  const TradeNotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationController = Get.put(NotificationController());

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
                  'You\'ll receive notifications when customers respond to your quotes',
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
                      'Quote Notifications',
                      style: TextStyle(
                        fontFamily: 'openSans',
                        color: AppColor.primaryText,
                        fontWeight: FontWeight.w500,
                        fontSize: context.responsiveFontSize(18),
                      ),
                    ),
                  ),
                  SizedBox(height: context.responsiveHeight(2)),

                  // Display notifications from controller
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: notificationController.notifications.length,
                    separatorBuilder:
                        (context, index) =>
                            SizedBox(height: context.responsiveHeight(2)),
                    itemBuilder: (context, index) {
                      final notification =
                          notificationController.notifications[index];

                      return GestureDetector(
                        onTap:
                            () =>
                                _showNotificationDetails(context, notification),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  // Status icon
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(
                                        notification.actionType,
                                      ).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      _getStatusIcon(notification.actionType),
                                      color: _getStatusColor(
                                        notification.actionType,
                                      ),
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _getNotificationTitle(
                                            notification.actionType,
                                          ),
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: AppColor.primaryText,
                                            fontFamily: 'openSans',
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          notification.title, // Customer name
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: AppColor.secondaryText,
                                            fontFamily: 'openSans',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    notification.formattedTime,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColor.secondaryText,
                                      fontFamily: 'openSans',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                notification.description,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColor.secondaryText,
                                  fontFamily: 'openSans',
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              // Quote amount
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColor.customLightGray,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Quote: £${notification.quote.quotedPrice.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.primaryText,
                                    fontFamily: 'openSans',
                                  ),
                                ),
                              ),
                            ],
                          ),
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

  String _getNotificationTitle(String actionType) {
    switch (actionType) {
      case 'quote_accepted_by_customer':
        return 'Quote Accepted! 🎉';
      case 'quote_rejected_by_customer':
        return 'Quote Declined';
      default:
        return 'Quote Update';
    }
  }

  Color _getStatusColor(String actionType) {
    switch (actionType) {
      case 'quote_accepted_by_customer':
        return Colors.green;
      case 'quote_rejected_by_customer':
        return Colors.red;
      default:
        return AppColor.primaryButton;
    }
  }

  IconData _getStatusIcon(String actionType) {
    switch (actionType) {
      case 'quote_accepted_by_customer':
        return Icons.check_circle;
      case 'quote_rejected_by_customer':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  void _showNotificationDetails(
    BuildContext context,
    QuoteNotification notification,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) => Container(
            constraints: BoxConstraints(maxHeight: context.screenHeight * 0.6),
            decoration: const BoxDecoration(
              color: AppColor.customLightGray,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Status header
                        Row(
                          children: [
                            Icon(
                              _getStatusIcon(notification.actionType),
                              color: _getStatusColor(notification.actionType),
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _getNotificationTitle(notification.actionType),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.primaryText,
                                  fontFamily: 'openSans',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Customer info
                        Text(
                          'Customer: ${notification.title}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColor.primaryText,
                            fontFamily: 'openSans',
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Quote details
                        Text(
                          'Quote Amount: £${notification.quote.quotedPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColor.primaryText,
                            fontFamily: 'openSans',
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Quote details
                        if (notification.quote.details.isNotEmpty) ...[
                          Text(
                            'Quote Details:',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColor.primaryText,
                              fontFamily: 'openSans',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            notification.quote.details,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColor.secondaryText,
                              fontFamily: 'openSans',
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Description
                        Text(
                          notification.description,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColor.secondaryText,
                            fontFamily: 'openSans',
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Timestamp
                        Text(
                          'Time: ${notification.formattedTime}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColor.secondaryText,
                            fontFamily: 'openSans',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
