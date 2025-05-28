part of 'pages.dart';

class TradesJobHistoryPage extends StatefulWidget {
  const TradesJobHistoryPage({super.key});

  @override
  State<TradesJobHistoryPage> createState() => _TradesJobHistoryPageState();
}

class _TradesJobHistoryPageState extends State<TradesJobHistoryPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<JobHistory> _allJobs = [
    JobHistory(
      title: 'Plumbing',
      svgIcon: Assets.svgsPlumbing,
      jobType: 'Plumbing',
      price: 50.0,
      preferredTime: 'Today,4:00-6:00 PM',
      address: '123 Main St, Springfield',
      status: 'New',
      showQuoteButtons: false,
      tradesPerson: TradesPerson(
        expertise: 'Plumber',
        description:
            'Leaking kitchen sink, Pipe may be cracked. Water  dripping into cabinet below. Happened after turning on garbage disposal.',
        name: 'John Smith',
        imageUrl: 'path_to_image',
        price: '50',
        rating: 4.0,
      ),
    ),
    JobHistory(
      title: 'Electrical',
      svgIcon: Assets.svgsElectric,
      jobType: 'Plumbing',
      price: 65.0,
      preferredTime: 'Today,4:00-6:00 PM',
      address: '456 Oak Ave, Springfield',
      status: 'New',
      showQuoteButtons: true,
      tradesPerson: TradesPerson(
        expertise: 'Electrical',
        description:
            'Leaking kitchen sink, Pipe may be cracked. Water \n dripping into cabinet below. Happened after turning on garbage disposal.',
        name: 'David',
        imageUrl: 'path_to_image',
        price: '',
        rating: 0.0,
      ),
    ),
    JobHistory(
      title: 'Electrical',
      svgIcon: Assets.svgsElectric,
      jobType: 'Electricity',
      price: 45.0,
      preferredTime: 'Today,4:00-6:00 PM',
      address: '789 Pine Rd, Springfield',
      status: 'Completed',
      showQuoteButtons: true,
      tradesPerson: TradesPerson(
        expertise: 'Electrical',
        description:
            'Leaking kitchen sink, Pipe may be cracked. Water \n dripping into cabinet below. Happened after turning on garbage disposal.',
        name: 'Sofiya',
        imageUrl: Assets.imagesField,
        price: '60',
        rating: 4.5,
      ),
    ),
  ];
  List<JobHistory> _filteredJobs = [];

  @override
  void initState() {
    super.initState();
    // Ensure controller is initialized
    if (!Get.isRegistered<TradeJobHistoryController>()) {
      Get.put(TradeJobHistoryController());
    }
    final controller = Get.find<TradeJobHistoryController>();
    _filteredJobs =
        _allJobs
            .where(
              (job) =>
                  controller.selectedTab.value == 'New Jobs'
                      ? job.status != 'Completed'
                      : job.status == 'Completed',
            )
            .toList();
    controller.selectedTab.listen((tab) {
      setState(() {
        _filteredJobs =
            _allJobs
                .where(
                  (job) =>
                      tab == 'New Jobs'
                          ? job.status != 'Completed'
                          : job.status == 'Completed',
                )
                .toList();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TradeJobHistoryController>();
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
                Container(
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
                          isActive: controller.selectedTab.value == 'New Jobs',
                          onTap: () {
                            controller.setTab('New Jobs');
                          },
                        ),
                      ),
                      Expanded(
                        child: CustomToggleButton(
                          text: 'Completed',
                          isActive: controller.selectedTab.value == 'Completed',
                          onTap: () {
                            controller.setTab('Completed');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                _filteredJobs.isEmpty
                    ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          'No ${controller.selectedTab.value.toLowerCase()} found',
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
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _filteredJobs.length,
                        itemBuilder: (context, index) {
                          final job = _filteredJobs[index];
                          return TradeHomeCard(
                            job: job,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => TradeJobHistoryDetailPage(
                                        job: _filteredJobs[index],
                                      ),
                                ),
                              );
                            },
                            onReject: () {
                              setState(() {
                                if (job.showQuoteButtons) {
                                  _filteredJobs[index] = _filteredJobs[index]
                                      .copyWith(status: 'Not Interested');
                                } else {
                                  _filteredJobs[index] = _filteredJobs[index]
                                      .copyWith(status: 'Rejected');
                                }
                                if (controller.selectedTab.value ==
                                        'New Jobs' &&
                                    _filteredJobs[index].status != 'New') {
                                  _filteredJobs.removeAt(index);
                                }
                              });
                            },
                            onAccept: () {
                              setState(() {
                                if (job.showQuoteButtons) {
                                  _filteredJobs[index] = _filteredJobs[index]
                                      .copyWith(status: 'Quoted');
                                } else {
                                  _filteredJobs[index] = _filteredJobs[index]
                                      .copyWith(status: 'Accepted');
                                }
                                if (controller.selectedTab.value ==
                                        'New Jobs' &&
                                    _filteredJobs[index].status != 'New') {
                                  _filteredJobs.removeAt(index);
                                }
                              });
                            },
                          );
                        },
                        separatorBuilder:
                            (context, index) => const SizedBox(
                              height: 16,
                            ), // Add gap between cards
                      ),
                    ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
