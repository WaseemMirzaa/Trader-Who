part of 'widgets.dart';

class TradesPeopleCard extends StatelessWidget {
  final TradesPerson person;
  final VoidCallback? onTap;

  const TradesPeopleCard({
    super.key,
    required this.person,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {
        // Default onTap behavior if no callback is provided
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
              color: Colors.black.withOpacity(0.1),
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
                    CustomCircleAvatar(
                      radius: 24,
                      imageUrl: person.imageUrl,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          person.name,
                          style: const TextStyle(
                            color: AppColor.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Moved price section here with dollar icon
                     Row(
  mainAxisSize: MainAxisSize.min, // Fit content
  children: [
    // Dollar icon and price
    SvgPicture.asset(
     Assets.svgsDollar, // Replace with your SVG path
      width: 18,
      height: 18,
      // Optional: tint the SVG
    ),
    const SizedBox(width: 4), // Space between icon and text
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
        color: AppColor.mutedGray,
      ),
    ),
  ],
)
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
                    color: AppColor.midGray.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                     Image.asset(
                        Assets.imagesStars,
                       
                        width: 16,
                        height: 16,
                      ),
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
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: person.expertise,
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColor.mutedGray,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              person.description,
              style: TextStyle(
                fontSize: 14,
                color: AppColor.darkGray,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}