part of 'widgets.dart';

class TradeHomeCard extends StatelessWidget {
  final JobHistory job;
  final VoidCallback? onTap;
  final VoidCallback? onReject;
  final VoidCallback? onAccept;

  const TradeHomeCard({
    super.key,
    required this.job,
    this.onTap,
    this.onReject,
    this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    // Determine if job is completed
    final bool isCompleted = job.status.toLowerCase() == 'completed';

    // Determine button text based on showQuoteButtons
    final String rejectText =
        job.showQuoteButtons ? 'Not Interested' : 'REJECT';
    final String acceptText = job.showQuoteButtons ? 'Quote' : 'ACCEPT';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 9),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomCircleAvatar(
                  circleColor: Colors.transparent,
                  backgroundColor: AppColor.lightCyan,
                  radius: 30,
                  child: SvgPicture.asset(job.svgIcon, width: 26, height: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.title,
                        style: const TextStyle(
                          color: AppColor.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          SvgPicture.asset(
                            Assets.svgsPound,
                            width: 16,
                            height: 16,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Small Job - Fixed Price: ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColor.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '£${job.price}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColor.darkerGray,
                                    ),
                                  ),
                                ],
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  constraints: const BoxConstraints(maxWidth: 100),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.lightCyan,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColor.white, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isCompleted) const SizedBox(width: 4),
                      Text(
                        job.status,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColor.green,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      if (isCompleted)
                        Icon(
                          Icons.check_circle_outline,
                          color: AppColor.green,
                          size: 16,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Preferred Time Row
            Row(
              children: [
                SvgPicture.asset(Assets.svgsTime, width: 16, height: 16),
                const SizedBox(width: 4),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Preferred Time: ',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColor.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: job.preferredTime,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColor.darkerGray,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Address Section
            Row(
              children: [
                SvgPicture.asset(Assets.svgsLocation, width: 16, height: 16),
                const SizedBox(width: 4),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Address: ',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColor.darkGray,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: job.address,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColor.darkerGray,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Only show these if job is completed
            if (isCompleted) ...[
              const SizedBox(height: 12),
              // Rating stars
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  Icon(Icons.star, color: Colors.amber, size: 16),
                ],
              ),
              const SizedBox(height: 8),
              // Description
              Text(
                job.tradesPerson.description ?? 'No description provided',
                style: TextStyle(fontSize: 14, color: AppColor.darkGray),
              ),
              const SizedBox(height: 8),
              // Bold black text
              Text(
                'Jason Rao',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColor.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],

            const SizedBox(height: 12),
            // Buttons Row with Intrinsic Width
            if (!isCompleted) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: IntrinsicWidth(
                      child: CustomButton(
                        text: rejectText,
                        onTap: onReject,
                        color: AppColor.orangecustomColor,
                        textColor: AppColor.white,
                        enableBorder: true,
                        height: 32,
                        radius: 30,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: IntrinsicWidth(
                      child: CustomButton(
                        text: acceptText,
                        onTap: onAccept,
                        color: AppColor.darkBlue,
                        textColor: AppColor.white,
                        height: 32,
                        radius: 30,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
