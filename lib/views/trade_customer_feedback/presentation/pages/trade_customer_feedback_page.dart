part of 'pages.dart';

class TradeCustomerFeedbackPage extends StatefulWidget {
  const TradeCustomerFeedbackPage({super.key});

  @override
  State<TradeCustomerFeedbackPage> createState() =>
      _TradeCustomerFeedbackPageState();
}

class _TradeCustomerFeedbackPageState extends State<TradeCustomerFeedbackPage> {
  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    if (currentUserId == null) {
      return TraderWhoScaffold(
        appBar: TradeCustomerFeedbackAppbar(),
        body: const Center(
          child: Text(
            'Please log in to view your reviews',
            style: TextStyle(fontSize: 16, color: AppColor.secondaryText),
          ),
        ),
      );
    }

    return TraderWhoScaffold(
      appBar: TradeCustomerFeedbackAppbar(),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('bookings')
                .where('traderId', isEqualTo: currentUserId)
                .where('traderRating', isNotEqualTo: null)
                .orderBy('traderRating', descending: true)
                .orderBy('updatedAt', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColor.primaryButton),
            );
          }

          // Error state
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading reviews',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColor.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    snapshot.error.toString(),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          // No data state
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.rate_review_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No reviews yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColor.primaryText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Customer reviews will appear here once\nyou complete jobs',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColor.secondaryText,
                    ),
                  ),
                ],
              ),
            );
          }

          // Data available - show reviews
          final bookings =
              snapshot.data!.docs
                  .map((doc) => BookingModel.fromFirestore(doc))
                  .where(
                    (booking) =>
                        booking.traderRating != null &&
                        booking.traderRating! > 0,
                  )
                  .toList();

          if (bookings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.rate_review_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No reviews yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColor.primaryText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Customer reviews will appear here once\nyou complete jobs',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColor.secondaryText,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              final rating = booking.traderRating?.toDouble() ?? 0.0;
              final review = booking.traderReview ?? '';

              return FutureBuilder<DocumentSnapshot>(
                future:
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(booking.userId)
                        .get(),
                builder: (context, userSnapshot) {
                  String customerName = 'Customer';

                  if (userSnapshot.hasData &&
                      userSnapshot.data?.exists == true) {
                    final userData =
                        userSnapshot.data!.data() as Map<String, dynamic>?;
                    customerName = userData?['name'] ?? 'Customer';
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Star Rating
                        RatingBar.builder(
                          initialRating: rating,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: false,
                          itemCount: 5,
                          itemSize: 21,
                          ignoreGestures: true,
                          itemBuilder:
                              (context, _) => const Icon(
                                Icons.star,
                                color: AppColor.vibrantYellow,
                              ),
                          onRatingUpdate: (rating) {},
                        ),
                        const SizedBox(height: 10),

                        // Job Info
                        if (booking.category.isNotEmpty ||
                            booking.service.isNotEmpty) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColor.lightCyan,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              booking.service.isNotEmpty
                                  ? booking.service
                                  : booking.category,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColor.orangeCustomColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],

                        // Review Text
                        Text(
                          review.isNotEmpty
                              ? review
                              : 'No written review provided.',
                          style: TextStyle(
                            fontFamily: 'openSans',
                            fontSize: 12,
                            color:
                                review.isNotEmpty
                                    ? AppColor.secondaryText
                                    : Colors.grey[400],
                            height: 1.5,
                            fontStyle:
                                review.isEmpty
                                    ? FontStyle.italic
                                    : FontStyle.normal,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Reviewer Name and Date
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              customerName,
                              style: const TextStyle(
                                fontFamily: 'openSans',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColor.primaryText,
                              ),
                            ),
                            if (booking.updatedAt != null)
                              Text(
                                _formatDate(booking.updatedAt!),
                                style: TextStyle(
                                  fontFamily: 'openSans',
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
