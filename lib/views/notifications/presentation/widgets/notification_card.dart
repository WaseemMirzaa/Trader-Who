part of 'widgets.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final String description;
  final String time;
  final String avatarImage;

  const NotificationCard({
    super.key,
    required this.title,
    required this.description,
    required this.time,
    required this.avatarImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // Handle both network and asset images
          CircleAvatar(
            radius: 30,
            backgroundImage:
                avatarImage.startsWith('http')
                    ? NetworkImage(avatarImage) as ImageProvider
                    : AssetImage(avatarImage),
            backgroundColor: AppColor.primaryButton.withOpacity(0.1),
            child:
                avatarImage.isEmpty
                    ? const Icon(Icons.person, color: AppColor.primaryButton)
                    : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'openSans',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColor.primaryText,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColor.secondaryText,
                        fontFamily: 'openSans',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColor.secondaryText,
                    fontFamily: 'openSans',
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
