import 'package:flutter/material.dart';

import '../theme/app_color.dart';
import 'custom_text.dart';

/// A [FormatSelector] widget that allows the user to select a format (QR or Code) using radio buttons.
class FormatSelector extends StatefulWidget {
  ///[FormatSelector] constructor
  const FormatSelector({super.key});

  @override
  State<FormatSelector> createState() => _FormatSelectorState();
}

class _FormatSelectorState extends State<FormatSelector> {
  String _selectedFormat = 'QR';

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 20,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Radio<String>(
              value: 'QR',
              activeColor: AppColor.navyBlue,
              groupValue: _selectedFormat,
              fillColor: MaterialStateProperty.resolveWith<Color>((
                Set<WidgetState> states,
              ) {
                if (states.contains(MaterialState.selected)) {
                  return AppColor.navyBlue;
                }
                return AppColor.navyBlue;
              }),
              onChanged: (String? value) {
                setState(() {
                  _selectedFormat = value!;
                });
              },
            ),
            const CustomText(text: 'QR'),
          ],
        ),
        Row(
          children: [
            Radio<String>(
              value: 'Code',
              activeColor: AppColor.navyBlue,
              groupValue: _selectedFormat,
              fillColor: MaterialStateProperty.resolveWith<Color>((
                Set<WidgetState> states,
              ) {
                if (states.contains(MaterialState.selected)) {
                  return AppColor.navyBlue;
                }
                return AppColor.navyBlue;
              }),
              onChanged: (String? value) {
                setState(() {
                  _selectedFormat = value!;
                });
              },
            ),
            const CustomText(text: 'CODE'),
          ],
        ),
      ],
    );
  }
}
