part of 'pages.dart';

class TradesPage extends StatefulWidget {
  const TradesPage({super.key});

  @override
  State<TradesPage> createState() => _TradesPageState();
}

class _TradesPageState extends State<TradesPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<TradesPerson> _tradesPeople = [
    TradesPerson(
      name: 'James Michael',
      expertise: 'Electrician',
      description:
          'Leaking kitchen sink, Pipe may be cracked. Water \n dripping into cabinet below. Happened after  turning on \n garbage disposal.',
      price: '50',
      imageUrl: Assets.imagesChatAvatar,
      rating: 4.5,
    ),
    TradesPerson(
      name: 'Sarah Johnson',
      expertise: 'Plumber',
      description: 'Specialist in pipe repairs and bathroom installations',
      price: '65',
      imageUrl: Assets.imagesChatRichard,
      rating: 4.8,
    ),
    TradesPerson(
      name: 'David',
      expertise: 'Plumber',
      description: 'Specialist in pipe repairs and bathroom installations',
      price: '65',
      imageUrl: Assets.imagesChatRobert,
      rating: 4.0,
    ),
    // Add more sample data...
  ];

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
    final screenSize = MediaQuery.of(context).size;

    return GradientScaffold(
      appBar: const TradesPeopleAppbar(currentScreen: TradesPage),
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
                  SearchBarTile(
                    controller: _searchController,
                    onSearch: _onSearch,
                    hintText: 'Search by names',
                    width: double.infinity,
                  ),
                  const SizedBox(height: 25),
                  MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _tradesPeople.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _calculateCrossAxisCount(context),
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        childAspectRatio: 1.5,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
