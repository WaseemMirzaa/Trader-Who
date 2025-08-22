import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:traderwho/core/theme/app_color.dart';

class CustomTextField extends StatefulWidget {
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
  final TextStyle? headingStyle; // New parameter for heading style
  final String? leftLabel;
  final double? height;
  final double? width;
  final bool autofocus;
  final Color? passwordToggleIconColor;
  final bool isCircular;
  final double? circularRadius;
  final FontStyle? fontStyle;

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
    this.textColor = AppColor.primaryText,
    this.textInputAction = TextInputAction.go,
    this.borderColor = AppColor.primaryText,
    this.fillColor = Colors.white,
    this.fieldHeading,
    this.headingStyle, // Added headingStyle parameter
    this.leftLabel,
    this.height,
    this.width,
    this.autofocus = false,
    this.passwordToggleIconColor = AppColor.lightGrayText,
    this.isCircular = false,
    this.circularRadius,
    this.fontStyle,
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
    // Calculate effective height
    final effectiveHeight = widget.height ?? (widget.isCircular ? 40.0 : 55.0);

    // Calculate effective border radius
    final effectiveBorderRadius =
        widget.isCircular
            ? widget.circularRadius ?? effectiveHeight / 2
            : widget.borderRadius ?? 15.0;

    // Calculate effective width - match height if circular
    final effectiveWidth = widget.isCircular ? effectiveHeight : widget.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (widget.fieldHeading != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              widget.fieldHeading!,
              style:
                  widget.headingStyle ??
                  TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColor.lightGrayText,
                  ),
            ),
          ),
        SizedBox(
          width: effectiveWidth,
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
              fontWeight: FontWeight.w400,
              fontStyle: widget.fontStyle ?? FontStyle.italic,
              color: widget.textColor,
            ),
            decoration: InputDecoration(
              prefix: widget.prefix,
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
              hintText: widget.hintText ?? widget.leftLabel,
              errorMaxLines: widget.errorMaxLines,
              contentPadding:
                  widget.contentPadding ??
                  EdgeInsets.symmetric(
                    horizontal: widget.isCircular ? effectiveHeight / 3 : 16,
                    vertical:
                        widget.isCircular ? (effectiveHeight - 20) / 2 : 15,
                  ),
              errorStyle: const TextStyle(color: Colors.red),
              hintStyle:
                  widget.hintStyle ??
                  const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColor.lightGrayText,
                  ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: widget.borderColor),
                borderRadius: BorderRadius.circular(effectiveBorderRadius),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: widget.borderColor),
                borderRadius: BorderRadius.circular(effectiveBorderRadius),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(effectiveBorderRadius),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: widget.borderColor),
                borderRadius: BorderRadius.circular(effectiveBorderRadius),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(effectiveBorderRadius),
              ),
              fillColor: widget.fillColor,
              filled: true,
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }
}
