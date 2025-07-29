import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:traderwho/core/theme/assets.dart';

import '../theme/app_color.dart';
import 'custom_circular_indicator.dart';

/// A [CustomCircleAvatar] widget that displays a circular image or custom content with a border.
class CustomCircleAvatar extends StatelessWidget {
  /// The color of the circle border.
  final Color circleColor;

  /// The radius of the circle.
  final double? radius;

  /// The URL of the image to be displayed inside the circle.
  final String? imageUrl;

  /// Optional child widget to display inside the circle instead of an image.
  final Widget? child;

  /// The background color of the CircleAvatar.
  final Color? backgroundColor;

  /// Whether to display a border around the circle.
  final bool hasBorder;

  /// Creates a [CustomCircleAvatar] widget.
  const CustomCircleAvatar({
    super.key,
    this.circleColor = AppColor.navyBlue,
    this.radius,
    this.imageUrl,
    this.child,
    this.backgroundColor = Colors.transparent,
    this.hasBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: hasBorder ? Border.all(color: circleColor, width: 2) : null,
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor,
        child:
            child ??
            CachedNetworkImage(
              imageUrl: imageUrl ?? '',
              placeholder: (context, url) => const CustomCircularIndicator(),
              errorWidget:
                  (context, url, error) => Image.asset(
                    Assets.imagesTradePerson,
                    width: 32,
                    height: 32,
                  ),
              fit: BoxFit.cover,
            ),
      ),
    );
  }
}
