import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:traderou/controller/booking_controller.dart';
import 'package:traderou/controller/new_service_controller.dart';
// legacy ServiceController imports removed; using NewServiceController for service lookups
import 'package:traderou/core/extensions/media_query_extension.dart';
import 'package:traderou/core/shared_widgets/custom_sccfold.dart';
import 'package:traderou/core/theme/app_color.dart';
import 'package:traderou/core/theme/assets.dart';
import 'package:traderou/core/theme/constant.dart';
import 'package:traderou/models/models.dart';
import 'package:traderou/views/trades_people/presentation/widgets/widgets.dart';

class TradePersonDetailsPage extends StatefulWidget {
  final TradesPerson person;
  final double price;
  final String selectedJobType;

  const TradePersonDetailsPage({
    super.key,
    required this.person,
    required this.price,
    required this.selectedJobType,
  });

  @override
  State<TradePersonDetailsPage> createState() => _TradePersonDetailsPageState();
}

class _TradePersonDetailsPageState extends State<TradePersonDetailsPage> {
  @override
  void initState() {
    super.initState();
    print('🔍 TradePersonDetailsPage for: ${widget.person.name}');
    print('   Large jobs: ${widget.person.largeJobs.length} categories');
    print('   Small jobs: ${widget.person.smallJobs.length} categories');

    // Debug: Print details of each category
    for (var job in widget.person.largeJobs) {
      print('   📦 Large - ${job.category}: ${job.services.length} services');
    }
    for (var job in widget.person.smallJobs) {
      print('   📦 Small - ${job.category}: ${job.services.length} services');
    }
  }

  void _handleBookNow() async {
    // Import the booking controller
    final BookingController bookingController = Get.put(BookingController());
    final NewServiceController serviceController = Get.find();

    // Get category name from the selected category ID
    String categoryName = 'General';
    if (serviceController.selectedCategory.value.isNotEmpty) {
      final category = serviceController.categories.firstWhereOrNull(
        (c) => c.id == serviceController.selectedCategory.value,
      );
      categoryName = category?.name ?? serviceController.selectedCategory.value;
    }

    // Get service name from the selected job ID
    String serviceName = 'Service';
    if (serviceController.selectedJobId.value.isNotEmpty) {
      final job = serviceController.getJobById(
        serviceController.selectedJobId.value,
      );
      serviceName = job?.title ?? serviceController.selectedJobId.value;
    }

    print('🔍 Creating booking with:');
    print('  Category ID: ${serviceController.selectedCategory.value}');
    print('  Category Name: $categoryName');
    print('  Job ID: ${serviceController.selectedJobId.value}');
    print('  Service: $serviceName');
    print('  Job Type: ${widget.selectedJobType}');

    // Get trader's available times
    DateTime? traderStartTime;
    DateTime? traderEndTime;

    if (widget.person.startTime != null) {
      traderStartTime = DateTime.fromMillisecondsSinceEpoch(
        widget.person.startTime!,
      );
    }

    if (widget.person.endTime != null) {
      traderEndTime = DateTime.fromMillisecondsSinceEpoch(
        widget.person.endTime!,
      );
    }

    // Show booking dialog (includes user type validation)
    await bookingController.showBookingDialog(
      traderName: widget.person.name,
      traderId: widget.person.id,
      category: categoryName, // Pass category NAME, not ID
      service: serviceName,
      jobType:
          widget.selectedJobType.isNotEmpty
              ? widget.selectedJobType
              : 'largeJob',
      price: widget.price,
      traderStartTime: traderStartTime,
      traderEndTime: traderEndTime,
    );
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return TraderouScaffold(
      appBar: TradePersonDetailsAppBar(
        person: widget.person,
        price: widget.price,
        onBackPressed: () {
          Navigator.pop(context);
        },
        onBookNow: () {
          _handleBookNow();
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
                  fontSize: 14,
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
                        Text(
                          widget.person.rating > 0
                              ? widget.person.rating.toStringAsFixed(1)
                              : "0.0",
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColor.orangeCustomColor,
                          ),
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
                          fontSize: 16,
                          color: AppColor.secondaryText,
                          fontFamily: 'openSans',
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        reviewer,
                        style: TextStyle(
                          fontSize: 14,
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
                      fontSize: 14,
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
