part of 'widgets.dart';

class JobHistoryCard extends StatelessWidget {
  final JobHistory job;
  final VoidCallback? onTap;

  const JobHistoryCard({super.key, required this.job, this.onTap});

  @override
  Widget build(BuildContext context) {
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
                        job.tradesPerson.name,
                        style: const TextStyle(
                          color: AppColor.primaryText,
                          fontFamily: 'openSans',
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis, // Truncate long titles
                        maxLines: 1, // Limit to one line
                      ),
                      kGap10, // Assuming this is a SizedBox(height: 10)
                      Row(
                        children: [
                          SvgPicture.asset(
                            Assets.svgsPound,
                            width: 14,
                            height: 14,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${job.jobType} – Fixed Price: \$${job.price}',
                              style: TextStyle(
                                color: AppColor.primaryText,
                                fontFamily: 'openSans',
                                fontSize: 12,

                                fontWeight: FontWeight.w600,
                              ),
                              overflow:
                                  TextOverflow.ellipsis, // Truncate long text
                              maxLines: 1, // Limit to one line
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  constraints: const BoxConstraints(
                    maxWidth: 100,
                  ), // Limit status width
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.lightCyan,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColor.midGray, width: 1),
                  ),
                  child: Text(
                    HelperService.formatStatus(job.status),
                    style: const TextStyle(
                      color: AppColor.primaryText,
                      fontFamily: 'openSans',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis, // Truncate long status
                    maxLines: 2, // Limit to two lines
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
                          color: AppColor.primaryText,
                          fontFamily: 'openSans',
                          fontSize: 14,

                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: job.preferredTime,
                        style: TextStyle(
                          color: AppColor.secondaryText,
                          fontFamily: 'openSans',
                          fontSize: 14,
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
                          color: AppColor.primaryText,
                          fontFamily: 'openSans',
                          fontSize: 14,

                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: job.address,
                        style: TextStyle(
                          color: AppColor.secondaryText,
                          fontFamily: 'openSans',
                          fontSize: 14,
                        ),
                      ),
                    ],
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
