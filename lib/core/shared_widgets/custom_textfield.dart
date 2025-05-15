import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_color.dart';
import '../theme/constant.dart';
import 'custom_text.dart';

/// A [CustomTextField] widget that provides a consistent design and functionality across the app.
class CustomTextField extends StatefulWidget {
  // Existing parameters...
  final bool enabled;
  final int? maxLines;
  final bool readOnly;
  final int? maxLength;
  final Widget? prefix;
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
  final double? height;
  final double? width;
  final bool autofocus;

  /// [passwordToggleIconColor] is used to set the color of the password toggle icon.
  /// Defaults to [AppColor.white] if not provided.
  final Color? passwordToggleIconColor;

  const CustomTextField({
    super.key,
    this.onTap,
    this.prefix,
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
    this.textAlign = TextAlign.start,
    this.textColor = AppColor.mediumGray,
    this.textInputAction = TextInputAction.go,
    this.borderColor = AppColor.lightGray,
    this.fillColor = AppColor.veryLightGray,
    this.fieldHeading,
    this.height = 60,
    this.width,
    this.autofocus = false,
    this.passwordToggleIconColor = AppColor.white, // Default to white
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
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
        widget.fieldHeading != null
            ? Padding(
                padding: kOB10,
                child: CustomText(
                  text: widget.fieldHeading!,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColor.mediumGray,
                ),
              )
            : const SizedBox.shrink(),
        SizedBox(
          height: widget.height,
          width: widget.width ?? double.maxFinite,
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
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              prefix: widget.prefix,
              suffix: widget.suffix,
              counterText: '',
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.showPasswordToggle
                  ? IconButton(
                      onPressed: () => setState(() => _obscureText = !_obscureText),
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: widget.passwordToggleIconColor ?? AppColor.white, // Use custom color or default to white
                      ),
                    )
                  : widget.suffixIcon,
              hintText: widget.hintText,
              errorMaxLines: widget.errorMaxLines,
              contentPadding: widget.contentPadding ??
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              errorStyle: const TextStyle(color: AppColor.red),
              hintStyle: widget.hintStyle ??
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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