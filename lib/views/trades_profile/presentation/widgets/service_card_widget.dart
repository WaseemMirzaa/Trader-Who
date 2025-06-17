part of 'widgets.dart';

class ServiceCardWidget extends StatelessWidget {
  final ServiceItem service;
  final VoidCallback onEditPressed;

  const ServiceCardWidget({
    super.key,
    required this.service,
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
            color: service.isEnabled ? Colors.green[300]! : Colors.grey[200]!,
            width: service.isEnabled ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: service.isEnabled ? Colors.green : Colors.grey[300],
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          service.title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColor.primaryText,
                            fontFamily: 'openSans',
                          ),
                        ),
                      ),
                      if (service.isCustom)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Custom',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColor.secondaryText,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'openSans',
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (service.description != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      service.description!,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    service.price != null
                        ? '£${service.price!.toStringAsFixed(0)}'
                        : 'Price not set',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color:
                          service.price != null
                              ? Colors.green[700]
                              : Colors.red[600],
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
