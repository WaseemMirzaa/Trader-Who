part of 'pages.dart';

class TradesPage extends StatefulWidget {
  const TradesPage({super.key});

  @override
  State<TradesPage> createState() => _TradesPageState();
}

class _TradesPageState extends State<TradesPage> {
  final TextEditingController _searchController = TextEditingController();
  final TradesPeopleController _controller = Get.put(TradesPeopleController());

  @override
  void dispose() {
    _searchController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onSearch() {
    debugPrint('Searching for: \\${_searchController.text}');
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
          child: Obx(() {
            final isLoading = _controller.isLoading.value;
            List<TradesPerson> tradesPeople = _controller.tradesPeople;
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isLoading && tradesPeople.isNotEmpty)
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
                  if (isLoading)
                    Center(
                      child: CircularProgressIndicator(
                        color: AppColor.primaryButton,
                      ),
                    )
                  else if (tradesPeople.isEmpty)
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
                    NotificationListener<ScrollNotification>(
                      onNotification: (scrollInfo) {
                        if (scrollInfo.metrics.pixels ==
                                scrollInfo.metrics.maxScrollExtent &&
                            !_controller.isLoadingMore.value) {
                          _controller.fetchMoreTradesPeople();
                        }
                        return false;
                      },
                      child: Column(
                        children: [
                          MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: tradesPeople.length,
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
                                  person: tradesPeople[index],
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => TradePersonDetailsPage(
                                              person: tradesPeople[index],
                                            ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          if (_controller.isLoadingMore.value)
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColor.primaryButton,
                                ),
                              ),
                            ),
                          const SizedBox(height: 30),
                          Center(
                            child: CustomButton(
                              text: 'Post a Custom Job Request',
                              onTap: () {
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
                    ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
