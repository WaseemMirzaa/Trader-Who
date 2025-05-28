part of 'pages.dart';

class TradeJobHistoryDetailPage extends StatefulWidget {
  final JobHistory job;

  const TradeJobHistoryDetailPage({super.key, required this.job});

  @override
  State<TradeJobHistoryDetailPage> createState() =>
      _TradeJobHistoryDetailPageState();
}

class _TradeJobHistoryDetailPageState extends State<TradeJobHistoryDetailPage> {
  void _showReassessBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: false,
      backgroundColor: Colors.transparent,
      builder:
          (context) => TradeJobHistoryBottomSheet(
            title: 'Job Reassessment Submitted',
            description: 'Please provide updated price and reason',
            priceController: TextEditingController(),
            reasonController: TextEditingController(),
            onSubmit: () {
              Navigator.pop(context);
            },
          ),
    );
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
              IntrinsicWidth(
                child: CustomButton(
                  text: 'Accept',
                  onTap: _showReassessBottomSheet,
                  color: AppColor.darkBlue,
                  textColor: AppColor.white,
                  height: 50,
                  radius: 30,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              kGap10, // Your predefined spacing widget
              Expanded(
                child: CustomButton(
                  text: 'Reassess Quote',
                  onTap: _showReassessBottomSheet,
                  color: AppColor.orangecustomColor,
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
        Container(
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
          style: TextStyle(fontSize: 14, color: AppColor.darkGray),
        ),
        const SizedBox(height: 8),
        Text(
          'Jason Rao',
          style: TextStyle(
            fontSize: 14,
            color: AppColor.black,
            fontStyle: FontStyle.normal,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = widget.job.status.toLowerCase() == 'completed';

    return GradientScaffold(
      appBar: TradeJobHistoryDetailAppbar(status: widget.job.status),
      body: Column(
        children: [
          // Scrollable main content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
                                color: AppColor.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
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
                                          text: 'Small Job - Fixed Price: ',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: AppColor.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '£${widget.job.price}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: AppColor.darkerGray,
                                          ),
                                        ),
                                      ],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
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
                          border: Border.all(color: AppColor.white, width: 0),
                        ),
                        child: Text(
                          widget.job.status,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColor.green,
                            fontWeight: FontWeight.w500,
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
                                color: AppColor.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: widget.job.preferredTime,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColor.darkerGray,
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
                    'Description',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColor.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.job.tradesPerson.description ??
                        'No description available',
                    style: TextStyle(fontSize: 14, color: AppColor.darkerGray),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          Assets.imagesPipe,
                          width: 70,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      kGap10,
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          Assets.imagesPipe,
                          width: 70,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      kGap10,
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          Assets.imagesPipe,
                          width: 70,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                  // Images Row (only show for completed jobs)
                  if (isCompleted) ...[kGap10],
                  // Location and Map
                  const SizedBox(height: 20),
                  CustomText(
                    text: 'Location',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: AppColor.black,
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
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Address: ',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColor.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: widget.job.address,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColor.darkerGray,
                              ),
                            ),
                          ],
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
                          target: LatLng(33.6844, 73.0479),
                          zoom: 15.0,
                        ),
                        markers: {
                          Marker(
                            markerId: const MarkerId('job_location'),
                            position: LatLng(33.6844, 73.0479),
                            infoWindow: InfoWindow(title: widget.job.address),
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
                        color: AppColor.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    kGap10,
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
                    Text(
                      'He always give me a perfect service.',
                      style: TextStyle(fontSize: 14, color: AppColor.darkGray),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Jason Rao',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColor.black,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ],
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
          // Bottom action bar (only for non-completed jobs)
          if (!isCompleted)
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
              child: _buildNewJobFooter(),
            ),
        ],
      ),
    );
  }
}
