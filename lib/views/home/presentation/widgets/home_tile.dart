part of 'widgets.dart';

class HomeTiles extends StatelessWidget {
  final String? iconUrl;
  final String fallbackImage;
  final String title;
  final VoidCallback? onTap;
  final Color textColor;
  const HomeTiles({
    super.key,
    this.iconUrl,
    required this.fallbackImage,
    required this.title,
    this.onTap,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 105,
        width: 105,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconUrl != null && iconUrl!.isNotEmpty
                ? CachedNetworkImage(
                  imageUrl: iconUrl!,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) => SizedBox(
                        width: 40,
                        height: 40,
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColor.orangeCustomColor,
                          ),
                        ),
                      ),
                  errorWidget:
                      (context, url, error) => Image.asset(
                        fallbackImage,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                )
                : Image.asset(
                  fallbackImage,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColor.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
