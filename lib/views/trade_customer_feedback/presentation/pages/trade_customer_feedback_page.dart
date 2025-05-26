part of 'pages.dart';

class TradeCustomerFeedbackPage extends StatefulWidget {
  const TradeCustomerFeedbackPage({super.key});

  @override
  State<TradeCustomerFeedbackPage> createState() =>
      _TradeCustomerFeedbackPageState();
}

class _TradeCustomerFeedbackPageState extends State<TradeCustomerFeedbackPage> {
  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: TradeCustomerFeedbackAppbar(),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: List.generate(
          6, // Repeat 6 times
          (index) => Padding(
            padding: const EdgeInsets.only(
              bottom: 24.0,
            ), // Space between feedback cards
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Star Rating
                Row(
                  children: [
                    // Generate 5 star images
                    Image.asset(
                      Assets.imagesIconawesomeStar,
                      width: 24,
                      height: 24,
                    ),
                    kGap5,
                    Image.asset(
                      Assets.imagesIconawesomeStar,
                      width: 24,
                      height: 24,
                    ),
                    kGap5,
                    Image.asset(
                      Assets.imagesIconawesomeStar,
                      width: 24,
                      height: 24,
                    ),
                    kGap5,
                    Image.asset(
                      Assets.imagesIconawesomeStar,
                      width: 24,
                      height: 24,
                    ),
                    kGap5,
                    Image.asset(
                      Assets.imagesIconawesomeStar,
                      width: 24,
                      height: 24,
                    ),
                  ],
                ),
                const SizedBox(height: 10), // kGap10 replacement
                // Review Text
                const Text(
                  "He always gives a perfect service. Great attention to detail and awesome\n"
                  "service every time. Highly recommended!",
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColor.darkGray,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),

                // Reviewer Name
                const Text(
                  "Jason Rao",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColor.darkBlue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
