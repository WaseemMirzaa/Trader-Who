import 'package:flutter/material.dart';
import 'package:traderwho/core/theme/assets.dart';
import '../theme/app_color.dart';
import '../theme/constant.dart';
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
  final double? height;
  final double? width;
  final TextStyle? hintStyle;
  final String? Function(T?)? validator;
  final Color dropdownIconColor;
  final bool isExpanded;

  const CustomDropdown({
    super.key,
    this.value,
    this.hintText,
    this.fieldHeading,
    required this.items,
    this.onChanged,
    this.prefixIcon,
    this.borderRadius,
    this.borderColor = AppColor.lightGray,
    this.fillColor = AppColor.veryLightGray,
    this.height = 60,
    this.width,
    this.hintStyle,
    this.validator,
    this.dropdownIconColor = AppColor.mediumGray,
    this.isExpanded = true, // Changed to true
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (fieldHeading != null)
          Padding(
            padding: kOB10,
            child: CustomText(
              text: fieldHeading!,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColor.mediumGray,
            ),
          ),
        SizedBox(
          height: height,
          width: width ?? double.maxFinite,
          child: DropdownButtonFormField<T>(
            value: value,
            items: items,
            onChanged: onChanged,
            validator: validator,
            isExpanded: isExpanded,
            icon: Padding(
              padding: const EdgeInsets.only(left: 5.0), // Reduced padding
              child: Image.asset(
                Assets.imagesArrowDown,
                width: 24,
                height: 24,
                color: dropdownIconColor,
              ),
            ),
            dropdownColor: AppColor.white,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColor.midGray,
              overflow: TextOverflow.ellipsis, // Prevent text overflow
            ),
            decoration: InputDecoration(
              prefixIcon: prefixIcon,
              hintText: hintText,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12, // Reduced from 20 to 12
                vertical: 20,
              ),
              errorStyle: const TextStyle(color: AppColor.red),
              hintStyle: hintStyle ??
                  const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColor.midGray,
                  ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor),
                borderRadius: BorderRadius.all(
                  Radius.circular(borderRadius ?? 15),
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor),
                borderRadius: BorderRadius.all(
                  Radius.circular(borderRadius ?? 15),
                ),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.red),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor),
                borderRadius: BorderRadius.all(
                  Radius.circular(borderRadius ?? 15),
                ),
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.red),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              fillColor: fillColor,
              filled: true,
            ),
            // Ensure dropdown items are constrained
            menuMaxHeight: MediaQuery.of(context).size.height * 0.4,
            itemHeight: kMinInteractiveDimension, // Standard item height
          ),
        ),
      ],
    );
  }
}