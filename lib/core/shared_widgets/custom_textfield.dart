import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_color.dart';
import '../theme/constant.dart';
import 'custom_text.dart';

/// A [CustomTextField] widget that provides a consistent design and functionality across the app.

class CustomTextField extends StatefulWidget {
  ///[enabled] is used to enable or disable the text field.
  final bool enabled;

  ///[maxLines] is used to set the maximum number of lines for the text field.
  final int? maxLines;

  ///[readOnly] is used to set the text field to read-only mode.
  final bool readOnly;

  ///[maxLength] is used to set the maximum length of the text field.
  final int? maxLength;

  ///[prefix] is used to set a widget before the text field.
  final Widget? prefix;

  ///[suffix] is used to set a widget after the text field.
  final Widget? suffix;

  ///[hintText] is used to set the hint text for the text field.
  final String? hintText;

  ///[obscureText] is used to set the text field to obscure text mode.
  final bool obscureText;

  ///[errorMaxLines] is used to set the maximum number of lines for the error message.
  final int? errorMaxLines;

  ///[prefixIcon] is used to set a widget before the text field.
  final Widget? prefixIcon;

  ///[suffixIcon] is used to set a widget after the text field.
  final Widget? suffixIcon;

  ///[textAlign] is used to set the text alignment for the text field.
  final TextAlign textAlign;

  ///[onTap] is used to set the text input action for the text field.
  final VoidCallback? onTap;

  ///[textColor] is used to set the text color for the text field.
  final Color? textColor;

  ///[initialValue] is used to set the initial value for the text field.
  final String? initialValue;

  ///[borderRadius] is used to set the border radius for the text field.
  final double? borderRadius;

  ///[hintStyle] is used to set the hint text style for the text field.
  final TextStyle? hintStyle;

  ///[focusNode] is used to set the focus node for the text field.
  final FocusNode? focusNode;

  ///[showPasswordToggle] is used to show a password toggle button for the text field.
  final bool showPasswordToggle;

  ///[contentPadding] is used to set the content padding for the text field.
  final EdgeInsets? contentPadding;

  ///[onChanged] is used to set the onChanged callback for the text field.
  final Function(String)? onChanged;

  ///[keyboardType] is used to set the keyboard type for the text field.
  final TextInputType? keyboardType;

  ///[onEditingComplete] is used to set the onEditingComplete callback for the text field.
  final Function()? onEditingComplete;

  ///[textInputAction] is used to set the text input action for the text field.
  final TextInputAction? textInputAction;

  ///[controller] is used to set the text editing controller for the text field.
  final TextEditingController? controller;

  ///[onFieldSubmitted] is used to set the onFieldSubmitted callback for the text field.
  final Function(String)? onFieldSubmitted;

  ///[validator] is used to set the validator function for the text field.
  final String? Function(String?)? validator;

  ///[inputFormatters] is used to set the input formatters for the text field.
  final List<TextInputFormatter>? inputFormatters;

  ///[borderColor] is used to set the border color for the text field.
  final Color borderColor;

  ///[fillColor] is used to set the fill color for the text field.
  final Color fillColor;

  ///[fieldHeading] is used to set the field heading for the text field.
  final String? fieldHeading;

  ///[height] is used to set the height for the text field.
  final double? height;

  ///[width] is used to set the width for the text field.
  final double? width;

  ///[autofocus] is used to set the autofocus for the text field.
  final bool autofocus;

  ///[CustomTextField] constructor.

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
              suffixIcon:
                  widget.showPasswordToggle
                      ? IconButton(
                        onPressed:
                            () => setState(() => _obscureText = !_obscureText),
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColor.black,
                        ),
                      )
                      : widget.suffixIcon,
              hintText: widget.hintText,
              errorMaxLines: widget.errorMaxLines,
              contentPadding:
                  widget.contentPadding ??
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              errorStyle: const TextStyle(color: AppColor.red),
              hintStyle:
                  widget.hintStyle ??
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
