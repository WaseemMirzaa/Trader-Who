part of 'pages.dart';

class TradePersonDetailsPage extends StatefulWidget {
  final TradesPerson person;

  const TradePersonDetailsPage({super.key, required this.person});

  @override
  State<TradePersonDetailsPage> createState() => _TradePersonDetailsPageState();
}

class _TradePersonDetailsPageState extends State<TradePersonDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: TradePersonDetailsAppBar(
        person: widget.person,
        onBackPressed: () {
          Navigator.pop(context);
        },
        screenHeight: context.screenHeight * 0.4 + 17,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Biography Section
              _buildSectionTitle("Biography"),
              const SizedBox(height: 10),
              Text(
                "Hi, I'm ${widget.person.name}, a licensed plumbing professional"
                "with over 10 years of experience helping homeowners and businesses keep their\n"
                "water systems running smoothly. From leaky faucets to full-scale "
                "pipe installations, I bring dependable, high-quality services with a\n"
                "focus on getting the job done right the first time.",
                style: TextStyle(
                  fontSize: 12,
                  color: AppColor.darkerGray,
                  height: 1.5,
                ),
              ),
              kGap10,
              // Client Reviews/Testimonials Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildSectionTitle("Client Reviews/Testimonials"),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.midGray.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(Assets.imagesStars, width: 16, height: 16),
                        const SizedBox(width: 4),
                        Text(
                          widget.person.rating.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColor.orangecustomColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Star Rating (5 stars)
              RatingBar.builder(
                initialRating: widget.person.rating.toDouble(),
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 4,
                itemSize: 18,
                ignoreGestures: true, // Makes it read-only
                itemBuilder:
                    (context, _) =>
                        Icon(Icons.star, color: AppColor.vibrantYellow),
                onRatingUpdate: (rating) {},
              ),
              kGap10,

              // Review Text
              Text(
                "He always gives a perfect service. Great attention to detail and awesome\n"
                "service every time. Highly recommended!",
                style: TextStyle(
                  fontSize: 12,
                  color: AppColor.darkerGray,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 10),

              // Reviewer Name
              Text(
                "Jason Rao",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColor.black,
                ),
              ),
              const SizedBox(height: 29),

              // Second Review (same pattern)
              RatingBar.builder(
                initialRating: widget.person.rating.toDouble(),
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 4,
                itemSize: 18,
                ignoreGestures: true,
                itemBuilder:
                    (context, _) =>
                        Icon(Icons.star, color: AppColor.vibrantYellow),
                onRatingUpdate: (rating) {},
              ),
              kGap10,
              Text(
                "Another excellent review text would go here describing the\n"
                "great service provided by the tradesperson.",
                style: TextStyle(
                  fontSize: 12,
                  color: AppColor.darkerGray,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Thomas Christopher",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColor.black,
                ),
              ),
              kGap10,
              _buildSectionTitle("Services"),
              widget.person.services?.isNotEmpty ?? false
                  ? Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        widget.person.services!.map((service) {
                          return Chip(
                            label: Text(
                              service,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColor.black,
                              ),
                            ),
                            backgroundColor: AppColor.mediumGray,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                          );
                        }).toList(),
                  )
                  : Text(
                    "No services listed",
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColor.darkerGray,
                      height: 1.5,
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
    );
  }
}
