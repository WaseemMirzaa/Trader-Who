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
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                RatingBar.builder(
                  initialRating: 5,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 21,
                  ignoreGestures: true, // Makes it read-only
                  itemBuilder:
                      (context, _) =>
                          Icon(Icons.star, color: AppColor.vibrantYellow),
                  onRatingUpdate: (rating) {},
                ),
                const SizedBox(height: 10), // kGap10 replacement
                // Review Text
                const Text(
                  "He always gives a perfect service. Great attention to detail and awesome "
                  "service every time. Highly recommended!",
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColor.grey,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),

                // Reviewer Name
                const Text(
                  "Jason Rao",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColor.black,
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
