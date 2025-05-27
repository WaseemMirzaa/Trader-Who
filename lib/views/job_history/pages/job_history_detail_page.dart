part of 'pages.dart';

class JobHistoryDetailPage extends StatefulWidget {
  final JobHistory job;

  const JobHistoryDetailPage({super.key, required this.job});

  @override
  State<JobHistoryDetailPage> createState() => _JobHistoryDetailPageState();
}

class _JobHistoryDetailPageState extends State<JobHistoryDetailPage> {
  @override
  Widget build(BuildContext context) {
    final isWaitingForProposal = widget.job.status == 'Waiting for porposal';

    return GradientScaffold(
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
                              widget.job.title,
                              style: const TextStyle(
                                color: AppColor.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
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
                                            fontWeight: FontWeight.w500,
                                            color: AppColor.black,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '£${widget.job.price}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                AppColor
                                                    .darkerGray, // Or any other color you prefer
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
                          widget.job.status,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColor.black,
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
                    style: TextStyle(fontSize: 13, color: AppColor.darkerGray),
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
                  // Conditionally show Tradesperson, Location, and Map
                  if (!isWaitingForProposal) ...[
                    // Tradesperson Section
                    ...[
                      const SizedBox(height: 12),
                      TradesPeopleCard(person: widget.job.tradesPerson),
                      const SizedBox(height: 20),
                    ],
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
                                  color: AppColor.darkGray,
                                  fontWeight: FontWeight.w500,
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
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const FeedbackScreen(),
                          ),
                        );
                      },
                      height: 45,
                      color: AppColor.darkBlue,
                      textColor: Colors.white,
                      fontWeight: FontWeight.bold,
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
                            color: AppColor.darkBlue,
                            textColor: Colors.white,
                            fontWeight: FontWeight.bold,
                            radius: 25,
                          ),
                        ),
                        kGap10,
                        Container(
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
                        kGap10,
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color:
                                AppColor
                                    .orangecustomColor, // Dark blue background
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
