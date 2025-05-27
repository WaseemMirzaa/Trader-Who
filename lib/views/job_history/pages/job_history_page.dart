part of 'pages.dart';

class JobHistoryPage extends StatefulWidget {
  const JobHistoryPage({super.key});

  @override
  State<JobHistoryPage> createState() => _JobHistoryPageState();
}

class _JobHistoryPageState extends State<JobHistoryPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedTab = 'New Jobs';
  final List<JobHistory> _allJobs = [
    JobHistory(
      title: 'Plumbing',
      svgIcon: Assets.svgsPlumbing,
      jobType: 'Plumbing',
      price: 50.0,
      preferredTime: 'Today,4:00-6:00 PM',
      address: '123 Main St, Springfield',
      status: 'Accepted',
      tradesPerson: TradesPerson(
        expertise: 'Plumber',
        description:
            'Leaking kitchen sink, Pipe may be cracked. Water  dripping into cabinet below. Happened after  turning on  garbage disposal.',
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
      status: 'Waiting for porposal',
      tradesPerson: TradesPerson(
        expertise: 'Electrical',
        description:
            'Leaking kitchen sink, Pipe may be cracked. Water \n dripping into cabinet below. Happened after  turning on  garbage disposal.',
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
      status: 'Completed', // Changed to Completed for testing
      tradesPerson: TradesPerson(
        expertise: 'Electrical',
        description:
            'Leaking kitchen sink, Pipe may be cracked. Water \n dripping into cabinet below. Happened after  turning on  garbage disposal.',
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
    _filteredJobs = _allJobs.where((job) => job.status != 'Completed').toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
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

    return GradientScaffold(
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
                          color: Colors.black.withOpacity(0.1),
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
                            isActive: _selectedTab == 'New Jobs',
                            onTap: () {
                              setState(() {
                                _selectedTab = 'New Jobs';
                                _filteredJobs =
                                    _allJobs
                                        .where(
                                          (job) => job.status != 'Completed',
                                        )
                                        .toList();
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: CustomToggleButton(
                            text: 'Completed',
                            isActive: _selectedTab == 'Completed',
                            onTap: () {
                              setState(() {
                                _selectedTab = 'Completed';
                                _filteredJobs =
                                    _allJobs
                                        .where(
                                          (job) => job.status == 'Completed',
                                        )
                                        .toList();
                              });
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
                            'No ${_selectedTab.toLowerCase()} found',
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
                          itemCount: _filteredJobs.length,
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
                              job: _filteredJobs[index],
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => JobHistoryDetailPage(
                                          job: _filteredJobs[index],
                                        ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
