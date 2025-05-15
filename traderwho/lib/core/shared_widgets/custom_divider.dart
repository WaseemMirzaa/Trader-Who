import 'package:flutter/material.dart';

import '../theme/app_color.dart';

/// A [CustomDivider] widget that allows customization of color, thickness, and indent.
class CustomDivider extends StatelessWidget {
  ///[Color] of the divider
  final Color? color;

  ///[double] thickness of the divider
  final double thickness;

  ///[double] indent of the divider
  final double indent;

  ///[double] endIndent of the divider
  final double endIndent;

  ///[CustomDivider] constructor
  const CustomDivider({
    super.key,
    this.color,
    this.thickness = 0.5,
    this.indent = 0.0,
    this.endIndent = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: color ?? AppColor.lightGray,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
    );
  }
}
