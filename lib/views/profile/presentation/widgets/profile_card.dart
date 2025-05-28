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
              color: AppColor.grey.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 16.0,
          ), // Reduced vertical padding
          child: Row(
            children: [
              // Smaller circular avatar with SVG
              CustomCircleAvatar(
                backgroundColor: AppColor.customLightGray,
                radius: 18, // Reduced from 20
                hasBorder: false,
                child: SvgPicture.asset(
                  svgAsset,
                  width: 18,
                  height: 18,
                ), // Reduced from 20
              ),
              const SizedBox(width: 16),
              // Title
              Expanded(
                child: CustomText(
                  text: title,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColor.darkGray,
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
