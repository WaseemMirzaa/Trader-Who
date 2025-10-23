part of 'pages.dart';

class JobHistoryPage extends StatefulWidget {
  const JobHistoryPage({super.key});

  @override
  State<JobHistoryPage> createState() => _JobHistoryPageState();
}

class _JobHistoryPageState extends State<JobHistoryPage> {
  final TextEditingController _searchController = TextEditingController();
  final JobHistoryPageController _controller = Get.put(
    JobHistoryPageController(),
  );

  @override
  void dispose() {
    _searchController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Query<Map<String, dynamic>> _getQuery(String tab) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return FirebaseFirestore.instance.collection('bookings').limit(0);
    }

    Query<Map<String, dynamic>> query = FirebaseFirestore.instance
        .collection('bookings')
        .where('userId', isEqualTo: currentUser.uid);

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
    final screenSize = MediaQuery.of(context).size;

    return TraderWhoScaffold(
      appBar: const JobHistoryAppbar(),
      body: SafeArea(
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
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.grey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Obx(
                            () => CustomToggleButton(
                              text: 'New Jobs',
                              isActive:
                                  _controller.selectedTab.value == 'New Jobs',
                              onTap: () {
                                _controller.setSelectedTab('New Jobs');
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Obx(
                            () => CustomToggleButton(
                              text: 'Completed',
                              isActive:
                                  _controller.selectedTab.value == 'Completed',
                              onTap: () {
                                _controller.setSelectedTab('Completed');
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Obx(() {
                    return PaginateFirestore(
                      key: ValueKey(_controller.selectedTab.value),

                      itemBuilder: (context, documentSnapshots, index) {
                        final booking = BookingModel.fromFirestore(
                          documentSnapshots[index],
                        );

                        return FutureBuilder<JobHistory>(
                          future: _controller.bookingToJobHistoryForUI(
                            booking,
                            isUserBooking: true,
                          ),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const SizedBox(
                                height: 100,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            final job = snapshot.data!;
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              child: JobHistoryCard(
                                job: job,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              JobHistoryDetailPage(job: job),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                      query: _getQuery(_controller.selectedTab.value),
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
                                'No ${_controller.selectedTab.value.toLowerCase()} found',
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
      ),
    );
  }
}
