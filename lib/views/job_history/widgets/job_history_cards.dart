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
                      // Show "Custom Job" for jobs without trader, otherwise show trader name
                      Text(
                        job.tradesPerson.id.isEmpty
                            ? 'Custom Job'
                            : job.tradesPerson.name,
                        style: const TextStyle(
                          color: AppColor.primaryText,
                          fontFamily: 'openSans',
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis, // Truncate long titles
                        maxLines: 1, // Limit to one line
                      ),
                      // Show "Awaiting Quotes" subtitle for custom jobs
                      if (job.tradesPerson.id.isEmpty) ...[
                        const SizedBox(height: 2),
                        const Text(
                          'Awaiting Trader Quotes',
                          style: TextStyle(
                            color: AppColor.secondaryText,
                            fontFamily: 'openSans',
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                      const SizedBox(height: 2),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            Assets.svgsPound,
                            width: 14,
                            height: 14,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _formatJobType(job.jobType),
                                  style: TextStyle(
                                    color: AppColor.primaryText,
                                    fontFamily: 'openSans',
                                    fontSize: 12,

                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow:
                                      TextOverflow
                                          .ellipsis, // Truncate long text
                                  maxLines: 1, // Limit to one line
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Fixed Price: \$${job.price}',
                                  style: TextStyle(
                                    color: AppColor.primaryText,
                                    fontFamily: 'openSans',
                                    fontSize: 12,

                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow:
                                      TextOverflow
                                          .ellipsis, // Truncate long text
                                  maxLines: 1, // Limit to one line
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                _buildStatusBadge(job),
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
                Expanded(
                  child: RichText(
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatJobType(String jobType) {
    if (jobType.toLowerCase() == 'smalljob' ||
        jobType.toLowerCase() == 'small') {
      return 'Small Job';
    } else if (jobType.toLowerCase() == 'largejob' ||
        jobType.toLowerCase() == 'large') {
      return 'Large Job';
    } else if (jobType.toLowerCase() == 'custom') {
      return 'Custom Job';
    }
    return jobType;
  }

  Widget _buildStatusBadge(JobHistory job) {
    // For pending jobs (custom/large), check if there are quotes
    if (job.status.toLowerCase() == 'pending' &&
        (job.jobType.toLowerCase() == 'custom' ||
            job.jobType.toLowerCase() == 'customjob' ||
            job.jobType.toLowerCase() == 'large' ||
            job.jobType.toLowerCase() == 'largejob')) {
      // Check for quotes using FutureBuilder
      return FutureBuilder<int>(
        future: Get.find<QuoteController>().getQuoteCountForBooking(
          job.bookingId,
        ),
        builder: (context, snapshot) {
          final quoteCount = snapshot.data ?? 0;
          final displayStatus =
              quoteCount > 0
                  ? 'Quote Submitted'
                  : HelperService.formatStatus(job.status);

          return Container(
            constraints: const BoxConstraints(maxWidth: 100),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color:
                  quoteCount > 0
                      ? Colors.green.withOpacity(0.1)
                      : AppColor.lightCyan,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: quoteCount > 0 ? Colors.green : AppColor.midGray,
                width: 1,
              ),
            ),
            child: Text(
              displayStatus,
              textAlign: TextAlign.center,
              style: TextStyle(
                color:
                    quoteCount > 0
                        ? Colors.green.shade700
                        : AppColor.primaryText,
                fontFamily: 'openSans',
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          );
        },
      );
    }

    // Default status badge
    return Container(
      constraints: const BoxConstraints(maxWidth: 100),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColor.lightCyan,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.midGray, width: 1),
      ),
      child: Text(
        HelperService.formatStatus(job.status),
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: AppColor.primaryText,
          fontFamily: 'openSans',
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
    );
  }
}
