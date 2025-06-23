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
  final Widget? icon;
  final bool isLoading; // NEW: Loading state parameter
  final Color? loadingColor; // NEW: Color for loading indicator

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
    this.textColor = Colors.white,
    this.enableBorder = false,
    this.enableIcon = false,
    this.icon,
    this.isLoading = false, // Default to false
    this.loadingColor = Colors.white, // Default loading color
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap, // Disable onTap when loading
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: isLoading ? color?.withOpacity(0.7) : color,
          borderRadius: BorderRadius.circular(radius),
          border:
              enableBorder
                  ? Border.all(color: borderColor ?? Colors.transparent)
                  : null,
        ),
        child: Center(
          child:
              isLoading
                  ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(loadingColor!),
                      strokeWidth: 2,
                    ),
                  )
                  : enableIcon
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
                  : CustomText(
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
