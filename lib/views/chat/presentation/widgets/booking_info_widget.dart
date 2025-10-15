part of 'widgets.dart';

class BookingInfoWidget extends StatefulWidget {
  final BookingModel booking;

  const BookingInfoWidget({super.key, required this.booking});

  @override
  State<BookingInfoWidget> createState() => _BookingInfoWidgetState();
}

class _BookingInfoWidgetState extends State<BookingInfoWidget> {
  JobHistory? jobModel;
  Future<JobHistory> _bookingToJobHistory(
    BookingModel booking, {
    required bool isUserBooking,
  }) async {
    UserModel? customer;
    final userDetails =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(booking.userId)
            .get();

    if (userDetails.exists) {
      customer = UserModel.fromFirestore(userDetails);
    }

    // Fetch trader details if available
    TradesPerson? traderData;
    if (booking.traderId.isNotEmpty) {
      try {
        final traderDoc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(booking.traderId)
                .get();
        if (traderDoc.exists) {
          // final data = traderDoc.data() as Map<String, dynamic>;
          traderData = TradesPerson.fromDocumentSnapshot(traderDoc);
          // TradesPerson(
          //   id: booking.traderId,
          //   name: data['name'] ?? 'Trader',
          //   title: data['title'] ?? 'Professional',
          //   bio: data['bio'] ?? 'Professional service provider',
          //   expertise: data['expertise'] ?? booking.category,
          //   description:
          //       data['description'] ?? booking.notes.isNotEmpty
          //           ? booking.notes
          //           : 'Service booking',
          //   imageUrl: data['imageUrl'] ?? 'assets/images/chat-avatar.png',
          //   price: data['price'] ?? booking.price.toString(),
          //   rating: data['rating']?.toDouble() ?? booking.rating,
          //   largeJobs: data['largeJobs'] ?? [],
          //   smallJobs: data['smallJobs'] ?? [],
          //   latitude: data['latitude']?.toDouble() ?? booking.latitude,
          //   longitude: data['longitude']?.toDouble() ?? booking.longitude,
          //   startTime: data['start_time'],
          //   endTime: data['end_time'],
          // );
        }
      } catch (e) {
        print('❌ Error fetching trader details: $e');
      }
    }

    TradesPerson defaultTrader =
        traderData ??
        TradesPerson(
          id: booking.traderId,
          name: isUserBooking ? 'Trader' : 'Customer',
          bio: 'Professional service provider',
          expertise: booking.category,
          description:
              booking.notes.isNotEmpty ? booking.notes : 'Service booking',
          imageUrl: 'assets/images/chat-avatar.png',
          price: booking.price.toString(),
          rating: booking.rating,
          largeJobs: [],
          smallJobs: [],
          latitude: booking.latitude,
          longitude: booking.longitude,
        );

    // Get address from coordinates
    final address = await LocationUtils.getAddressFromCoordinates(
      booking.latitude,
      booking.longitude,
    );

    return JobHistory(
      title: booking.category.isNotEmpty ? booking.category : 'Service',
      svgIcon: _getCategoryIcon(booking.category),
      jobType: booking.jobType,
      category: booking.category,
      price: booking.price,
      preferredTime: _formatDate(booking.preferredTime!),
      address: address,
      status: booking.status,
      tradesPerson: defaultTrader,
      showQuoteButtons: booking.status == 'pending',
      images: booking.images,
      notes: booking.notes,
      location: LatLng(booking.latitude, booking.longitude),
      bookingId: booking.id ?? "-",
      userId: booking.userId,
      customer: customer,
    );
  }

  String _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'plumbing':
        return 'assets/images/plumber.png';
      case 'electrical':
        return 'assets/images/electricity.png';
      case 'cleaning':
        return 'assets/svgs/cleaning.svg';
      case 'carpentry':
        return 'assets/svgs/carpentry.svg';
      case 'painting':
        return 'assets/svgs/painting.svg';
      case 'roofing':
        return 'assets/svgs/roofing.svg';
      case 'flooring':
        return 'assets/svgs/flooring.svg';
      case 'heating':
        return 'assets/svgs/heating.svg';
      case 'landscaping':
        return 'assets/svgs/landscaping.svg';
      default:
        return 'assets/svgs/general.svg';
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not specified';
    return DateFormat('MMM dd, yyyy • HH:mm').format(date);
  }

  String _formatStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'accepted':
        return 'Accepted';
      case 'rejected':
        return 'Rejected';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.blue;
      case 'rejected':
        return Colors.red;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.schedule;
      case 'accepted':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      case 'completed':
        return Icons.done_all;
      case 'cancelled':
        return Icons.block;
      default:
        return Icons.info;
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      jobModel = await _bookingToJobHistory(
        widget.booking,
        isUserBooking: true,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JobHistoryDetailPage(job: jobModel!),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status
            Row(
              children: [
                Icon(Icons.work_outline, color: AppColor.primaryText, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.booking.category,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColor.primaryText,
                      fontFamily: 'openSans',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(
                      widget.booking.status,
                    ).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _getStatusColor(
                        widget.booking.status,
                      ).withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatStatus(widget.booking.status),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: _getStatusColor(widget.booking.status),
                          fontFamily: 'openSans',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Booking details
            _buildDetailRow(
              value:
                  widget.booking.service.isNotEmpty
                      ? widget.booking.service
                      : widget.booking.category,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({required String value}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColor.primaryText,
              fontFamily: 'openSans',
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
