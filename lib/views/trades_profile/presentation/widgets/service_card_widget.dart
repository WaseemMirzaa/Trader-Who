part of 'widgets.dart';

class ServiceCardWidget extends StatelessWidget {
  final JobModel job;
  final double? price;
  final bool isEnabled;
  final VoidCallback onEditPressed;

  const ServiceCardWidget({
    super.key,
    required this.job,
    required this.price,
    required this.isEnabled,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isEnabled ? AppColor.primaryButton : Colors.grey[200]!,
            width: isEnabled ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: isEnabled ? AppColor.primaryButton : Colors.grey[300],
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    job.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColor.primaryText,
                      fontFamily: 'openSans',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    price != null
                        ? '£${price?.toStringAsFixed(0)}'
                        : 'Price not set',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color:
                          price != null ? Colors.green[700] : Colors.red[600],
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onEditPressed,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E3A8A).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.edit,
                  size: 18,
                  color: AppColor.primaryButton,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
