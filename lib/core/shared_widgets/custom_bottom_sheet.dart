import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:traderwho/core/extensions/extensions.dart';
import 'package:traderwho/core/shared_widgets/custom_button.dart';
import 'package:traderwho/core/shared_widgets/custom_circle_avatar.dart';
import 'package:traderwho/core/theme/theme.dart';

class CustomBottomSheet extends StatelessWidget {
  final String professionalName;
  final String profession;
  final double rating;
  final String description;
  final String qualifications;

  const CustomBottomSheet({
    super.key,
    required this.professionalName,
    required this.profession,
    this.rating = 4.7,
    required this.description,
    required this.qualifications,
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
            color: Colors.black.withOpacity(0.1),
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
                        circleColor: AppColor.orangecustomColor,
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
                              professionalName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColor.black,
                              ),
                            ),
                            Text(
                              profession,
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColor.mutedGray,
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
                                        index < rating.floor()
                                            ? Colors.amber
                                            : Colors.grey[300],
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '$rating overall',
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
                    description,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.4,
                      color: AppColor.mutedGray,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 16),
                  Text(
                    'Additional Qualifications',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    qualifications,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.4,
                      color: AppColor.mutedGray,
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
                    onTap: () {},
                    height: 50,
                    color: AppColor.darkBlue,
                    textColor: Colors.white,
                    fontWeight: FontWeight.bold,
                    radius: 25,
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {}, // Add call functionality here
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
                  onTap: () {}, // Add message functionality here
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColor.orangecustomColor, // Dark blue background
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
}
