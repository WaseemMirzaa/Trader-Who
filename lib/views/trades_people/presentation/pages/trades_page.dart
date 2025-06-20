part of 'pages.dart';

class TradesPage extends StatefulWidget {
  const TradesPage({super.key});

  @override
  State<TradesPage> createState() => _TradesPageState();
}

class _TradesPageState extends State<TradesPage> {
  final TextEditingController _searchController = TextEditingController();
  List<TradesPerson> _tradesPeople = []; // Empty list initially
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTradesPeople();
  }

  Future<void> _loadTradesPeople() async {
    // Simulate network call
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _tradesPeople = []; // Empty list to simulate no data

      _tradesPeople = [
        TradesPerson(
          name: 'James Michael',
          expertise: 'Electrician',
          description:
              'Leaking kitchen sink, Pipe may be cracked. Water dripping into cabinet below.Happened after turning on garbage disposal.',
          price: '50',
          imageUrl: Assets.imagesTradeJames,
          rating: 4.5,
          services: ['Electrician', 'Plumber'],
        ),
        TradesPerson(
          name: 'David William',
          expertise: 'Plumber',
          description:
              'Leaking kitchen sink, Pipe may be cracked. Water dripping into cabinet below.Happened after turning on garbage disposal.',
          price: '65',
          imageUrl: Assets.imagesTradeDavid,
          rating: 4.8,
          services: ['Electrician', 'Gas Eng'],
        ),
        TradesPerson(
          name: 'Richard Joseph',
          expertise: 'Plumber',
          description:
              'Leaking kitchen sink, Pipe may be cracked. Water dripping into cabinet below.Happened after turning on garbage disposal.',
          price: '65',
          imageUrl: Assets.imagesTradeRichard,
          rating: 4.0,
          services: ['Roof Maker', 'Socket Changer'],
        ),
        // ... other sample data
      ];

      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    debugPrint('Searching for: ${_searchController.text}');
    // Add search functionality here
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
    return TraderWhoScaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Only show search bar when there are tradespeople
                if (!_isLoading && _tradesPeople.isNotEmpty)
                  Column(
                    children: [
                      SearchBarTile(
                        controller: _searchController,
                        onSearch: _onSearch,
                        hintText: 'Search by names',
                        width: double.infinity,
                      ),
                      const SizedBox(height: 25),
                    ],
                  ),

                if (_isLoading)
                  Center(
                    child: CircularProgressIndicator(
                      color: AppColor.primaryButton,
                    ),
                  )
                else if (_tradesPeople.isEmpty)
                  Column(
                    children: [
                      SizedBox(height: 50),
                      Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 80,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 15),
                            CustomText(
                              text: 'No tradespeople available',
                              fontSize: 18,
                              color: AppColor.primaryText,
                              fontWeight: FontWeight.w500,
                            ),
                            SizedBox(height: 10),
                            CustomText(
                              text:
                                  'We couldn\'t find any tradespeople matching your criteria',
                              textAlign: TextAlign.center,

                              fontSize: 14,
                              color: AppColor.secondaryText,
                            ),
                            SizedBox(height: 30),
                            CustomButton(
                              text: 'Post a Custom Job Request',
                              onTap: () {
                                // Navigate to job posting page
                                Get.toNamed(AppRoutes.customJobPost);
                              },
                              width: MediaQuery.of(context).size.width * 0.8,
                              color: AppColor.primaryButton,
                              textColor: Colors.white,
                              radius: 25,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                else
                  Column(
                    children: [
                      MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _tradesPeople.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: _calculateCrossAxisCount(
                                  context,
                                ),
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 17,
                                childAspectRatio: 1.8,
                              ),
                          itemBuilder: (context, index) {
                            return TradesPeopleCard(
                              person: _tradesPeople[index],
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => TradePersonDetailsPage(
                                          person: _tradesPeople[index],
                                        ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 30),
                      Center(
                        child: CustomButton(
                          text: 'Post a Custom Job Request',
                          onTap: () {
                            // Navigate to job posting page
                            Get.toNamed(AppRoutes.customJobPost);
                          },
                          width: MediaQuery.of(context).size.width * 0.8,
                          color: AppColor.primaryButton,
                          textColor: Colors.white,
                          radius: 25,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
