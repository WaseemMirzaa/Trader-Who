part of 'pages.dart';

class TradeJobHistoryDetailPage extends StatefulWidget {
  final JobHistory job;

  const TradeJobHistoryDetailPage({super.key, required this.job});

  @override
  State<TradeJobHistoryDetailPage> createState() =>
      _TradeJobHistoryDetailPageState();
}

class _TradeJobHistoryDetailPageState extends State<TradeJobHistoryDetailPage> {
  JobHistoryPageController jobHistoryPageController = Get.find();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  List<XFile> _completionImages = [];
  bool _isUploadingImages = false;

  @override
  void dispose() {
    _priceController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  void _showReassessBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      showDragHandle: false,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder:
          (context) => TradeJobHistoryBottomSheet(
            title: 'Job Reassessment Submitted',
            description: 'Please provide updated price and reason',
            priceController: _priceController,
            reasonController: _detailsController,
            onSubmit: () async {
              await _submitQuote();
            },
          ),
    );
  }

  void _showQuoteBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      showDragHandle: false,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder:
          (context) => TradeJobQuoteBottomSheet(
            title: 'Job Quote',
            description: 'Please provide your quote price and details.',
            priceController: _priceController,
            detailsController: _detailsController,
            onSubmit: () async {
              await _submitQuote();
            },
          ),
    );
  }

  /// Submit quote functionality
  Future<void> _submitQuote() async {
    final price = double.tryParse(_priceController.text.trim());
    final details = _detailsController.text.trim();

    // Validate inputs
    if (price == null || price <= 0) {
      Get.snackbar(
        'Invalid Price',
        'Please enter a valid price greater than 0',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (details.isEmpty) {
      Get.snackbar(
        'Missing Details',
        'Please provide quote details',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Find the booking for this job
    final booking = _findBookingForJob(widget.job, jobHistoryPageController);
    if (booking == null) {
      Get.snackbar(
        'Error',
        'Could not find booking information',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Set loading to true
    jobHistoryPageController.isLoading.value = true;

    try {
      // Submit the quote
      final success = await jobHistoryPageController.submitQuote(
        bookingId: booking.id ?? '',
        customerId: booking.userId,
        quotedPrice: price,
        details: details,
      );

      if (success) {
        // Clear the form
        _priceController.clear();
        _detailsController.clear();

        // Close the bottom sheet
        if (mounted && Navigator.canPop(context)) {
          Navigator.pop(context);
        }

        // Show success message
        Get.snackbar(
          'Quote Submitted',
          'Your quote has been sent to the customer',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        // Show error message if submission failed
        Get.snackbar(
          'Error',
          'Failed to submit quote. Please try again.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // Handle any unexpected errors
      Get.snackbar(
        'Error',
        'An unexpected error occurred: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      // Always set loading to false
      jobHistoryPageController.isLoading.value = false;
    }
  }

  Widget _buildNewJobFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.center, // Optional: centers the buttons
            children: [
              Obx(() {
                final isLoading = jobHistoryPageController.isLoading.value;
                return IntrinsicWidth(
                  child: CustomButton(
                    text:
                        isLoading
                            ? (widget.job.jobType == "largeJob"
                                ? "Submitting..."
                                : "Processing...")
                            : (widget.job.jobType == "largeJob"
                                ? "Quote"
                                : 'Accept'),
                    onTap:
                        isLoading
                            ? null
                            : () async {
                              if (widget.job.jobType == "largeJob") {
                                _showQuoteBottomSheet();
                              }

                              if (widget.job.jobType == "smallJob") {
                                jobHistoryPageController.isLoading.value = true;
                                try {
                                  // Update status in Firebase
                                  final newStatus =
                                      widget.job.jobType == "largeJob"
                                          ? 'Quoted'
                                          : 'Accepted';

                                  // Find the corresponding booking and update it
                                  final booking = _findBookingForJob(
                                    widget.job,
                                    jobHistoryPageController,
                                  );
                                  if (booking != null) {
                                    await jobHistoryPageController
                                        .updateBookingStatus(
                                          booking.id ?? '',
                                          newStatus.toLowerCase(),
                                        );
                                    Get.snackbar(
                                      'Success',
                                      'Job status updated successfully',
                                      backgroundColor: Colors.green,
                                      colorText: Colors.white,
                                    );
                                  } else {
                                    Get.snackbar(
                                      'Error',
                                      'Could not find booking information',
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                  }
                                } catch (e) {
                                  Get.snackbar(
                                    'Error',
                                    'An unexpected error occurred: ${e.toString()}',
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                } finally {
                                  jobHistoryPageController.isLoading.value =
                                      false;
                                }
                              }
                            },
                    color: isLoading ? Colors.grey : AppColor.darkBlue,
                    textColor: AppColor.white,
                    height: 50,
                    radius: 30,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }),
              kGap10, // Your predefined spacing widget
              Expanded(
                child: CustomButton(
                  text: 'Reassess Quote',
                  onTap: _showReassessBottomSheet,
                  color: AppColor.primaryButton,
                  textColor: AppColor.white,
                  enableBorder: true,
                  height: 50,
                  radius: 30,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        InkWell(
          onTap: () async {
            jobHistoryPageController.isLoading.value = true;
            try {
              final booking = _findBookingForJob(
                widget.job,
                jobHistoryPageController,
              );
              if (booking != null) {
                await jobHistoryPageController.updateBookingStatus(
                  booking.id ?? '',
                  widget.job.jobType == "largeJob"
                      ? "notInterested"
                      : 'rejected',
                );
                Get.snackbar(
                  'Success',
                  'Job rejected successfully',
                  backgroundColor: Colors.orange,
                  colorText: Colors.white,
                );
              } else {
                Get.snackbar(
                  'Error',
                  'Could not find booking information',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            } catch (e) {
              Get.snackbar(
                'Error',
                'An unexpected error occurred: ${e.toString()}',
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            } finally {
              jobHistoryPageController.isLoading.value = false;
            }
          },
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: AppColor.darkBlue, // #121F30
              borderRadius: BorderRadius.circular(30), // Creates circular shape
            ),
            child: Center(
              child: SvgPicture.asset(
                Assets.svgsCross, // Path to your SVG file

                width: 17, // Adjust size as needed
                height: 17,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = widget.job.status.toLowerCase() == 'completed';

    return StreamBuilder<DocumentSnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('bookings')
              .doc(widget.job.bookingId)
              .snapshots(),
      builder: (context, snapshot) {
        // Use real-time status if available, otherwise use widget.job.status
        String currentStatus = widget.job.status;
        BookingModel? currentBooking;

        if (snapshot.hasData && snapshot.data?.data() != null) {
          final data = snapshot.data!.data() as Map<String, dynamic>;
          currentStatus = data['status'] ?? widget.job.status;
          try {
            currentBooking = BookingModel.fromFirestore(snapshot.data!);
          } catch (e) {
            print('Error parsing booking: $e');
          }
        }

        return TraderWhoScaffold(
          appBar: TradeJobHistoryDetailAppbar(status: currentStatus),
          body: Column(
            children: [
              // Scrollable main content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 20,
                  ),
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
                            radius: 26,
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
                                  widget.job.title,
                                  style: const TextStyle(
                                    color: AppColor.primaryText,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'openSans',
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      Assets.svgsPound,
                                      width: 16,
                                      height: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                                '${HelperService.formattedJobType(widget.job.jobType)}\nFixed Price: ',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: AppColor.primaryText,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'openSans',
                                            ),
                                          ),
                                          TextSpan(
                                            text: '£${widget.job.price}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: AppColor.secondaryText,
                                              fontFamily: 'openSans',
                                            ),
                                          ),
                                        ],
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 80,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColor.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColor.white,
                                width: 0,
                              ),
                            ),
                            child: Text(
                              HelperService.formatStatus(widget.job.status),
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColor.green,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'openSans',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Preferred Time
                      Row(
                        children: [
                          SvgPicture.asset(
                            Assets.svgsTime,
                            width: 16,
                            height: 16,
                          ),
                          const SizedBox(width: 4),
                          RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'Preferred Time: ',
                                  style: TextStyle(
                                    fontFamily: 'openSans',

                                    fontSize: 14,
                                    color: AppColor.primaryText,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                TextSpan(
                                  text: widget.job.preferredTime,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColor.secondaryText,
                                    fontFamily: 'openSans',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Description Section
                      Text(
                        'Notes:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColor.primaryText,
                          fontFamily: 'openSans',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.job.notes == '' ? 'No notes' : widget.job.notes,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColor.secondaryText,
                          fontFamily: 'openSans',
                        ),
                      ),
                      if (widget.job.images.isNotEmpty)
                        const SizedBox(height: 20),
                      Row(
                        children: [
                          for (var image in widget.job.images)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: image,
                                width: 70,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                        ],
                      ),
                      // Images Row (only show for completed jobs)
                      if (isCompleted) ...[kGap10],

                      // Customer Details Section
                      if (widget.job.customer != null) ...[
                        const SizedBox(height: 20),
                        Text(
                          'Customer Details',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColor.primaryText,
                            fontFamily: 'openSans',
                          ),
                        ),
                        const SizedBox(height: 12),
                        CustomerCard(
                          customer: widget.job.customer!,
                          onTap: () {
                            // Optional: Navigate to customer profile or show more details
                          },
                        ),
                      ],

                      // Location and Map
                      const SizedBox(height: 20),
                      CustomText(
                        text: 'Location',
                        fontWeight: FontWeight.w500,
                        fontFamily: 'openSans',

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
                            child: FutureBuilder<String>(
                              future: LocationUtils.getAddressFromLatLng(
                                widget.job.location,
                              ),
                              builder: (context, snapshot) {
                                String addressText;
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  addressText = 'Loading...';
                                } else if (snapshot.hasError) {
                                  addressText = 'Error loading address';
                                } else {
                                  addressText =
                                      snapshot.data ?? 'Address not available';
                                }

                                return RichText(
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: 'Address: ',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColor.primaryText,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'openSans',
                                        ),
                                      ),
                                      TextSpan(
                                        text: addressText,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColor.secondaryText,
                                          fontFamily: 'openSans',
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      kGap10,
                      // Map Container
                      Container(
                        height: 156,
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
                            onMapCreated: (controller) {},
                            initialCameraPosition: CameraPosition(
                              target: widget.job.location,
                              zoom: 15.0,
                            ),
                            markers: {
                              Marker(
                                markerId: const MarkerId('job_location'),
                                position: widget.job.location,
                                infoWindow: InfoWindow(
                                  title: widget.job.address,
                                ),
                              ),
                            },
                            myLocationEnabled: false,
                            zoomControlsEnabled: false,
                            scrollGesturesEnabled: true,

                            tiltGesturesEnabled: false,
                            rotateGesturesEnabled: true,
                          ),
                        ),
                      ),
                      // Feedback Section (only for completed jobs with real-time data)
                      if (isCompleted && currentBooking != null) ...[
                        const SizedBox(height: 20),

                        // Customer's Rating for Trader
                        if (currentBooking.traderRating != null &&
                            currentBooking.traderRating! > 0) ...[
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.blue.shade200),
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
                                      'Customer\'s Feedback for You',
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
                                                  (currentBooking
                                                              ?.traderRating ??
                                                          0)
                                                      .floor()
                                              ? Colors.amber
                                              : Colors.grey.shade300,
                                      size: 24,
                                    );
                                  }),
                                ),
                                if (currentBooking.traderReview != null &&
                                    currentBooking
                                        .traderReview!
                                        .isNotEmpty) ...[
                                  const SizedBox(height: 12),
                                  Text(
                                    currentBooking.traderReview!,
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

                        // Trader's Rating for Customer (if exists)
                        if (currentBooking.customerRating != null &&
                            currentBooking.customerRating! > 0) ...[
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.green.shade200),
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
                                      'Your Feedback for Customer',
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
                                                  (currentBooking
                                                              ?.customerRating ??
                                                          0)
                                                      .floor()
                                              ? Colors.amber
                                              : Colors.grey.shade300,
                                      size: 24,
                                    );
                                  }),
                                ),
                                if (currentBooking.customerReview != null &&
                                    currentBooking
                                        .customerReview!
                                        .isNotEmpty) ...[
                                  const SizedBox(height: 12),
                                  Text(
                                    currentBooking.customerReview!,
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
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
              // Bottom action bar (only for non-completed jobs)
              if (!isCompleted && currentStatus == 'pending')
                Container(
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
                  child: _buildNewJobFooter(),
                ),
              if (currentStatus == 'accepted' && currentStatus != "completed")
                Container(
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
                  child: Obx(() {
                    final isLoading = jobHistoryPageController.isLoading.value;
                    return CustomButton(
                      text: isLoading ? 'Starting...' : 'Start Working',
                      onTap:
                          isLoading
                              ? null
                              : () async {
                                jobHistoryPageController.isLoading.value = true;
                                try {
                                  // Update job status to inProgress
                                  await jobHistoryPageController
                                      .updateBookingStatus(
                                        widget.job.bookingId,
                                        'inProgress',
                                      );
                                  Get.back();
                                } catch (e) {
                                  Get.snackbar(
                                    'Error',
                                    'Failed to start job: ${e.toString()}',
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                } finally {
                                  jobHistoryPageController.isLoading.value =
                                      false;
                                }
                              },
                      color: isLoading ? Colors.grey : AppColor.green,
                      textColor: AppColor.white,
                      height: 50,
                      radius: 30,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    );
                  }),
                ),
              if (currentStatus == 'inProgress' && currentStatus != "completed")
                Container(
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
                    text: 'Mark Complete',
                    onTap: () {
                      _showCompletionImageDialog();
                    },
                    color: AppColor.green,
                    textColor: AppColor.white,
                    height: 50,
                    radius: 30,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              if (currentStatus == 'awaiting_verification')
                Container(
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
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.hourglass_empty,
                          color: Colors.orange.shade700,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Waiting for customer to verify completion',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.orange.shade900,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Status: completed - Show review option if not already reviewed
              if (currentStatus == 'completed' && currentBooking != null)
                if (currentBooking.customerRating == null)
                  Container(
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
                      text: 'Rate Customer',
                      onTap: () => _showCustomerReviewDialog(currentBooking!),
                      height: 50,
                      color: AppColor.primaryButton,
                      textColor: Colors.white,
                      radius: 25,
                    ),
                  )
                else
                  // Already reviewed, show thank you message
                  Container(
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
                      '✅ Job Completed & Customer Reviewed',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColor.green,
                      ),
                    ),
                  ),
            ],
          ),
        ); // Close TraderWhoScaffold
      }, // Close StreamBuilder builder
    ); // Close StreamBuilder
  }

  /// Show completion image upload dialog
  Future<void> _showCompletionImageDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Upload Completion Images'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Please upload images of the completed work. This is required for the customer to verify completion.',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    if (_completionImages.isEmpty)
                      const Text(
                        'No images selected',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      )
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            _completionImages.map((image) {
                              return Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      image.path,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return Container(
                                          width: 80,
                                          height: 80,
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.image),
                                        );
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: InkWell(
                                      onTap: () {
                                        setDialogState(() {
                                          _completionImages.remove(image);
                                        });
                                        setState(() {});
                                      },
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                      ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed:
                          _isUploadingImages
                              ? null
                              : () async {
                                try {
                                  final List<XFile> images =
                                      await _imagePicker.pickMultiImage();
                                  if (images.isNotEmpty) {
                                    setDialogState(() {
                                      _completionImages.addAll(images);
                                    });
                                    setState(() {});
                                  }
                                } catch (e) {
                                  Get.snackbar(
                                    'Error',
                                    'Failed to pick images: ${e.toString()}',
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                }
                              },
                      icon: const Icon(Icons.add_photo_alternate),
                      label: const Text('Add Images'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.darkBlue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed:
                      _isUploadingImages
                          ? null
                          : () {
                            Navigator.pop(context);
                            _completionImages.clear();
                          },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed:
                      _isUploadingImages || _completionImages.isEmpty
                          ? null
                          : () async {
                            await _uploadAndCompleteJob(setDialogState);
                          },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.green,
                    foregroundColor: Colors.white,
                  ),
                  child:
                      _isUploadingImages
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                          : const Text('Submit & Complete'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Upload images to Firebase Storage and update booking
  Future<void> _uploadAndCompleteJob(StateSetter setDialogState) async {
    setDialogState(() {
      _isUploadingImages = true;
    });

    try {
      // Upload images to Firebase Storage
      List<String> imageUrls = [];
      // for (int i = 0; i < _completionImages.length; i++) {
      //   final XFile image = _completionImages[i];
      //   final String fileName =
      //       'completion_${widget.job.bookingId}_${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
      //   final Reference storageRef = FirebaseStorage.instance.ref().child(
      //     'completion_images/$fileName',
      //   );

      //   // Upload file
      //   final bytes = await image.readAsBytes();
      //   await storageRef.putData(bytes);

      //   // Get download URL
      //   final String downloadUrl = await storageRef.getDownloadURL();
      //   imageUrls.add(downloadUrl);
      // }

      // Update booking with completion images and status
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(widget.job.bookingId)
          .update({
            'completionImages': imageUrls,
            'status': 'awaiting_verification',
            'updatedAt': DateTime.now().millisecondsSinceEpoch,
          });

      // Get booking data to retrieve customer ID and job details
      final bookingDoc =
          await FirebaseFirestore.instance
              .collection('bookings')
              .doc(widget.job.bookingId)
              .get();

      if (bookingDoc.exists) {
        final bookingData = bookingDoc.data();
        final customerId = bookingData?['customerId'] as String?;
        final category = bookingData?['category'] as String? ?? 'your job';

        // Send notification to customer
        if (customerId != null) {
          await NotificationService.createWorkCompletedNotification(
            customerId: customerId,
            bookingId: widget.job.bookingId,
            jobTitle: category,
          );
        }
      }

      // Clear images and close dialog
      _completionImages.clear();
      if (mounted) {
        Navigator.pop(context);
        Get.back(); // Go back to previous screen

        Get.snackbar(
          'Success',
          'Job marked as complete. Waiting for customer verification.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to upload images: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setDialogState(() {
        _isUploadingImages = false;
      });
    }
  }

  BookingModel? _findBookingForJob(
    JobHistory job,
    JobHistoryPageController controller,
  ) {
    // Try to find in user bookings first
    for (final booking in controller.userBookings) {
      if (booking.category == job.category && booking.price == job.price) {
        return booking;
      }
    }

    // Then try trader bookings
    for (final booking in controller.traderBookings) {
      if (booking.category == job.category && booking.price == job.price) {
        return booking;
      }
    }

    return null;
  }

  Future<void> _showCustomerReviewDialog(BookingModel booking) async {
    int rating = 5;
    final reviewController = TextEditingController();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  title: const Text('Rate Customer'),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'How was your experience with this customer?',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 14),
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
                          borderColor: AppColor.grey,
                          hintStyle: TextStyle(color: AppColor.grey),
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
                        await _submitCustomerReview(
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

  Future<void> _submitCustomerReview(
    BookingModel booking,
    int rating,
    String review,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(booking.id)
          .update({
            'customerRating': rating,
            'customerReview': review,
            'updatedAt': DateTime.now().millisecondsSinceEpoch,
          });

      // Update customer's average rating
      await RatingService.updateCustomerRating(booking.userId);

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
}
