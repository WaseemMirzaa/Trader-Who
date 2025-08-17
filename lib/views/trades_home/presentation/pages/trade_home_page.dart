part of 'pages.dart';

class TradeHomePage extends StatefulWidget {
  const TradeHomePage({super.key});

  @override
  State<TradeHomePage> createState() => _TradeHomePageState();
}

class _TradeHomePageState extends State<TradeHomePage> {
  late JobHistoryPageController _jobController;

  @override
  void initState() {
    super.initState();
    // Initialize the job history controller if not already registered
    if (!Get.isRegistered<JobHistoryPageController>()) {
      Get.put(JobHistoryPageController());
    }
    _jobController = Get.find<JobHistoryPageController>();
  }

  @override
  Widget build(BuildContext context) {
    return TraderWhoScaffold(
      appBar: TradeHomeAppBar(),
      body: Obx(() {
        if (_jobController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Get new jobs (not completed) for the trader
        final newJobs =
            _jobController.jobHistoryItems
                .where(
                  (job) =>
                      job.status != 'completed' && job.status != 'cancelled',
                )
                .take(5) // Show only first 5 jobs on home page
                .toList();

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with "New Jobs" and "View All" button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomText(
                      text: 'New Jobs',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColor.primaryText,
                    ),
                    TextButton(
                      onPressed: () {
                        Get.put(NavigationController()).changePage(1);
                        Get.put(NavigationController()).update();
                        Get.find<JobHistoryPageController>().fetchBookings();
                      },
                      child: CustomText(
                        text: 'View All',
                        color: AppColor.primaryButton,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                kGap10,

                // Check if there are any jobs
                if (newJobs.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.work_off_outlined,
                            size: 64,
                            color: AppColor.secondaryText,
                          ),
                          const SizedBox(height: 16),
                          CustomText(
                            text: 'No new jobs available',
                            fontSize: 16,
                            color: AppColor.secondaryText,
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () {
                              _jobController.refreshBookings();
                            },
                            child: CustomText(
                              text: 'Refresh',
                              color: AppColor.primaryButton,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  // GridView of job cards
                  GridView.builder(
                    shrinkWrap: true, // Important for nested scrolling
                    physics:
                        const NeverScrollableScrollPhysics(), // Disable inner scrolling
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          childAspectRatio: 1.7,
                          mainAxisSpacing: 10,
                        ),
                    itemCount: newJobs.length,
                    itemBuilder: (context, index) {
                      return TradeHomeCard(
                        job: newJobs[index],
                        onTap: () {
                          // Handle card tap - navigate to job detail
                        },
                        onAccept: () async {
                          // Handle job acceptance
                          final job = newJobs[index];
                          final booking = _findBookingForJob(job);
                          if (booking != null) {
                            await _jobController.updateBookingStatus(
                              booking.id ?? '',
                              'accepted',
                            );
                          }
                        },
                        onReject: () async {
                          // Handle job rejection
                          final job = newJobs[index];
                          final booking = _findBookingForJob(job);
                          if (booking != null) {
                            await _jobController.updateBookingStatus(
                              booking.id ?? '',
                              'rejected',
                            );
                          }
                        },
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }

  /// Helper method to find the corresponding BookingModel for a JobHistory
  BookingModel? _findBookingForJob(JobHistory job) {
    // Try to find in trader bookings first (since this is trader home page)
    for (final booking in _jobController.traderBookings) {
      if (booking.category == job.jobType && booking.price == job.price) {
        return booking;
      }
    }

    // Then try user bookings if needed
    for (final booking in _jobController.userBookings) {
      if (booking.category == job.jobType && booking.price == job.price) {
        return booking;
      }
    }

    return null;
  }
}
