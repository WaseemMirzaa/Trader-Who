part of 'widgets.dart';

class TradesPeopleCard extends StatelessWidget {
  final TradesPerson person;
  final VoidCallback? onTap;

  const TradesPeopleCard({super.key, required this.person, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          onTap ??
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TradePersonDetailsPage(person: person),
              ),
            );
          },
      child: Container(
        padding: const EdgeInsets.all(16),
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
                            color: AppColor.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
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
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '£${person.price}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColor.darkerGray,
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
                        person.rating.toString(),
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
            const SizedBox(height: 16),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Expertise: ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: person.expertise,
                    style: TextStyle(fontSize: 18, color: AppColor.darkerGray),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              person.description,
              style: TextStyle(
                fontSize: 12,
                color: AppColor.darkerGray,

                fontWeight: FontWeight.w500,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
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
