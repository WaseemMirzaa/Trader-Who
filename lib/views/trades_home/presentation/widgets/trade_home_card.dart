part of 'widgets.dart';

class TradeHomeCard extends StatelessWidget {
  final JobHistory job;
  final VoidCallback? onTap;
  final VoidCallback? onReject;
  // final VoidCallback? onAccept;

  const TradeHomeCard({
    super.key,
    required this.job,
    this.onTap,
    this.onReject,
    // this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    // Determine if job is completed
    final bool isCompleted = job.status.toLowerCase() == 'completed';

    // Determine button text based on showQuoteButtons
    final String rejectText =
        job.jobType != 'smallJob' ? "Not Interested" : 'REJECT';
    final String acceptText = job.jobType != 'smallJob' ? 'Quote' : 'ACCEPT';

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
                  child: CachedNetworkImage(
                    imageUrl: job.customer?.image ?? '',
                    width: 26,
                    height: 28,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.customer?.name ?? '',
                        style: const TextStyle(
                          fontFamily: 'openSans',

                          color: AppColor.primaryText,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 4),
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
                                    text:
                                        '${HelperService.formattedJobType(job.jobType)}\nFixed Price: ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'openSans',

                                      color: AppColor.primaryText,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '£${job.price}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColor.secondaryText,
                                      fontFamily: 'openSans',
                                    ),
                                  ),
                                ],
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                _buildStatusBadge(job, isCompleted),
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
                          color: AppColor.primaryText,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'openSans',
                        ),
                      ),
                      TextSpan(
                        text: job.preferredTime,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColor.secondaryText,
                          fontFamily: 'openSans',
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
                          color: AppColor.primaryText,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'openSans',
                        ),
                      ),
                      TextSpan(
                        text: job.address,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColor.secondaryText,
                          fontFamily: 'openSans',
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
              if (job.rating != null && job.rating! > 0)
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      Icons.star,
                      color:
                          index < job.rating!.floor()
                              ? Colors.amber
                              : Colors.grey,
                      size: 24,
                    );
                  }),
                ),
              const SizedBox(height: 12),
              Text(
                job.review ?? 'No feedback provided.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColor.secondaryText,
                  fontFamily: 'openSans',
                ),
              ),
            ],

            const SizedBox(height: 12),
            // Buttons Row with Intrinsic Width
            if (job.status == 'pending') ...[
              _buildActionButtons(job, rejectText, acceptText),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(
    JobHistory job,
    String rejectText,
    String acceptText,
  ) {
    // For custom/large jobs, check if trader has submitted a quote
    if (job.jobType.toLowerCase() == 'custom' ||
        job.jobType.toLowerCase() == 'customjob' ||
        job.jobType.toLowerCase() == 'large' ||
        job.jobType.toLowerCase() == 'largejob') {
      // Use StreamBuilder for real-time updates
      return StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('quotes')
                .where('bookingId', isEqualTo: job.bookingId)
                .where(
                  'traderId',
                  isEqualTo: FirebaseAuth.instance.currentUser?.uid ?? '',
                )
                .limit(1)
                .snapshots(),
        builder: (context, snapshot) {
          final hasQuote = snapshot.hasData && snapshot.data!.docs.isNotEmpty;

          // If quote submitted, show message instead of buttons
          if (hasQuote) {
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green, width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Quote Submitted - Awaiting Response',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green.shade700,
                      fontFamily: 'openSans',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          // Show action buttons if no quote submitted
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IntrinsicWidth(
                  child: CustomButton(
                    text: rejectText,
                    onTap: onReject,
                    color: AppColor.primaryButton,
                    textColor: AppColor.white,
                    enableBorder: true,
                    height: 32,
                    radius: 30,
                    fontSize: 10,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: IntrinsicWidth(
                  child: CustomButton(
                    text: acceptText,
                    onTap: onTap,
                    color: AppColor.darkBlue,
                    textColor: AppColor.white,
                    height: 32,
                    radius: 30,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    // For small jobs, always show buttons
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IntrinsicWidth(
            child: CustomButton(
              text: rejectText,
              onTap: onReject,
              color: AppColor.primaryButton,
              textColor: AppColor.white,
              enableBorder: true,
              height: 32,
              radius: 30,
              fontSize: 10,
            ),
          ),
        ),
        if (job.status != 'accepted')
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: IntrinsicWidth(
              child: CustomButton(
                text: acceptText,
                onTap: onTap,
                color: AppColor.darkBlue,
                textColor: AppColor.white,
                height: 32,
                radius: 30,
                fontSize: 10,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStatusBadge(JobHistory job, bool isCompleted) {
    // For pending jobs (custom/large), check if this trader has submitted a quote
    if (job.status.toLowerCase() == 'pending' &&
        (job.jobType.toLowerCase() == 'custom' ||
            job.jobType.toLowerCase() == 'customjob' ||
            job.jobType.toLowerCase() == 'large' ||
            job.jobType.toLowerCase() == 'largejob')) {
      // Use StreamBuilder for real-time updates
      return StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('quotes')
                .where('bookingId', isEqualTo: job.bookingId)
                .where(
                  'traderId',
                  isEqualTo: FirebaseAuth.instance.currentUser?.uid ?? '',
                )
                .limit(1)
                .snapshots(),
        builder: (context, snapshot) {
          final hasQuote = snapshot.hasData && snapshot.data!.docs.isNotEmpty;
          final displayStatus =
              hasQuote
                  ? 'Quote Submitted'
                  : HelperService.formatStatus(job.status);
          final statusColor = hasQuote ? Colors.green : AppColor.green;

          return Container(
            constraints: const BoxConstraints(maxWidth: 100),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color:
                  hasQuote ? Colors.green.withOpacity(0.1) : AppColor.lightCyan,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: hasQuote ? Colors.green : AppColor.white,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (hasQuote) const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    displayStatus,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: statusColor,
                      fontFamily: 'openSans',
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                if (hasQuote)
                  Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 15,
                  ),
              ],
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
        border: Border.all(color: AppColor.white, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isCompleted) const SizedBox(width: 4),
          Expanded(
            child: Text(
              HelperService.formatStatus(job.status),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: AppColor.green,
                fontFamily: 'openSans',
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          if (isCompleted)
            Icon(Icons.check_circle_outline, color: AppColor.green, size: 15),
        ],
      ),
    );
  }
}
