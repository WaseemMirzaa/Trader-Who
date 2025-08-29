part of 'widgets.dart';

class TradesPeopleCard extends StatelessWidget {
  final TradesPerson person;
  final VoidCallback? onTap;
  final String selectedCategory;
  final String selectedService;
  final String selectedJobType;
  final double price;

  const TradesPeopleCard({
    super.key,
    required this.person,
    this.onTap,
    this.selectedCategory = '',
    this.selectedService = '',
    this.selectedJobType = '',
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          onTap ??
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => TradePersonDetailsPage(
                      person: person,
                      price: price,
                      selectedJobType: selectedJobType,
                    ),
              ),
            );
          },
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.0),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // Updated CustomCircleAvatar with error handling
                    _buildAvatarWithFallback(),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          person.name,
                          style: const TextStyle(
                            color: AppColor.primaryText,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'openSans',
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              Assets.svgsDollar,
                              width: 18,
                              height: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Price: ',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColor.primaryText,
                                fontFamily: 'openSans',
                              ),
                            ),
                            Text(
                              '£$price',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColor.secondaryText,
                                fontFamily: 'openSans',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.lightCyan,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Image.asset(Assets.imagesStars, width: 16, height: 16),
                      const SizedBox(width: 4),
                      Text(
                        (person.reviews ?? []).isNotEmpty
                            ? (person.reviews!
                                        .map((r) => r.rating)
                                        .reduce((a, b) => a + b) /
                                    person.reviews!.length)
                                .toStringAsFixed(1)
                            : '0.0',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColor.orangeCustomColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Expertise: ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'openSans',
                      color: AppColor.primaryText,
                    ),
                  ),
                  TextSpan(
                    text: person.title,
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColor.secondaryText,
                      fontFamily: 'openSans',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              person.bio,
              style: TextStyle(
                fontSize: 12,
                color: AppColor.secondaryText,
                fontWeight: FontWeight.w500,
                fontFamily: 'openSans',
              ),
              maxLines: 300,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            // Book Now Button
            // Row(
            //   children: [
            //     Expanded(
            //       child: ElevatedButton(
            //         onPressed: () => _handleBookNow(),
            //         style: ElevatedButton.styleFrom(
            //           backgroundColor: AppColor.primaryButton,
            //           foregroundColor: Colors.white,
            //           padding: const EdgeInsets.symmetric(vertical: 12),
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(10),
            //           ),
            //         ),
            //         child: const Text(
            //           'Book Now',
            //           style: TextStyle(
            //             fontSize: 14,
            //             fontWeight: FontWeight.w600,
            //           ),
            //         ),
            //       ),
            //     ),
            //     const SizedBox(width: 12),
            //     Expanded(
            //       child: OutlinedButton(
            //         onPressed:
            //             onTap ??
            //             () {
            //               Navigator.push(
            //                 context,
            //                 MaterialPageRoute(
            //                   builder:
            //                       (context) =>
            //                           TradePersonDetailsPage(person: person),
            //                 ),
            //               );
            //             },
            //         style: OutlinedButton.styleFrom(
            //           foregroundColor: AppColor.primaryButton,
            //           padding: const EdgeInsets.symmetric(vertical: 12),
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(10),
            //           ),
            //           side: BorderSide(color: AppColor.primaryButton),
            //         ),
            //         child: const Text(
            //           'View Details',
            //           style: TextStyle(
            //             fontSize: 14,
            //             fontWeight: FontWeight.w600,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarWithFallback() {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColor.midGray.withOpacity(0.2),
      ),
      child: ClipOval(
        child: Image.asset(
          person.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              Assets.imagesChatThomas, // Fallback image
              fit: BoxFit.cover,
            );
          },
        ),
      ),
    );
  }
}
