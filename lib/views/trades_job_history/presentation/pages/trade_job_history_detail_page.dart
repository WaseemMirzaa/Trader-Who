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
                                // Update status in Firebase
                                final newStatus =
                                    widget.job.showQuoteButtons
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
            final booking = _findBookingForJob(
              widget.job,
              jobHistoryPageController,
            );
            if (booking != null) {
              await jobHistoryPageController.updateBookingStatus(
                booking.id ?? '',
                widget.job.jobType == "largeJob" ? "notInterested" : 'rejected',
              );
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

  Widget _buildCompletedJobFooter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Custom Feedback',
          style: TextStyle(
            fontSize: 16,
            color: AppColor.black,
            fontWeight: FontWeight.w500,
            fontFamily: 'openSans',
          ),
        ),
        kGap10, // Rating stars
        Row(
          children: List.generate(5, (index) {
            return Icon(
              Icons.star,
              color:
                  index < widget.job.tradesPerson.rating.floor()
                      ? Colors.amber
                      : Colors.grey,
              size: 24,
            );
          }),
        ),
        const SizedBox(height: 12),

        // Feedback text
        const SizedBox(height: 8),
        Text(
          'He always give me a perfect service.',
          style: TextStyle(
            fontSize: 14,
            color: AppColor.secondaryText,
            fontFamily: 'openSans',
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Jason Rao',
          style: TextStyle(
            fontSize: 14,
            color: AppColor.primaryText,
            fontStyle: FontStyle.normal,
            fontFamily: 'openSans',
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
        if (snapshot.hasData && snapshot.data?.data() != null) {
          final data = snapshot.data!.data() as Map<String, dynamic>;
          currentStatus = data['status'] ?? widget.job.status;
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
                      // Feedback Section (only for completed jobs)
                      if (isCompleted) ...[
                        const SizedBox(height: 20),
                        Text(
                          'Custom Feedback',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColor.primaryText,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'openSans',
                          ),
                        ),
                        kGap10,
                        if (widget.job.rating != null && widget.job.rating! > 0)
                          Row(
                            children: List.generate(5, (index) {
                              return Icon(
                                Icons.star,
                                color:
                                    index < widget.job.rating!.floor()
                                        ? Colors.amber
                                        : Colors.grey,
                                size: 24,
                              );
                            }),
                          ),
                        const SizedBox(height: 12),
                        Text(
                          widget.job.review ?? 'No feedback provided.',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColor.secondaryText,
                            fontFamily: 'openSans',
                          ),
                        ),
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
                  child: CustomButton(
                    text: 'Start Working',
                    onTap: () async {
                      // Update job status to inProgress
                      await jobHistoryPageController.updateBookingStatus(
                        widget.job.bookingId,
                        'inProgress',
                      );
                      Get.back();
                    },
                    color: AppColor.green,
                    textColor: AppColor.white,
                    height: 50,
                    radius: 30,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
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
                    onTap: () async {
                      // Update job status to completed
                      await jobHistoryPageController.updateBookingStatus(
                        widget.job.bookingId,
                        'completed',
                      );
                      Get.back();
                    },
                    color: AppColor.green,
                    textColor: AppColor.white,
                    height: 50,
                    radius: 30,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ); // Close TraderWhoScaffold
      }, // Close StreamBuilder builder
    ); // Close StreamBuilder
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
}
