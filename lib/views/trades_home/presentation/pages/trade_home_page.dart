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

  Query<Map<String, dynamic>> _getQuery() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return FirebaseFirestore.instance.collection('bookings').limit(0);
    }

    final selectedDate = _jobController.selectedDate.value;

    Query<Map<String, dynamic>> query = FirebaseFirestore.instance
        .collection('bookings')
        .where('traderId', isEqualTo: currentUser.uid)
        .where(
          'status',
          whereIn: [
            'pending',
            'quoted',
            'accepted',
            'inProgress',
            'awaiting_verification',
          ],
        );

    // Filter by selected date if available
    if (selectedDate != null) {
      final startOfDay = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
      );
      final endOfDay = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        23,
        59,
        59,
      );

      query = query
          .where(
            'preferredTime',
            isGreaterThanOrEqualTo: startOfDay.millisecondsSinceEpoch,
          )
          .where(
            'preferredTime',
            isLessThanOrEqualTo: endOfDay.millisecondsSinceEpoch,
          );
    }

    return query
        .orderBy('preferredTime', descending: false)
        .orderBy('createdAt', descending: true);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => TraderWhoScaffold(
        appBar: TradeHomeAppBar(
          selectedDate: _jobController.selectedDate.value,
          onDateSelected: (DateTime selectedDate) {
            _jobController.setSelectedDate(selectedDate);
          },
          jobDates: _jobController.getJobDates(),
        ),
        body: _buildJobsList(),
      ),
    );
  }

  Widget _buildJobsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with "New Jobs" and "View All" button
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() {
                final selectedDateStr =
                    _jobController.selectedDate.value != null
                        ? "${_jobController.selectedDate.value!.day}/${_jobController.selectedDate.value!.month}/${_jobController.selectedDate.value!.year}"
                        : "Today";
                return CustomText(
                  text: 'Jobs for $selectedDateStr',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColor.primaryText,
                );
              }),
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
        ),
        kGap10,

        // Paginated jobs list
        Expanded(
          child: Obx(() {
            return PaginateFirestore(
              key: ValueKey(
                _jobController.selectedDate.value?.toString() ?? 'all',
              ),
              itemBuilder: (context, documentSnapshots, index) {
                final booking = BookingModel.fromFirestore(
                  documentSnapshots[index],
                );

                return FutureBuilder<JobHistory>(
                  future: _jobController.bookingToJobHistoryForUI(
                    booking,
                    isUserBooking: false,
                  ),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const SizedBox(
                        height: 100,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final job = snapshot.data!;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TradeHomeCard(
                        job: job,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      TradeJobHistoryDetailPage(job: job),
                            ),
                          );
                        },
                        onReject: () async {
                          final newStatus =
                              job.jobType == "largeJob"
                                  ? 'notInterested'
                                  : 'rejected';

                          if (booking.id != null) {
                            await _jobController.updateBookingStatus(
                              booking.id!,
                              newStatus,
                            );
                          }
                        },
                      ),
                    );
                  },
                );
              },
              query: _getQuery(),
              itemBuilderType: PaginateBuilderType.listView,
              isLive: true,
              onEmpty: Center(
                child: Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.work_off_outlined,
                        size: 64,
                        color: AppColor.secondaryText,
                      ),
                      const SizedBox(height: 16),
                      Obx(() {
                        final selectedDate = _jobController.selectedDate.value;
                        final isToday =
                            selectedDate != null &&
                            selectedDate.year == DateTime.now().year &&
                            selectedDate.month == DateTime.now().month &&
                            selectedDate.day == DateTime.now().day;

                        return CustomText(
                          text:
                              isToday
                                  ? 'No new jobs available for today'
                                  : 'No jobs scheduled for this date',
                          fontSize: 16,
                          color: AppColor.secondaryText,
                        );
                      }),
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
              ),
              onError:
                  (error) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error loading jobs',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColor.darkGray,
                              fontFamily: 'openSans',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              initialLoader: const Center(child: CircularProgressIndicator()),
              bottomLoader: const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              ),
              itemsPerPage: 10,
              shrinkWrap: false,
              physics: const AlwaysScrollableScrollPhysics(),
            );
          }),
        ),
      ],
    );
  }
}
