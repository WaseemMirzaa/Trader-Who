import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_color.dart';
import '../theme/constant.dart';
import 'custom_text.dart';

class TextFieldCustom extends StatefulWidget {
  final bool enabled;
  final int? maxLines;
  final bool readOnly;
  final int? maxLength;
  final Widget? suffix;
  final String? hintText;
  final bool obscureText;
  final int? errorMaxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextAlign textAlign;
  final VoidCallback? onTap;
  final Color? textColor;
  final String? initialValue;
  final double? borderRadius;
  final TextStyle? hintStyle;
  final FocusNode? focusNode;
  final bool showPasswordToggle;
  final EdgeInsets? contentPadding;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final Function()? onEditingComplete;
  final TextInputAction? textInputAction;
  final TextEditingController? controller;
  final Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final Color borderColor;
  final Color fillColor;
  final String? fieldHeading;
  final String? prefixLabel; // Renamed from leftLabel to prefixLabel
  final double? height;
  final double? width;
  final bool autofocus;
  final Color? passwordToggleIconColor;
  final TextStyle? prefixLabelStyle; // Style for the prefix label

  const TextFieldCustom({
    super.key,
    this.onTap,
    this.suffix,
    this.hintText,
    this.maxLines = 1,
    this.maxLength,
    this.focusNode,
    this.hintStyle,
    this.onChanged,
    this.validator,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.initialValue,
    this.borderRadius,
    this.keyboardType,
    this.errorMaxLines,
    this.enabled = true,
    this.contentPadding,
    this.inputFormatters,
    this.readOnly = false,
    this.onFieldSubmitted,
    this.onEditingComplete,
    this.obscureText = false,
    this.showPasswordToggle = false,
    this.textAlign = TextAlign.end, // Default to end alignment
    this.textColor = AppColor.mediumGray,
    this.textInputAction = TextInputAction.go,
    this.borderColor = AppColor.lightGray,
    this.fillColor = AppColor.veryLightGray,
    this.fieldHeading,
    this.prefixLabel, // Updated parameter
    this.height = 60,
    this.width,
    this.autofocus = false,
    this.passwordToggleIconColor = AppColor.white,
    this.prefixLabelStyle, // Updated parameter
  });

  @override
  _TextFieldCustomState createState() => _TextFieldCustomState();
}

class _TextFieldCustomState extends State<TextFieldCustom> {
  bool _obscureText = false;

  @override
  void initState() {
    if (widget.showPasswordToggle || widget.obscureText) {
      _obscureText = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (widget.fieldHeading != null)
          Padding(
            padding: kOB10,
            child: CustomText(
              text: widget.fieldHeading!,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColor.secondaryText,
            ),
          ),
        SizedBox(
          height: widget.height,
          width: widget.width,
          child: TextFormField(
            onTap: widget.onTap,
            enabled: widget.enabled,
            maxLines: widget.maxLines,
            readOnly: widget.readOnly,
            obscureText: _obscureText,
            cursorColor: AppColor.black,
            textAlign: widget.textAlign,
            maxLength: widget.maxLength,
            focusNode: widget.focusNode,
            validator: widget.validator,
            onChanged: widget.onChanged,
            controller: widget.controller,
            initialValue: widget.initialValue,
            keyboardType: widget.keyboardType,
            inputFormatters: widget.inputFormatters,
            textInputAction: widget.textInputAction,
            onFieldSubmitted: widget.onFieldSubmitted,
            onEditingComplete:
                widget.onEditingComplete ??
                () {
                  if (widget.textInputAction?.name == 'go' ||
                      widget.textInputAction?.name == 'next') {
                    FocusManager.instance.primaryFocus?.nextFocus();
                  } else {
                    FocusManager.instance.primaryFocus?.unfocus();
                  }
                },
            autofocus: widget.autofocus,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: widget.textColor,
            ),

            decoration: InputDecoration(
              prefix:
                  widget.prefixLabel != null
                      ? Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          widget.prefixLabel!,
                          style:
                              widget.prefixLabelStyle ??
                              const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColor.mediumGray,
                              ),
                        ),
                      )
                      : null,
              suffix: widget.suffix,
              counterText: '',
              prefixIcon: widget.prefixIcon,
              suffixIcon:
                  widget.showPasswordToggle
                      ? IconButton(
                        onPressed:
                            () => setState(() => _obscureText = !_obscureText),
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: widget.passwordToggleIconColor,
                        ),
                      )
                      : widget.suffixIcon,
              hintText: widget.hintText,
              errorMaxLines: widget.errorMaxLines,
              contentPadding:
                  widget.contentPadding ??
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              errorStyle: const TextStyle(color: AppColor.red),
              hintStyle:
                  widget.hintStyle ??
                  const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColor.mediumGray,
                  ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: widget.borderColor),
                borderRadius: BorderRadius.all(
                  Radius.circular(widget.borderRadius ?? 15),
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: widget.borderColor),
                borderRadius: BorderRadius.all(
                  Radius.circular(widget.borderRadius ?? 15),
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColor.red),
                borderRadius: BorderRadius.all(
                  Radius.circular(widget.borderRadius ?? 15),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: widget.borderColor),
                borderRadius: BorderRadius.all(
                  Radius.circular(widget.borderRadius ?? 15),
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColor.red),
                borderRadius: BorderRadius.all(
                  Radius.circular(widget.borderRadius ?? 15),
                ),
              ),
              fillColor: widget.fillColor,
              filled: true,
            ),
          ),
        ),
      ],
    );
  }
}
