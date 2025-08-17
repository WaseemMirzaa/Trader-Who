part of 'pages.dart';

class TradesJobHistoryPage extends StatefulWidget {
  const TradesJobHistoryPage({super.key});

  @override
  State<TradesJobHistoryPage> createState() => _TradesJobHistoryPageState();
}

class _TradesJobHistoryPageState extends State<TradesJobHistoryPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Ensure controllers are initialized
    if (!Get.isRegistered<TradeJobHistoryController>()) {
      Get.put(TradeJobHistoryController());
    }
    if (!Get.isRegistered<JobHistoryPageController>()) {
      Get.put(JobHistoryPageController());
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tradeController = Get.find<TradeJobHistoryController>();
    final jobHistoryController = Get.find<JobHistoryPageController>();
    final screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth:
                screenSize.width > 800
                    ? 1200
                    : screenSize.width > 600
                    ? 800
                    : screenSize.width * 0.99,
            minHeight: screenSize.height,
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: screenSize.width * 0.03,
              vertical: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          // ignore: deprecated_member_use
                          color: AppColor.grey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomToggleButton(
                            text: 'New Jobs',
                            isActive:
                                tradeController.selectedTab.value == 'New Jobs',
                            onTap: () {
                              tradeController.setTab('New Jobs');
                            },
                          ),
                        ),
                        Expanded(
                          child: CustomToggleButton(
                            text: 'Completed',
                            isActive:
                                tradeController.selectedTab.value ==
                                'Completed',
                            onTap: () {
                              tradeController.setTab('Completed');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Obx(() {
                  if (jobHistoryController.isLoading.value) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(50.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  // Filter jobs based on selected tab
                  final allJobs = jobHistoryController.jobHistoryItems;
                  final filteredJobs =
                      allJobs
                          .where(
                            (job) =>
                                tradeController.selectedTab.value == 'New Jobs'
                                    ? job.status != 'completed'
                                    : job.status == 'completed',
                          )
                          .toList();

                  if (filteredJobs.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.work_off_outlined,
                              size: 64,
                              color: AppColor.secondaryText,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No ${tradeController.selectedTab.value.toLowerCase()} found',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColor.secondaryText,
                                fontFamily: 'openSans',
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () {
                                jobHistoryController.refreshBookings();
                              },
                              child: Text(
                                'Refresh',
                                style: TextStyle(
                                  color: AppColor.primaryButton,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredJobs.length,
                      itemBuilder: (context, index) {
                        final job = filteredJobs[index];
                        return TradeHomeCard(
                          job: job,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => TradeJobHistoryDetailPage(
                                      job: filteredJobs[index],
                                    ),
                              ),
                            );
                          },
                          onReject: () async {
                            // Update status in Firebase
                            final newStatus =
                                job.showQuoteButtons
                                    ? 'Not Interested'
                                    : 'Rejected';

                            // Find the corresponding booking and update it
                            final booking = _findBookingForJob(
                              job,
                              jobHistoryController,
                            );
                            if (booking != null) {
                              await jobHistoryController.updateBookingStatus(
                                booking.id ?? '',
                                newStatus.toLowerCase(),
                              );
                            }
                          },
                          onAccept: () async {
                            // Update status in Firebase
                            final newStatus =
                                job.showQuoteButtons ? 'Quoted' : 'Accepted';

                            // Find the corresponding booking and update it
                            final booking = _findBookingForJob(
                              job,
                              jobHistoryController,
                            );
                            if (booking != null) {
                              await jobHistoryController.updateBookingStatus(
                                booking.id ?? '',
                                newStatus.toLowerCase(),
                              );
                            }
                          },
                        );
                      },
                      separatorBuilder:
                          (context, index) => const SizedBox(height: 16),
                    ),
                  );
                }),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Helper method to find the corresponding BookingModel for a JobHistory
  BookingModel? _findBookingForJob(
    JobHistory job,
    JobHistoryPageController controller,
  ) {
    // Try to find in user bookings first
    for (final booking in controller.userBookings) {
      if (booking.category == job.jobType && booking.price == job.price) {
        return booking;
      }
    }

    // Then try trader bookings
    for (final booking in controller.traderBookings) {
      if (booking.category == job.jobType && booking.price == job.price) {
        return booking;
      }
    }

    return null;
  }
}
