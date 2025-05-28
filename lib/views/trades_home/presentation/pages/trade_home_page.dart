part of 'pages.dart';

class TradeHomePage extends StatefulWidget {
  const TradeHomePage({super.key});

  @override
  State<TradeHomePage> createState() => _TradeHomePageState();
}

class _TradeHomePageState extends State<TradeHomePage> {
  final List<JobHistory> jobs = [
    JobHistory(
      title: 'Plumbing',
      svgIcon: Assets.svgsPlumbing,
      jobType: 'Plumbing',
      price: 50.0,
      preferredTime: 'Today, 4:00-6:00 PM',
      address: '123 Main St, Springfield',
      status: 'New',
      tradesPerson: TradesPerson(
        expertise: 'Plumber',
        description:
            'Leaking kitchen sink, Pipe may be cracked. Water dripping into cabinet below. Happened after turning on garbage disposal.',
        name: 'John Smith',
        imageUrl: 'path_to_image',
        price: '50',
        rating: 4.0,
      ),
    ),
    // Add more jobs as needed
  ];

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: TradeHomeAppBar(),
      body: SingleChildScrollView(
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
                    color: AppColor.black,
                  ),
                  TextButton(
                    onPressed: () {
                      // Handle view all action
                    },
                    child: CustomText(
                      text: 'View All',
                      color: AppColor.orangecustomColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              kGap10,

              // GridView of job cards
              GridView.builder(
                shrinkWrap: true, // Important for nested scrolling
                physics:
                    const NeverScrollableScrollPhysics(), // Disable inner scrolling
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 1.7,
                  mainAxisSpacing: 10,
                ),
                itemCount: jobs.length,
                itemBuilder: (context, index) {
                  return TradeHomeCard(
                    job: jobs[index],
                    onTap: () {
                      // Handle card tap
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
