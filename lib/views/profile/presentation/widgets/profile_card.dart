part of 'widgets.dart';

class ProfileCard extends StatelessWidget {
  final String title;
  final String svgAsset;
  final VoidCallback? onTap;

  const ProfileCard({
    super.key,
    required this.title,
    required this.svgAsset,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Circular avatar with SVG
              CustomCircleAvatar(
                backgroundColor: AppColor.customLightGray,
                radius: 20,
                hasBorder: false,
                child: SvgPicture.asset(svgAsset, width: 20, height: 20),
              ),
              const SizedBox(width: 16),
              // Title
              Expanded(
                child: CustomText(
                  text: title,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              // Forward icon
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
