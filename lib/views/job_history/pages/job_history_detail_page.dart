part of 'pages.dart';

class JobHistoryDetailPage extends StatefulWidget {
  final JobHistory job;

  const JobHistoryDetailPage({super.key, required this.job});

  @override
  State<JobHistoryDetailPage> createState() => _JobHistoryDetailPageState();
}

class _JobHistoryDetailPageState extends State<JobHistoryDetailPage> {
  String? _categoryName;

  @override
  void initState() {
    super.initState();
    _loadCategoryName();
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
                  const SizedBox(height: 80), // Padding for bottom content
                ],
              ),
            ),
          ),
          // Bottom action bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                      onTap: () {
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => const FeedbackScreen(),
                        //   ),
                        // );
                      },
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
                              color: AppColor.darkBlue, // Dark blue background
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
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color:
                                AppColor.primaryButton, // Dark blue background
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
                      ],
                    ),
          ),
        ],
      ),
    );
  }
}
