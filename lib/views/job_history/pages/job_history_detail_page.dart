part of 'pages.dart';

class JobHistoryDetailPage extends StatefulWidget {
  final JobHistory job;

  const JobHistoryDetailPage({super.key, required this.job});

  @override
  State<JobHistoryDetailPage> createState() => _JobHistoryDetailPageState();
}

class _JobHistoryDetailPageState extends State<JobHistoryDetailPage> {
  String? _categoryName;
  final JobHistoryPageController _jobHistoryController = Get.find();

  @override
  void initState() {
    super.initState();
    _loadCategoryName();
  }

  Future<void> _showCompletionVerificationDialog(BookingModel booking) async {
    final commentController = TextEditingController();

    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Verify Job Completion'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Please review the completed work images below:',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  // Show completion images uploaded by trader
                  if (booking.completionImages.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: booking.completionImages.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: booking.completionImages[index],
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  const Text(
                    'Is the work completed satisfactorily?',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: commentController,
                    maxLines: 5,

                    // borderColor: Colors.grey,
                    hintText:
                        'Add comments (optional - or required if rejecting)',
                    hintStyle: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () async {
                  if (commentController.text.trim().isEmpty) {
                    Get.snackbar(
                      'Comment Required',
                      'Please provide feedback about what needs to be fixed',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return;
                  }
                  Navigator.pop(context);
                  await _rejectCompletion(
                    booking,
                    commentController.text.trim(),
                  );
                },
                child: const Text('Needs Work'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.green,
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  await _approveCompletion(
                    booking,
                    commentController.text.trim(),
                  );
                },
                child: const Text('Approve'),
              ),
            ],
          ),
    );
  }

  Future<void> _approveCompletion(BookingModel booking, String comment) async {
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(booking.id)
          .update({
            'customerApproved': true,
            'customerComment': comment,
            'status': 'completed',
            'updatedAt': DateTime.now().millisecondsSinceEpoch,
          });

      // Create notification for trader
      await NotificationService.createCompletionApprovedNotification(
        traderId: booking.traderId,
        bookingId: booking.id ?? '',
        jobTitle: widget.job.title,
      );

      Get.snackbar(
        'Job Approved',
        'The job has been marked as completed',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Show review dialog
      _showReviewDialog(booking);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to approve completion: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _rejectCompletion(BookingModel booking, String comment) async {
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(booking.id)
          .update({
            'customerApproved': false,
            'customerComment': comment,
            'status': 'inProgress',
            'updatedAt': DateTime.now().millisecondsSinceEpoch,
          });

      // Create notification for trader
      await NotificationService.createCompletionRejectedNotification(
        traderId: booking.traderId,
        bookingId: booking.id ?? '',
        jobTitle: widget.job.title,
        customerComment: comment,
      );

      Get.snackbar(
        'Feedback Sent',
        'Your feedback has been sent to the trader',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send feedback: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _showReviewDialog(BookingModel booking) async {
    int rating = 5;
    final reviewController = TextEditingController();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  title: const Text('Rate Your Experience'),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'How was your experience with ${widget.job.tradesPerson.name}?',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            return IconButton(
                              icon: Icon(
                                index < rating ? Icons.star : Icons.star_border,
                                color: Colors.orange,
                                size: 32,
                              ),
                              onPressed: () {
                                setState(() {
                                  rating = index + 1;
                                });
                              },
                            );
                          }),
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: reviewController,
                          maxLines: 4,
                          hintText: 'Share your experience (optional)',
                          hintStyle: TextStyle(color: AppColor.grey),
                          borderColor: AppColor.grey,
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Skip'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryButton,
                      ),
                      onPressed: () async {
                        await _submitReview(
                          booking,
                          rating,
                          reviewController.text.trim(),
                        );
                        Navigator.pop(context);
                      },
                      child: const Text('Submit Review'),
                    ),
                  ],
                ),
          ),
    );
  }

  Future<void> _submitReview(
    BookingModel booking,
    int rating,
    String review,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(booking.id)
          .update({
            'traderRating': rating,
            'traderReview': review,
            'updatedAt': DateTime.now().millisecondsSinceEpoch,
          });

      // Update trader's average rating
      await RatingService.updateTraderRating(booking.traderId);

      Get.snackbar(
        'Review Submitted',
        'Thank you for your feedback!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to submit review: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  String _formatJobType(String jobType) {
    if (jobType.toLowerCase() == 'smalljob' ||
        jobType.toLowerCase() == 'small') {
      return 'Small Job';
    } else if (jobType.toLowerCase() == 'largejob' ||
        jobType.toLowerCase() == 'large') {
      return 'Large Job';
    }
    return jobType;
  }

  Future<void> _loadCategoryName() async {
    // Check if category is already a readable name or an ID
    // If it contains underscore or looks like an ID, look it up
    if (widget.job.category.contains('_') || widget.job.category.length > 30) {
      // It's likely an ID, fetch the name from categories collection
      try {
        final NewServiceController serviceController = Get.find();
        final category = serviceController.categories.firstWhereOrNull(
          (c) => c.id == widget.job.category,
        );
        if (category != null && mounted) {
          setState(() {
            _categoryName = category.name;
          });
        }
      } catch (e) {
        print('Error loading category name: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWaitingForProposal = widget.job.status == 'pending';

    return TraderWhoScaffold(
      appBar: JobHistoryDetailAppBar(
        job: widget.job,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          // Scrollable main content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  // Job title, price, and status row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomCircleAvatar(
                        circleColor: Colors.transparent,
                        backgroundColor: AppColor.white,
                        radius: 24,
                        child: SvgPicture.asset(
                          widget.job.svgIcon,
                          width: 24,
                          height: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _categoryName ?? widget.job.category,
                              style: const TextStyle(
                                color: AppColor.primaryText,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'openSans',
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  Assets.svgsPound,
                                  width: 16,
                                  height: 16,
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              '${_formatJobType(widget.job.jobType)} - Fixed Price: ',
                                          style: TextStyle(
                                            fontFamily: 'openSans',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: AppColor.primaryText,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '£${widget.job.price}',
                                          style: TextStyle(
                                            fontFamily: 'openSans',
                                            fontSize: 14,
                                            color:
                                                AppColor
                                                    .secondaryText, // Or any other color you prefer
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColor.midGray, width: 1),
                        ),
                        child: Text(
                          HelperService.formatStatus(widget.job.status),
                          style: const TextStyle(
                            fontFamily: 'openSans',
                            fontSize: 12,
                            color: AppColor.primaryText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Preferred Time
                  Row(
                    children: [
                      SvgPicture.asset(Assets.svgsTime, width: 16, height: 16),
                      const SizedBox(width: 4),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Preferred Time: ',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColor.primaryText,
                                fontFamily: 'openSans',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: widget.job.preferredTime,
                              style: TextStyle(
                                fontFamily: 'openSans',
                                fontSize: 14,
                                color: AppColor.secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Description Section - Only show if notes are not empty
                  if (widget.job.notes.isNotEmpty) ...[
                    Text(
                      'Notes:',
                      style: TextStyle(
                        fontFamily: 'openSans',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColor.primaryText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.job.notes,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColor.secondaryText,
                        fontFamily: 'openSans',
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  Row(
                    spacing: 8.0,
                    children: [
                      for (var imageUrl in widget.job.images)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            width: 70,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                    ],
                  ),
                  kGap10,
                  // Conditionally show Tradesperson, Location, and Map
                  if (true || !isWaitingForProposal) ...[
                    // Tradesperson Section
                    ...[
                      const SizedBox(height: 12),
                      TradesPeopleCard(
                        person: widget.job.tradesPerson,
                        price: widget.job.price,
                      ),
                      const SizedBox(height: 20),
                    ],
                    CustomText(
                      text: 'Location',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: AppColor.primaryText,
                    ),
                    kGap10,
                    Row(
                      children: [
                        SvgPicture.asset(
                          Assets.svgsLocation,
                          width: 16,
                          height: 16,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: RichText(
                            maxLines: 3,
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'Address: ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColor.primaryText,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'openSans',
                                  ),
                                ),
                                TextSpan(
                                  text: widget.job.address,

                                  style: TextStyle(
                                    fontSize: 14,
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
                    kGap10,
                    // Map Container
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.grey.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: GoogleMap(
                          onMapCreated: (controller) {
                            // Store controller if needed
                          },
                          initialCameraPosition: CameraPosition(
                            target: widget.job.location,
                            zoom: 15.0,
                          ),
                          markers: {
                            Marker(
                              markerId: MarkerId(widget.job.bookingId),
                              position: widget.job.location,
                              infoWindow: InfoWindow(title: widget.job.address),
                            ),
                          },
                          myLocationEnabled: false,
                          zoomControlsEnabled: false,
                          scrollGesturesEnabled: false,
                          tiltGesturesEnabled: false,
                          rotateGesturesEnabled: false,
                        ),
                      ),
                    ),
                  ],

                  // Reviews Section (show after job completion, before StreamBuilder)
                  StreamBuilder<DocumentSnapshot>(
                    stream:
                        FirebaseFirestore.instance
                            .collection('bookings')
                            .doc(widget.job.bookingId)
                            .snapshots(),
                    builder: (context, snapshot) {
                      BookingModel? booking;
                      if (snapshot.hasData && snapshot.data?.data() != null) {
                        try {
                          booking = BookingModel.fromFirestore(snapshot.data!);
                        } catch (e) {
                          print('Error parsing booking for reviews: $e');
                        }
                      }

                      // Only show if job is completed and booking data exists
                      if (booking != null && booking.status == 'completed') {
                        return Column(
                          children: [
                            const SizedBox(height: 20),

                            // Your Rating for Trader
                            if (booking.traderRating != null &&
                                booking.traderRating! > 0) ...[
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.green.shade200,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.rate_review_outlined,
                                          color: Colors.green.shade700,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Your Feedback for Trader',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: AppColor.primaryText,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'openSans',
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: List.generate(5, (index) {
                                        return Icon(
                                          Icons.star,
                                          color:
                                              index <
                                                      (booking?.traderRating ??
                                                              0)
                                                          .floor()
                                                  ? Colors.amber
                                                  : Colors.grey.shade300,
                                          size: 24,
                                        );
                                      }),
                                    ),
                                    if (booking.traderReview != null &&
                                        booking.traderReview!.isNotEmpty) ...[
                                      const SizedBox(height: 12),
                                      Text(
                                        booking.traderReview!,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColor.secondaryText,
                                          fontFamily: 'openSans',
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],

                            // Trader's Rating for You
                            if (booking.customerRating != null &&
                                booking.customerRating! > 0) ...[
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.blue.shade200,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.person_outline,
                                          color: Colors.blue.shade700,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Trader\'s Feedback for You',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: AppColor.primaryText,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'openSans',
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: List.generate(5, (index) {
                                        return Icon(
                                          Icons.star,
                                          color:
                                              index <
                                                      (booking?.customerRating ??
                                                              0)
                                                          .floor()
                                                  ? Colors.amber
                                                  : Colors.grey.shade300,
                                          size: 24,
                                        );
                                      }),
                                    ),
                                    if (booking.customerReview != null &&
                                        booking.customerReview!.isNotEmpty) ...[
                                      const SizedBox(height: 12),
                                      Text(
                                        booking.customerReview!,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColor.secondaryText,
                                          fontFamily: 'openSans',
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),

                  const SizedBox(height: 80), // Padding for bottom content
                ],
              ),
            ),
          ),
          // Bottom action bar - Dynamic based on booking status
          StreamBuilder<DocumentSnapshot>(
            stream:
                FirebaseFirestore.instance
                    .collection('bookings')
                    .doc(widget.job.bookingId)
                    .snapshots(),
            builder: (context, snapshot) {
              // Default to widget status if no snapshot
              String currentStatus = widget.job.status;
              BookingModel? currentBooking;
              List<String> completionImages = [];

              if (snapshot.hasData && snapshot.data?.data() != null) {
                try {
                  currentBooking = BookingModel.fromFirestore(snapshot.data!);
                  currentStatus = currentBooking.status;
                  completionImages = currentBooking.completionImages;
                } catch (e) {
                  print('Error parsing booking: $e');
                }
              }

              // Status: awaiting_verification - Trader marked complete, waiting for customer approval
              if (currentStatus == 'awaiting_verification' &&
                  currentBooking != null) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Job completed! Please verify',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColor.primaryText,
                        ),
                      ),
                      if (completionImages.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 80,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: completionImages.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                    imageUrl: completionImages[index],
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      CustomButton(
                        text: 'Verify & Complete',
                        onTap:
                            () => _showCompletionVerificationDialog(
                              currentBooking!,
                            ),
                        height: 50,
                        color: AppColor.green,
                        textColor: Colors.white,
                        radius: 25,
                      ),
                    ],
                  ),
                );
              }

              // Status: completed - Show review option if not already reviewed
              if (currentStatus == 'completed' && currentBooking != null) {
                if (currentBooking.traderRating == null) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, -5),
                        ),
                      ],
                    ),
                    child: CustomButton(
                      text: 'Rate Trader',
                      onTap: () => _showReviewDialog(currentBooking!),
                      height: 50,
                      color: AppColor.primaryButton,
                      textColor: Colors.white,
                      radius: 25,
                    ),
                  );
                } else {
                  // Already reviewed, show thank you message
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, -5),
                        ),
                      ],
                    ),
                    child: const Text(
                      '✅ Job Completed & Reviewed',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColor.green,
                      ),
                    ),
                  );
                }
              }

              // Default UI for other statuses
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child:
                    isWaitingForProposal
                        ? CustomButton(
                          text: 'Waiting for Accept the Job',
                          onTap: () {},
                          height: 45,
                          color: AppColor.primaryButton,
                          textColor: Colors.white,
                          radius: 25,
                        )
                        : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: CustomButton(
                                text: 'Cancel Job',
                                onTap: () {},
                                height: 50,
                                color: AppColor.primaryButton,
                                textColor: Colors.white,
                                radius: 25,
                              ),
                            ),
                            kGap10,
                            InkWell(
                              onTap: () {
                                launchUrl(
                                  Uri.parse(
                                    'tel:${widget.job.tradesPerson.phoneNumber}',
                                  ),
                                );
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color:
                                      AppColor.darkBlue, // Dark blue background
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    Assets.svgsCall,
                                    width: 25,
                                    height: 25,
                                  ),
                                ),
                              ),
                            ),
                            kGap10,
                            InkWell(
                              onTap: () async {
                                // Create booking-based chat
                                final ChatController chatController = Get.put(
                                  ChatController(),
                                );
                                final currentUserId =
                                    FirebaseAuth.instance.currentUser!.uid;

                                // Ensure chat exists with booking reference
                                await chatController.createChatIfNotExists(
                                  currentUserId,
                                  widget.job.tradesPerson.id,
                                  true, // isOrderChat
                                  widget.job.bookingId, // orderId
                                  orderCategory: widget.job.category,
                                  orderService: widget.job.service,
                                );

                                // Fetch the chat model to pass to ChatDetailPage
                                // For order-based chat, include orderId in chat ID
                                final chatId = chatController.getChatId(
                                  currentUserId,
                                  widget.job.tradesPerson.id,
                                  orderId: widget.job.bookingId,
                                );

                                final chatDoc =
                                    await FirebaseFirestore.instance
                                        .collection('chats')
                                        .doc(chatId)
                                        .get();

                                ChatModel? chatModel;
                                if (chatDoc.exists) {
                                  chatModel = ChatModel.fromMap(
                                    chatDoc.data() as Map<String, dynamic>,
                                    chatDoc.id,
                                  );
                                }

                                Get.to(
                                  () => ChatDetailPage(
                                    avatarImage:
                                        widget.job.tradesPerson.imageUrl,
                                    userName: widget.job.tradesPerson.name,
                                    receiverId: widget.job.tradesPerson.id,
                                    chatModel: chatModel,
                                  ),
                                );
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color:
                                      AppColor
                                          .primaryButton, // Dark blue background
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    Assets.svgsMessage,
                                    width: 25,
                                    height: 25,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
              );
            },
          ),
        ],
      ),
    );
  }
}
