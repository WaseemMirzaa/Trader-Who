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
    // Determine button text based on showQuoteButtons
    final String rejectText =
        job.showQuoteButtons ? 'Not Interested' : 'Reject';
    final String acceptText = job.showQuoteButtons ? 'Quote' : 'Accept';

    return GestureDetector(
      onTap: onTap,
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
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomCircleAvatar(
                  circleColor: Colors.transparent,
                  backgroundColor: AppColor.lightCyan,
                  radius: 24,
                  child: SvgPicture.asset(job.svgIcon, width: 24, height: 24),
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
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 10), // Replaced kGap10
                      Row(
                        children: [
                          Image.asset(
                            Assets.imagesPounds,
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
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '£${job.price}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColor.darkGray,
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
                    color: AppColor.midGray.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColor.midGray, width: 1),
                  ),
                  child: Text(
                    job.status,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColor.green,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
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
                          color: AppColor.darkGray,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: job.preferredTime,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColor.darkGray,
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
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: job.address,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColor.darkGray,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Buttons Row with Intrinsic Width
            Row(
              mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween, // Changed to end for better alignment
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
        ),
      ),
    );
  }
}
