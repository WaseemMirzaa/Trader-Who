part of 'pages.dart';

class JobHistoryPage extends StatefulWidget {
  const JobHistoryPage({super.key});

  @override
  State<JobHistoryPage> createState() => _JobHistoryPageState();
}

class _JobHistoryPageState extends State<JobHistoryPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<JobHistory> _allJobs = [
    JobHistory(
      title: 'Plumbing',
      svgIcon: Assets.svgsPlumbing,
      jobType: 'Plumbing',
      price: 50.0,
      preferredTime: 'Today,4:00-6:00 PM',
      address: '123 Main St, Springfield',
      status: 'Completed',
    ),
    JobHistory(
      title: 'Bathroom Installation',
      svgIcon: Assets.svgsPlumbing,
      jobType: 'Plumbing',
      price: 65.0,
      preferredTime: 'Afternoon',
      address: '456 Oak Ave, Springfield',
      status: 'Accepted',
    ),
    JobHistory(
      title: 'Pipe Leak Fix',
      svgIcon: Assets.svgsElectric,
      jobType: 'Electricity',
      price: 45.0,
      preferredTime: 'Evening',
      address: '789 Pine Rd, Springfield',
      status: 'Pending',
    ),
  ];
  List<JobHistory> _filteredJobs = [];

  @override
  void initState() {
    super.initState();
    _filteredJobs = _allJobs; // Initialize with all jobs
    _searchController.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearch);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    setState(() {
      final query = _searchController.text.toLowerCase();
      _filteredJobs = _allJobs.where((job) {
        return job.title.toLowerCase().contains(query);
      }).toList();
    });
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

    return Scaffold(
      backgroundColor: AppColor.lightPeach,
      appBar: const JobHistoryAppbar(),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenSize.width > 800
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
                  SearchBarTile(
                    controller: _searchController,
                    onSearch: _onSearch,
                    hintText: 'Search by job title',
                    width: double.infinity,
                  ),
                  const SizedBox(height: 25),
                  MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _filteredJobs.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _calculateCrossAxisCount(context),
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        childAspectRatio: 1.5,
                      ),
                      itemBuilder: (context, index) {
                        return JobHistoryCard(
                          job: _filteredJobs[index],
                          // onTap: () {
                          //   // Navigator.push(
                          //   //   context,
                          //   //   MaterialPageRoute(
                          //   //     builder: (context) => TradePersonDetailsPage(
                          //   //       job: _filteredJobs[index],
                          //   //     ),
                          //   //   ),
                          //   // );
                          // },
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
       bottomNavigationBar: const CustomNavBar(),
    );
  }
}