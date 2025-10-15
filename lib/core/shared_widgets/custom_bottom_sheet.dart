import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:traderwho/controller/booking_controller.dart';
import 'package:traderwho/controller/new_service_controller.dart';
import 'package:traderwho/core/extensions/extensions.dart';
import 'package:traderwho/core/shared_widgets/custom_button.dart';
import 'package:traderwho/core/shared_widgets/custom_circle_avatar.dart';
import 'package:traderwho/core/theme/theme.dart';
import 'package:traderwho/models/models.dart';
import 'package:traderwho/views/chat/presentation/pages/pages.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomBottomSheet extends StatelessWidget {
  // final String professionalName;
  // final String profession;
  // final double rating;
  // final String description;
  // final String qualifications;

  final double price;
  final TradesPerson person;
  final String selectedJobType;

  const CustomBottomSheet({
    super.key,
    // required this.professionalName,
    // required this.profession,
    // this.rating = 4.7,
    // required this.description,
    // required this.qualifications,
    required this.price,
    required this.person,
    required this.selectedJobType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: context.screenHeight * 0.40,
        maxHeight: context.screenHeight * 0.6,
      ),
      decoration: BoxDecoration(
        color: AppColor.customLightGray,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: AppColor.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColor.customLightGray,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Container(
            width: context.screenWidth * 0.9,
            constraints: BoxConstraints(maxHeight: context.screenHeight * 0.36),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomCircleAvatar(
                        radius: 30,
                        circleColor: AppColor.orangeCustomColor,
                        child: Image(
                          image: AssetImage(Assets.imagesCircularAvatar),
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              person.name,
                              style: const TextStyle(
                                color: AppColor.primaryText,
                                fontFamily: 'openSans',
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              person.title ?? "",
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColor.secondaryText,
                                fontFamily: 'openSans',
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                ...List.generate(
                                  5,
                                  (index) => Icon(
                                    Icons.star,
                                    color:
                                        index < person.rating.floor()
                                            ? Colors.amber
                                            : Colors.grey[300],
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${person.rating} overall',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Text(
                    person.bio,
                    style: const TextStyle(
                      color: AppColor.secondaryText,
                      fontFamily: 'openSans',
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 16),
                  Text(
                    'Additional Qualifications',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColor.primaryText,
                      fontFamily: 'openSans',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    person.expertise,
                    style: const TextStyle(
                      color: AppColor.secondaryText,
                      fontFamily: 'openSans',
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Book Now',
                    onTap: () {
                      _handleBookNow();
                    },
                    height: 50,
                    color: AppColor.primaryButton,
                    textColor: Colors.white,
                    fontWeight: FontWeight.bold,
                    radius: 25,
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    launchUrl(Uri.parse('tel:${person.phoneNumber}'));
                  }, // Add call functionality here
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColor.darkBlue, // Dark blue background
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        Assets.svgsCall,
                        width: 25,
                        height: 25,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    Get.to(
                      () => ChatDetailPage(
                        avatarImage: person.imageUrl,
                        userName: person.name,
                        receiverId: person.id,
                      ),
                    );
                  }, // Add message functionality here
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColor.orangeCustomColor, // Dark blue background
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        Assets.svgsMessage,
                        width: 25,
                        height: 25,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleBookNow() async {
    // Import the booking controller
    final BookingController bookingController = Get.put(BookingController());
    final NewServiceController serviceController = Get.find();

    // Determine the service name based on selected criteria.
    // NewServiceController exposes `selectedCategory` for compatibility.
    String serviceName =
        serviceController.selectedCategory.value.isNotEmpty
            ? '${serviceController.selectedCategory.value} Service'
            : 'General Service';

    // Show booking dialog (includes user type validation)
    await bookingController.showBookingDialog(
      traderName: person.name,
      traderId: person.id,
      category:
          serviceController.selectedCategory.value.isNotEmpty
              ? serviceController.selectedCategory.value
              : 'General',
      service: serviceName,
      jobType: selectedJobType.isNotEmpty ? selectedJobType : 'largeJob',
      price: price,
    );
    Get.back();
  }
}
