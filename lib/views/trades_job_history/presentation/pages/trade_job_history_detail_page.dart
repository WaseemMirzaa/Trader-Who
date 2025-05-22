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
      backgroundColor: Colors.transparent,
      builder:
          (context) => TradeJobHistoryBottomSheet(
            title: 'Job Reassessment Submitted',
            description: 'Please provide updated price and reason',
            priceController: TextEditingController(),
            reasonController: TextEditingController(),
            onSubmit: () {
              Navigator.pop(context); // Just close the bottom sheet
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: TradeJobHistoryDetailAppbar(),
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
                                Image.asset(
                                  Assets.imagesPounds,
                                  width: 16,
                                  height: 16,
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    'Small Job - Fixed Price: £${widget.job.price}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColor.darkGray,
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
                          color: AppColor.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColor.midGray, width: 1),
                        ),
                        child: Text(
                          widget.job.status,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColor.green,
                            fontWeight: FontWeight.bold,
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
                                color: AppColor.darkGray,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: widget.job.preferredTime,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColor.darkGray,
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
                      fontWeight: FontWeight.bold,
                      color: AppColor.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.job.tradesPerson.description ??
                        'No description available',
                    style: TextStyle(fontSize: 14, color: AppColor.darkGray),
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
                  kGap10,
                  // Tradesperson, Location, and Map
                  ...[const SizedBox(height: 12), const SizedBox(height: 20)],
                  CustomText(
                    text: 'Location',
                    fontWeight: FontWeight.bold,
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
                                color: AppColor.darkGray,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: widget.job.address,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColor.darkGray,
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
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
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
                        scrollGesturesEnabled: false,
                        tiltGesturesEnabled: false,
                        rotateGesturesEnabled: false,
                      ),
                    ),
                  ),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'Accept',
                          onTap: () {
                            _showReassessBottomSheet();
                          },
                          color: AppColor.darkBlue,
                          textColor: AppColor.white,
                          height: 50,
                          radius: 30,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      kGap10,
                      Expanded(
                        child: CustomButton(
                          text: 'Reassess Quote',
                          onTap: () {
                            _showReassessBottomSheet();
                          },
                          color: AppColor.orangecustomColor,
                          textColor: AppColor.white,
                          enableBorder: true,
                          height: 50,
                          radius: 30,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                CustomButton(
                  text: ' \\',
                  onTap: () {
                    _showReassessBottomSheet();
                  },
                  color: AppColor.darkBlue,
                  textColor: AppColor.white,
                  height: 50,
                  width: 50,
                  radius: 30,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
