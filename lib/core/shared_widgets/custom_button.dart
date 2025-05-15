import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'custom_text.dart';

/// A [CustomButton] widget that can be used throughout the app.
class CustomButton extends StatelessWidget {
  ///the text to be displayed on the button
  final String text;

  ///the function to be called when the button is tapped
  final Function()? onTap;

  ///the width of the button
  final double width;

  ///the height of the button
  final double height;

  ///whether the button should have a border
  final bool enableBorder;

  ///the color of the border
  final Color? borderColor;

  ///the color of the button
  final Color? color;

  ///the color of the text
  final Color textColor;

  ///the radius of the button
  final double radius;

  ///the font size of the text
  final double? fontSize;

  ///the font weight of the text
  final FontWeight? fontWeight;

  ///the icon with text
  final bool enableIcon;

  ///the constructor for the [CustomButton] widget
  const CustomButton({
    super.key,
    required this.text,
    this.onTap,
    this.width = double.infinity,
    this.height = 45,
    this.radius = 100,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w600,
    this.borderColor,
    this.color = AppColor.black,
    this.textColor = AppColor.white,
    this.enableBorder = false,
    this.enableIcon = false,
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
          borderRadius: BorderRadius.circular(15),
        ),
        child:
            enableIcon
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: text,
                      color: textColor,
                      fontSize: fontSize,
                      fontWeight: fontWeight,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppColor.white,
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
