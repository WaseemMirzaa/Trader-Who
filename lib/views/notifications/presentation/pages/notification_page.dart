part of 'pages.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  Query<Map<String, dynamic>> _getSystemNotificationsQuery() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return FirebaseFirestore.instance.collection('notifications').limit(0);
    }

    return FirebaseFirestore.instance
        .collection('notifications')
        .where('recipientId', isEqualTo: currentUser.uid)
        .orderBy('createdAt', descending: true);
  }

  @override
  Widget build(BuildContext context) {
    final notificationController = Get.put(NotificationController());

    return TraderWhoScaffold(
      appBar: const NotificationAppbar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Mark All as Read button
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: 'Notifications',
                    fontWeight: FontWeight.w500,
                    fontSize: context.responsiveFontSize(18),
                  ),
                  if (notificationController.unreadCount.value > 0)
                    TextButton(
                      onPressed: () async {
                        await notificationController.markAllAsRead();
                        Get.snackbar(
                          'Success',
                          'All notifications marked as read',
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                          duration: const Duration(seconds: 2),
                        );
                      },
                      child: const Text(
                        'Mark all as read',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColor.darkBlue,
                          fontFamily: 'openSans',
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: context.responsiveHeight(2)),

            // System Notifications (completion, booking updates, etc.) - Paginated
            CustomText(
              text: 'Recent Updates',
              fontWeight: FontWeight.w500,
              fontSize: context.responsiveFontSize(16),
              color: AppColor.secondaryText,
            ),
            SizedBox(height: context.responsiveHeight(1)),

            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // System Notifications (Paginated)
                    SizedBox(
                      height: 300,
                      child: PaginateFirestore(
                        itemBuilder: (context, documentSnapshots, index) {
                          final notification = NotificationModel.fromFirestore(
                            documentSnapshots[index],
                          );

                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: context.responsiveHeight(1.2),
                            ),
                            child: GestureDetector(
                              onTap: () async {
                                // Mark as read when tapped
                                if (!notification.isRead &&
                                    notification.id != null) {
                                  await notificationController
                                      .markNotificationAsRead(notification.id!);
                                }

                                // Show notification details
                                _showSystemNotificationBottomSheet(
                                  context,
                                  notification,
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color:
                                      notification.isRead
                                          ? Colors.white
                                          : AppColor.darkBlue.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color:
                                        notification.isRead
                                            ? AppColor.grey.withOpacity(0.2)
                                            : AppColor.darkBlue.withOpacity(
                                              0.3,
                                            ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    // Unread indicator
                                    if (!notification.isRead)
                                      Container(
                                        width: 8,
                                        height: 8,
                                        margin: const EdgeInsets.only(
                                          right: 12,
                                        ),
                                        decoration: const BoxDecoration(
                                          color: AppColor.darkBlue,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  notification.title,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        notification.isRead
                                                            ? FontWeight.w500
                                                            : FontWeight.bold,
                                                    color: AppColor.primaryText,
                                                    fontFamily: 'openSans',
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                _formatTime(
                                                  notification.createdAt,
                                                ),
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  color: AppColor.grey,
                                                  fontFamily: 'openSans',
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            notification.message,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: AppColor.secondaryText,
                                              fontFamily: 'openSans',
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        query: _getSystemNotificationsQuery(),
                        itemBuilderType: PaginateBuilderType.listView,
                        isLive: true,
                        onEmpty: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(50.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.notifications_off_outlined,
                                  size: 48,
                                  color: AppColor.secondaryText,
                                ),
                                const SizedBox(height: 16),
                                CustomText(
                                  text: 'No notifications yet',
                                  fontSize: 14,
                                  color: AppColor.secondaryText,
                                ),
                              ],
                            ),
                          ),
                        ),
                        onError:
                            (error) => Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.error_outline,
                                      size: 48,
                                      color: Colors.red,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Error loading notifications',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColor.darkGray,
                                        fontFamily: 'openSans',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        initialLoader: const Center(
                          child: CircularProgressIndicator(
                            color: AppColor.primaryButton,
                          ),
                        ),
                        bottomLoader: const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(
                              color: AppColor.primaryButton,
                            ),
                          ),
                        ),
                        itemsPerPage: 15,
                        shrinkWrap: false,
                        physics: const AlwaysScrollableScrollPhysics(),
                      ),
                    ),

                    SizedBox(height: context.responsiveHeight(3)),

                    // Quote Notifications Section
                    Obx(() {
                      final quoteController = Get.put(QuoteController());

                      if (notificationController.notifications.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: 'Quote Notifications',
                            fontWeight: FontWeight.w500,
                            fontSize: context.responsiveFontSize(16),
                            color: AppColor.secondaryText,
                          ),
                          SizedBox(height: context.responsiveHeight(1)),

                          // Quote Notifications List
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount:
                                notificationController.notifications.length,
                            separatorBuilder:
                                (context, index) => SizedBox(
                                  height: context.responsiveHeight(1.5),
                                ),
                            itemBuilder: (context, index) {
                              final notification =
                                  notificationController.notifications[index];

                              // Check if this is an actionable quote (needs accept/reject)
                              final isActionable =
                                  notification.actionType == 'quote_received';

                              return Container(
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
                                    // Header Row
                                    Row(
                                      children: [
                                        // Status icon
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: _getQuoteStatusColor(
                                              notification.actionType,
                                            ).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Icon(
                                            _getQuoteStatusIcon(
                                              notification.actionType,
                                            ),
                                            color: _getQuoteStatusColor(
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
                                                _getQuoteNotificationTitle(
                                                  notification.actionType,
                                                ),
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColor.primaryText,
                                                  fontFamily: 'openSans',
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                notification
                                                    .title, // Trader name
                                                style: const TextStyle(
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
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColor.secondaryText,
                                            fontFamily: 'openSans',
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),

                                    // Description
                                    Text(
                                      notification.description,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: AppColor.secondaryText,
                                        fontFamily: 'openSans',
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 12),

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
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: AppColor.primaryText,
                                          fontFamily: 'openSans',
                                        ),
                                      ),
                                    ),

                                    // Accept/Reject buttons for actionable quotes
                                    if (isActionable) ...[
                                      const SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          // Reject Button
                                          Obx(
                                            () => CustomButton(
                                              text: 'REJECT',
                                              onTap:
                                                  quoteController
                                                          .isLoading
                                                          .value
                                                      ? null
                                                      : () async {
                                                        await quoteController
                                                            .rejectQuote(
                                                              notification
                                                                  .quote
                                                                  .id!,
                                                            );
                                                        Get.snackbar(
                                                          'Quote Rejected',
                                                          'You have rejected the quote from ${notification.title}',
                                                          backgroundColor:
                                                              Colors.red,
                                                          colorText:
                                                              Colors.white,
                                                        );
                                                        await notificationController
                                                            .fetchNotifications();
                                                      },
                                              width: context.responsiveWidth(
                                                21,
                                              ),
                                              height: context.responsiveHeight(
                                                4,
                                              ),
                                              color:
                                                  quoteController
                                                          .isLoading
                                                          .value
                                                      ? Colors.grey
                                                      : AppColor.primaryButton,
                                              textColor: AppColor.white,
                                              radius: 25,
                                              fontSize: context
                                                  .responsiveFontSize(10),
                                            ),
                                          ),
                                          SizedBox(
                                            width: context.responsiveWidth(2),
                                          ),
                                          // Accept Button
                                          Obx(
                                            () => CustomButton(
                                              text:
                                                  quoteController
                                                          .isLoading
                                                          .value
                                                      ? 'PROCESSING...'
                                                      : 'ACCEPT',
                                              onTap:
                                                  quoteController
                                                          .isLoading
                                                          .value
                                                      ? null
                                                      : () async {
                                                        await quoteController
                                                            .acceptQuote(
                                                              notification
                                                                  .quote
                                                                  .id!,
                                                            );
                                                        Get.snackbar(
                                                          'Quote Accepted',
                                                          'You have accepted the quote from ${notification.title}',
                                                          backgroundColor:
                                                              Colors.green,
                                                          colorText:
                                                              Colors.white,
                                                        );
                                                        await notificationController
                                                            .fetchNotifications();
                                                      },
                                              width: context.responsiveWidth(
                                                21,
                                              ),
                                              height: context.responsiveHeight(
                                                4,
                                              ),
                                              color:
                                                  quoteController
                                                          .isLoading
                                                          .value
                                                      ? Colors.grey
                                                      : AppColor.darkBlue,
                                              textColor: AppColor.white,
                                              radius: 25,
                                              fontSize: context
                                                  .responsiveFontSize(10),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getQuoteNotificationTitle(String actionType) {
    switch (actionType) {
      case 'quote_received':
        return 'New Quote Received';
      case 'quote_accepted_by_trader':
        return 'Quote Accepted by Trader';
      case 'quote_rejected_by_trader':
        return 'Quote Declined by Trader';
      case 'quote_expired':
        return 'Quote Expired';
      default:
        return 'Quote Update';
    }
  }

  Color _getQuoteStatusColor(String actionType) {
    switch (actionType) {
      case 'quote_received':
        return AppColor.primaryButton;
      case 'quote_accepted_by_trader':
        return Colors.green;
      case 'quote_rejected_by_trader':
        return Colors.red;
      case 'quote_expired':
        return Colors.orange;
      default:
        return AppColor.darkBlue;
    }
  }

  IconData _getQuoteStatusIcon(String actionType) {
    switch (actionType) {
      case 'quote_received':
        return Icons.request_quote;
      case 'quote_accepted_by_trader':
        return Icons.check_circle;
      case 'quote_rejected_by_trader':
        return Icons.cancel;
      case 'quote_expired':
        return Icons.timer_off;
      default:
        return Icons.info;
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  void _showSystemNotificationBottomSheet(
    BuildContext context,
    NotificationModel notification,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Title
                Text(
                  notification.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primaryText,
                    fontFamily: 'openSans',
                  ),
                ),
                const SizedBox(height: 16),

                // Message
                Text(
                  notification.message,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: AppColor.secondaryText,
                    fontFamily: 'openSans',
                  ),
                ),
                const SizedBox(height: 8),

                // Show customer comment if it's a completion_rejected notification
                if (notification.type == 'completion_rejected' &&
                    notification.data['customerComment'] != null &&
                    notification.data['customerComment']
                        .toString()
                        .isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColor.lightCyan,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColor.darkBlue.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Customer Feedback:',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColor.primaryText,
                            fontFamily: 'openSans',
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '"${notification.data['customerComment']}"',
                          style: const TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: AppColor.secondaryText,
                            fontFamily: 'openSans',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // Action button if booking data exists
                if (notification.data['bookingId'] != null &&
                    notification.data['bookingId'].toString().isNotEmpty)
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: 'View Job Details',
                      onTap: () async {
                        Navigator.pop(context);

                        // Navigate to job details based on notification type
                        try {
                          final bookingId = notification.data['bookingId'];
                          final bookingDoc =
                              await FirebaseFirestore.instance
                                  .collection('bookings')
                                  .doc(bookingId)
                                  .get();

                          if (bookingDoc.exists) {
                            final booking = BookingModel.fromFirestore(
                              bookingDoc,
                            );
                            final jobHistoryController = Get.put(
                              JobHistoryPageController(),
                            );
                            final job = await jobHistoryController
                                .bookingToJobHistoryForUI(
                                  booking,
                                  isUserBooking: false,
                                );

                            Get.to(() => TradeJobHistoryDetailPage(job: job));
                          } else {
                            Get.snackbar(
                              'Error',
                              'Job not found',
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          }
                        } catch (e) {
                          Get.snackbar(
                            'Error',
                            'Failed to load job details: $e',
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      },
                      height: 48,
                      color: AppColor.darkBlue,
                      textColor: AppColor.white,
                      fontWeight: FontWeight.bold,
                      radius: 25,
                    ),
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: 'Close',
                      onTap: () => Navigator.pop(context),
                      height: 48,
                      color: AppColor.grey,
                      textColor: AppColor.white,
                      fontWeight: FontWeight.bold,
                      radius: 25,
                    ),
                  ),
              ],
            ),
          ),
    );
  }
}
