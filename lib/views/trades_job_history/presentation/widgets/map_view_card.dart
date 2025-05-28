part of '../../../trades_people/presentation/widgets/widgets.dart';

class MapViewCard extends StatelessWidget {
  final JobHistory job;
  final VoidCallback? onTap;

  const MapViewCard({super.key, required this.job, this.onTap});

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
              // ignore: deprecated_member_use
              color: Colors.grey.withValues(alpha: 0.1),
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
                  radius: 26,
                  child: SvgPicture.asset(job.svgIcon, width: 24, height: 28),
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
                      const SizedBox(height: 8),
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
                                    text: 'Estimated Price: ',
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
                                      color: AppColor.grey,
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.customOffWhite,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Image.asset(Assets.imagesStars, width: 16, height: 16),
                      const SizedBox(width: 4),
                      Text(
                        job.tradesPerson.rating.toString(),
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
            const SizedBox(height: 12),

            // Distance Section
            Row(
              children: [
                SvgPicture.asset(Assets.svgsLocation, width: 16, height: 16),
                const SizedBox(width: 4),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Distance: ',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColor.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: job.address,
                        style: TextStyle(fontSize: 14, color: AppColor.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Description Section - Added this new part
            if (job.tradesPerson.description.isNotEmpty ?? false) ...[
              const SizedBox(height: 12),
              Text(
                job.tradesPerson.description,
                style: TextStyle(fontSize: 14, color: AppColor.grey),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
