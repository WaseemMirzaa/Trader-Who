part of 'widgets.dart';

class ChatCard extends StatelessWidget {
  final String name;
  final String distance;
  final bool isOnline;
  final String avatarImage;

  const ChatCard({
    super.key,
    required this.name,
    required this.distance,
    required this.isOnline,
    required this.avatarImage,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(radius: 28, backgroundImage: AssetImage(avatarImage)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontFamily: 'openSans',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColor.primaryText,
                        ),
                      ),
                      if (isOnline)
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColor.white, width: 2),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$distance away from your location',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColor.secondaryText,
                      fontFamily: 'openSans',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
