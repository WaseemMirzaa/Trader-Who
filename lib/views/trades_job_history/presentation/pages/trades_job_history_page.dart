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

  Query<Map<String, dynamic>> _getQuery(String tab) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return FirebaseFirestore.instance.collection('bookings').limit(0);
    }

    Query<Map<String, dynamic>> query = FirebaseFirestore.instance
        .collection('bookings')
        .where('traderId', isEqualTo: currentUser.uid);

    if (tab == 'Completed') {
      query = query.where('status', isEqualTo: 'completed');
    } else {
      query = query.where(
        'status',
        whereIn: [
          'pending',
          'quoted',
          'accepted',
          'inProgress',
          'awaiting_verification',
        ],
      );
    }

    return query.orderBy('createdAt', descending: true);
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
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width * 0.03,
                  vertical: 20,
                ),
                child: Obx(
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
              ),
              Expanded(
                child: Obx(() {
                  return PaginateFirestore(
                    key: ValueKey(tradeController.selectedTab.value),
                    itemBuilder: (context, documentSnapshots, index) {
                      final booking = BookingModel.fromFirestore(
                        documentSnapshots[index],
                      );

                      return FutureBuilder<JobHistory>(
                        future: jobHistoryController.bookingToJobHistoryForUI(
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
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
                                    job.jobType != "smallJob"
                                        ? 'notInterested'
                                        : 'rejected';

                                final bookingDoc = booking;
                                if (bookingDoc.id != null) {
                                  await jobHistoryController
                                      .updateBookingStatus(
                                        bookingDoc.id!,
                                        newStatus,
                                      );
                                }
                              },
                            ),
                          );
                        },
                      );
                    },
                    query: _getQuery(tradeController.selectedTab.value),
                    itemBuilderType: PaginateBuilderType.listView,
                    isLive: true,
                    onEmpty: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                    initialLoader: const Center(
                      child: CircularProgressIndicator(),
                    ),
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
          ),
        ),
      ),
    );
  }
}
