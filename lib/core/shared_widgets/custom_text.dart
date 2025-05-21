import 'package:flutter/material.dart';

import '../theme/app_color.dart';

/// A [CustomText] widget that provides a consistent style and behavior for displaying text in the app.
class CustomText extends StatelessWidget {
  ///[text] is the text to be displayed.
  final String text;

  ///[textAlign] is the alignment of the text.
  final TextAlign? textAlign;

  ///[maxLines] is the maximum number of lines the text can occupy.
  final int? maxLines;

  ///[overflow] is the behavior when the text overflows its container.
  final TextOverflow? overflow;

  ///[softWrap] is a flag that indicates whether the text should break at soft line breaks.
  final bool? softWrap;

  ///[textDirection] is the direction of the text.
  final TextDirection? textDirection;

  ///[fontFamily] is the font family of the text.
  final String? fontFamily;

  ///[fontSize] is the size of the text.
  final double? fontSize;

  ///[fontWeight] is the weight of the text.
  final FontWeight? fontWeight;

  ///[color] is the color of the text.
  final Color? color;

  ///[letterSpacing] is the spacing between letters.
  final double? letterSpacing;

  ///[decoration] is the decoration of the text.
  final TextDecoration? decoration;

  ///[decorationColor] is the color of the text decoration.
  final Color? decorationColor;

  ///[textHeight] is the height of the text.
  final double? textHeight;

  ///[CustomText] constructor initializes the text and its properties.

  const CustomText({
    super.key,
    required this.text,
    this.textAlign = TextAlign.start,
    this.maxLines = 1,
    this.overflow,
    this.softWrap,
    this.textDirection,
    this.fontFamily,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w600,
    this.color,
    this.letterSpacing,
    this.decoration,
    this.decorationColor,
    this.textHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color ?? AppColor.black,
        decoration: decoration,
        letterSpacing: letterSpacing,
        decorationColor: decorationColor,
        height: textHeight,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      textDirection: textDirection,
    );
  }
}
