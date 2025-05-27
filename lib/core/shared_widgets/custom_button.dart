import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'custom_text.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function()? onTap;
  final double width;
  final double height;
  final bool enableBorder;
  final Color? borderColor;
  final Color? color;
  final Color textColor;
  final double radius;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool enableIcon;

  /// NEW: Widget for icon (e.g., SVG, Image, Icon)
  final Widget? icon;

  const CustomButton({
    super.key,
    required this.text,
    this.onTap,
    this.width = double.infinity,
    this.height = 55,
    this.radius = 100,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w600,
    this.borderColor,
    this.color = AppColor.darkGrayText,
    this.textColor = AppColor.darkGrayText,
    this.enableBorder = false,
    this.enableIcon = false,
    this.icon, // NEW
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: kH20,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius),
          border:
              enableBorder
                  ? Border.all(color: borderColor ?? Colors.transparent)
                  : null,
        ),
        child:
            enableIcon
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[icon!, const SizedBox(width: 8)],
                    Flexible(
                      child: CustomText(
                        text: text,
                        color: textColor,
                        fontSize: fontSize,
                        fontWeight: fontWeight,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                )
                : Center(
                  child: CustomText(
                    text: text,
                    color: textColor,
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
      ),
    );
  }
}
