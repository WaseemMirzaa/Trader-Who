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
    return GradientScaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 20),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
