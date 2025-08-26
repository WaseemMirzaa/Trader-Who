part of 'widgets.dart';

class CustomerCard extends StatelessWidget {
  final UserModel customer;
  final VoidCallback? onTap;

  const CustomerCard({super.key, required this.customer, this.onTap});

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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildAvatarWithFallback(),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.name,
                      style: const TextStyle(
                        color: AppColor.primaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'openSans',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.email,
                          size: 14,
                          color: AppColor.secondaryText,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          customer.email,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColor.secondaryText,
                            fontFamily: 'openSans',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Customer type badge
              ],
            ),
            if (customer.phone != null && customer.phone!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.phone, size: 14, color: AppColor.secondaryText),
                  const SizedBox(width: 4),
                  Text(
                    'Phone: ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColor.primaryText,
                      fontFamily: 'openSans',
                    ),
                  ),
                  Text(
                    customer.phone!,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColor.secondaryText,
                      fontFamily: 'openSans',
                    ),
                  ),
                ],
              ),
            ],
            if (customer.address != null && customer.address!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.location_on,
                    size: 14,
                    color: AppColor.secondaryText,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Address: ',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColor.primaryText,
                            fontFamily: 'openSans',
                          ),
                        ),
                        Text(
                          customer.address!,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColor.secondaryText,
                            fontFamily: 'openSans',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarWithFallback() {
    return CustomCircleAvatar(
      circleColor: Colors.transparent,
      backgroundColor: AppColor.royalBlue,
      radius: 24,
      child:
          customer.image != null && customer.image!.isNotEmpty
              ? CachedNetworkImage(
                imageUrl: customer.image!,
                imageBuilder:
                    (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                placeholder:
                    (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => _buildFallbackAvatar(),
              )
              : _buildFallbackAvatar(),
    );
  }

  Widget _buildFallbackAvatar() {
    return Icon(Icons.person, size: 24, color: AppColor.primaryText);
  }
}
