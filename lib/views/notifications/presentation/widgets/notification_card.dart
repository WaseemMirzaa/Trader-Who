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
          CircleAvatar(radius: 30, backgroundImage: AssetImage(avatarImage)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'openSans',

                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColor.primaryText,
                      ),
                    ),
                    Text(
                      time,
                      style: TextStyle(
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
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColor.secondaryText,
                    fontFamily: 'openSans',
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
