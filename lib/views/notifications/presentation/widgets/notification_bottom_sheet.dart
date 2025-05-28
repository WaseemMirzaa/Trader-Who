part of 'widgets.dart';

class NotificationBottomSheet extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  const NotificationBottomSheet({
    super.key,
    required this.title,
    required this.description,
    this.onAccept,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: context.screenHeight * 0.4),
      decoration: const BoxDecoration(
        color: AppColor.customLightGray,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Content area with light gray background
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColor.black,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Description
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: AppColor.darkGrayText,
                      ),
                      children: [
                        const TextSpan(
                          text: 'Your trader has marked the job as ',
                        ),
                        TextSpan(
                          text: '"Not as described"',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColor.black,
                          ),
                        ),
                        const TextSpan(
                          text:
                              ', as the work required appears to be more extensive than initially outlined.',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 3),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.4,
                        color: AppColor.darkGrayText,
                      ),
                      children: [
                        const TextSpan(text: 'They have submitted a '),
                        TextSpan(
                          text: '"Reassessed Price of 200"',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColor.black,
                          ),
                        ),
                        const TextSpan(
                          text: ' based on the updated job scope.',
                        ),
                      ],
                    ),
                  ),
                  kGap20,
                  CustomText(
                    text:
                        'Please review and either accept or reject this new price.',
                    maxLines: 2,
                    fontSize: 13,
                    color: AppColor.darkGrayText,
                  ),
                ],
              ),
            ),
          ),

          // White button container with rounded top corners
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Reject Button
                Expanded(
                  child: CustomButton(
                    text: 'Accept',
                    onTap: onAccept ?? () {},
                    height: 50,
                    color: AppColor.darkBlue,
                    textColor: AppColor.white,
                    fontWeight: FontWeight.bold,
                    radius: 25,
                  ),
                ),
                const SizedBox(width: 16),

                // Accept Button
                Expanded(
                  child: CustomButton(
                    text: 'Reject',
                    onTap: onReject ?? () {},
                    height: 50,
                    color: AppColor.orangecustomColor,
                    textColor: AppColor.white,
                    fontWeight: FontWeight.bold,
                    radius: 25,
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
