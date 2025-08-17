import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:traderwho/core/extensions/media_query_extension.dart';
import 'package:traderwho/core/shared_widgets/custom_sccfold.dart';
import 'package:traderwho/core/theme/app_color.dart';
import 'package:traderwho/core/theme/assets.dart';
import 'package:traderwho/core/theme/constant.dart';
import 'package:traderwho/models/models.dart';
import 'package:traderwho/views/trades_people/presentation/widgets/widgets.dart';

class TradePersonDetailsPage extends StatefulWidget {
  final TradesPerson person;

  const TradePersonDetailsPage({super.key, required this.person});

  @override
  State<TradePersonDetailsPage> createState() => _TradePersonDetailsPageState();
}

class _TradePersonDetailsPageState extends State<TradePersonDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return TraderWhoScaffold(
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
                widget.person.bio,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColor.secondaryText,
                  fontFamily: 'openSans',
                  height: 1.5,
                ),
              ),
              kGap10,
              // Client Reviews/Testimonials Section
              // Client Reviews/Testimonials Section with average rating
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
                        Builder(
                          builder: (context) {
                            final reviews = widget.person.reviews;
                            double avgRating = 0;
                            if (reviews != null && reviews.isNotEmpty) {
                              avgRating =
                                  reviews
                                      .map((r) => r.rating)
                                      .reduce((a, b) => a + b) /
                                  reviews.length;
                            }
                            return Text(
                              avgRating > 0
                                  ? avgRating.toStringAsFixed(1)
                                  : "0.0",
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColor.orangeCustomColor,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Reviews List
              if (widget.person.reviews != null &&
                  widget.person.reviews!.isNotEmpty)
                ...widget.person.reviews!.map<Widget>((review) {
                  final double rating = (review.rating).toDouble();
                  final String text = review.comment;
                  final String reviewer = review.reviewerName;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RatingBar.builder(
                        initialRating: rating,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 18,
                        ignoreGestures: true,
                        itemBuilder:
                            (context, _) =>
                                Icon(Icons.star, color: AppColor.vibrantYellow),
                        onRatingUpdate: (rating) {},
                      ),
                      kGap10,
                      Text(
                        text,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColor.secondaryText,
                          fontFamily: 'openSans',
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        reviewer,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColor.black,
                        ),
                      ),
                      const SizedBox(height: 29),
                    ],
                  );
                }).toList()
              else
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    "No reviews",
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColor.darkerGray,
                      fontFamily: 'openSans',
                    ),
                  ),
                ),
              _buildSectionTitle("Services"),
              if (widget.person.largeJobs.isEmpty &&
                  widget.person.smallJobs.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    "No services",
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColor.darkerGray,
                      fontFamily: 'openSans',
                    ),
                  ),
                ),
              if (widget.person.largeJobs.isNotEmpty)
                _buildSectionTitle("Large Jobs"),

              for (ServiceModel service in widget.person.largeJobs) ...[
                if (service.services.isNotEmpty)
                  Text(
                    service.category,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primaryText,
                      fontFamily: 'openSans',
                    ),
                  ),
                kGap5,
                if (service.services.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        service.services.map((service) {
                          return Chip(
                            label: Text(
                              service.title,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColor.white,
                                fontFamily: 'openSans',
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
                  ),
              ],
              if ((widget.person.smallJobs).isNotEmpty)
                _buildSectionTitle("Small Jobs"),

              for (ServiceModel service in widget.person.smallJobs) ...[
                if (service.services.isNotEmpty)
                  Text(
                    service.category,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primaryText,
                      fontFamily: 'openSans',
                    ),
                  ),
                kGap5,
                if (service.services.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        service.services.map((service) {
                          return Chip(
                            label: Text(
                              service.title,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColor.white,
                                fontFamily: 'openSans',
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
                  ),
              ],
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
        fontWeight: FontWeight.w600,
        color: AppColor.primaryText,
        fontFamily: 'openSans',
      ),
    );
  }
}
