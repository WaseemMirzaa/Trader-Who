part of 'widgets.dart';

class CategoryCard extends StatelessWidget {
  final String category;
  final IconData icon;
  final int enabledServices;
  final int totalServices;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.icon,
    required this.enabledServices,
    required this.totalServices,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B35).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: const Color(0xFFFF6B35), size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColor.primaryText,
                        fontFamily: 'openSans',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$enabledServices of $totalServices services configured',
                      style: TextStyle(
                        fontFamily: 'openSans',
                        fontSize: 12,
                        color:
                            enabledServices > 0
                                ? Colors.green[600]
                                : AppColor.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}
