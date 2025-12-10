import 'package:flutter/material.dart';
import 'package:traderou/core/theme/assets.dart';

import '../theme/app_color.dart';
import 'custom_text.dart';

class CustomDropdown<T> extends StatelessWidget {
  final T? value;
  final String? hintText;
  final String? fieldHeading;
  final List<DropdownMenuItem<T>> items;
  final Function(T?)? onChanged;
  final Widget? prefixIcon;
  final double? borderRadius;
  final Color borderColor;
  final Color fillColor;
  final double? width;
  final TextStyle? hintStyle;
  final String? Function(T?)? validator;
  final Color dropdownIconColor;
  final bool isExpanded;
  final EdgeInsetsGeometry? contentPadding;
  final double? menuMaxHeight;
  final double menuWidthFactor;

  const CustomDropdown({
    super.key,
    this.value,
    this.hintText,
    this.fieldHeading,
    required this.items,
    this.onChanged,
    this.prefixIcon,
    this.borderRadius,
    this.borderColor = AppColor.white,
    this.fillColor = AppColor.veryLightGray,
    this.width,
    this.hintStyle,
    this.validator,
    this.dropdownIconColor = AppColor.mediumGray,
    this.isExpanded = true,
    this.contentPadding,
    this.menuMaxHeight,
    this.menuWidthFactor = 0.8, // Default to 80% of input width
  });

  @override
  Widget build(BuildContext context) {
    final borderRadiusValue = borderRadius ?? 10;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (fieldHeading != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: CustomText(
              text: fieldHeading!,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColor.grayHintText,
            ),
          ),
        SizedBox(
          height: 45, // Updated height to 45
          width: width ?? double.maxFinite,
          child: DropdownButtonFormField<T>(
            value: value,
            items: items,
            onChanged: onChanged,
            validator: validator,
            isExpanded: isExpanded,
            icon: Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Image.asset(
                Assets.imagesArrowDown,
                width: 16,
                height: 16,
                color: dropdownIconColor,
              ),
            ),
            dropdownColor: AppColor.white,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColor.grayHintText,
              overflow: TextOverflow.ellipsis,
            ),
            decoration: InputDecoration(
              prefixIcon:
                  prefixIcon != null
                      ? Padding(
                        padding: const EdgeInsets.only(left: 8, right: 4),
                        child: SizedBox(height: 20, child: prefixIcon),
                      )
                      : null,
              prefixIconConstraints: const BoxConstraints(maxHeight: 24),
              hintText: hintText,
              contentPadding:
                  contentPadding ??
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              errorStyle: const TextStyle(
                color: AppColor.red,
                fontSize: 10,
                height: 0.8,
              ),
              hintStyle:
                  hintStyle ??
                  const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColor.midGray,
                  ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor),
                borderRadius: BorderRadius.all(
                  Radius.circular(borderRadiusValue),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor),
                borderRadius: BorderRadius.all(
                  Radius.circular(borderRadiusValue),
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor),
                borderRadius: BorderRadius.all(
                  Radius.circular(borderRadiusValue),
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColor.red),
                borderRadius: BorderRadius.all(
                  Radius.circular(borderRadiusValue),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor),
                borderRadius: BorderRadius.all(
                  Radius.circular(borderRadiusValue),
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColor.red),
                borderRadius: BorderRadius.all(
                  Radius.circular(borderRadiusValue),
                ),
              ),
              fillColor: fillColor,
              filled: true,
              isDense: true,
            ),
            menuMaxHeight:
                menuMaxHeight ?? MediaQuery.of(context).size.height * 0.4,
            borderRadius: BorderRadius.circular(borderRadiusValue),
            itemHeight: kMinInteractiveDimension,
            selectedItemBuilder: (BuildContext context) {
              return items.map((DropdownMenuItem<T> item) {
                return Container(
                  alignment: Alignment.centerLeft,
                  constraints: BoxConstraints(
                    maxWidth:
                        (width ?? MediaQuery.of(context).size.width) *
                        menuWidthFactor,
                  ),
                  child: item.child,
                );
              }).toList();
            },
          ),
        ),
      ],
    );
  }
}
