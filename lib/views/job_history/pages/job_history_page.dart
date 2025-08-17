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

  int _calculateCrossAxisCount(BuildContext context) {
    return MediaQuery.of(context).size.width > 800
        ? 3
        : MediaQuery.of(context).size.width > 600
        ? 2
        : 1;
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
            child: RefreshIndicator(
              onRefresh: () => _controller.refreshBookings(),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width * 0.03,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
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
                                    _controller.selectedTab.value ==
                                    'Completed',
                                onTap: () {
                                  _controller.setSelectedTab('Completed');
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    Obx(() {
                      if (_controller.isLoading.value) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final filteredJobs = _controller.getFilteredJobs(
                        _controller.selectedTab.value,
                      );

                      return filteredJobs.isEmpty
                          ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                'No ${_controller.selectedTab.value.toLowerCase()} found',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColor.darkGray,
                                ),
                              ),
                            ),
                          )
                          : MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: filteredJobs.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: _calculateCrossAxisCount(
                                      context,
                                    ),
                                    crossAxisSpacing: 15,
                                    mainAxisSpacing: 15,
                                    childAspectRatio: 2,
                                  ),
                              itemBuilder: (context, index) {
                                return JobHistoryCard(
                                  job: filteredJobs[index],
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => JobHistoryDetailPage(
                                              job: filteredJobs[index],
                                            ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          );
                    }),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
